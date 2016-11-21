function beamformer_analysis_recompute_output(cfg)
%BEAMFORMER_ANALYSIS_RECOMPUTE_OUTPUT
%   BEAMFORMER_ANALYSIS_RECOMPUTE_OUTPUT(CFG)
%
%   cfg
%       head    
%           struct containing config for the head models used
%       head.current
%           struct containing config for the head model used for the
%           beamformer analysis, can be estimated or exact
%
%           type    current head model type
%           file    current head model file
%
%       head.actual  
%           struct containing config for the actual head model used to
%           generate the data (only used for anisotropic rmv)
%
%           type     actual head model type
%           file     actual head model file
%
%       beamformer_config
%           cell array of key-value pairs specifying the beamformer to use,
%           see beamformer_config.get_config()
%       data_file
%           name of file containing the EEG data
%
%       cov_type (string, default = time)
%           selects which covariance to use, options: time, trial
%
%           time
%           the time-wise covariance is computed over all time samples of
%           the average trial
%
%           trial
%           the trial-wise covariance is computed over all trials at each
%           sample. the covariance is then taken over the samples specified
%           in cov_samples
%
%       cov_samples (optional, default = full sample range)
%           indices of signal samples to use to compute sample covariance
%
%           when cov_type = 'trial', the beamformer filters are computed
%           using a sample specific covariance
%       data_samples (optional, default = full sample range)
%           indices of signal samples to use for beamformer output
%
%       loc
%           (default = all vertices)
%           indices of vertices to scan 
%       force
%           (boolean, default = false)
%           forces beamformer analysis and overwrites any existing analysis
%       tag (optional)
%           additional tag for the output file name
%
%       Output options
%       --------------
%       

if ~isfield(cfg,'force'),           cfg.force = false; end
if ~isfield(cfg,'cov_type'),        cfg.cov_type = 'time'; end
if ~isfield(cfg,'cov_samples'),     cfg.cov_samples = []; end

%% Load the beamformer
fbeamformer = str2func(cfg.beamformer_config{1});
beamformer = fbeamformer(cfg.beamformer_config{2:end});

%% Set up the output file name
% Construct the beamformer tag
bf_tag = strrep(beamformer.name,'.','-');
bf_tag = strrep(bf_tag,' ','_');

tag = bf_tag;
if isfield(cfg, 'tag') && ~isempty(cfg.tag)
    % Add the additional tag to the output file name, typically if it's a
    % different head model
    tag = [tag '_' cfg.tag];
end
save_file = db.save_setup('file_name',cfg.data_file,'tag',tag);

%% Print Message
fprintf('Re-Analyzing: %s\n',save_file);

%% Load the beamformer output data
fprintf('Loading output data...');
out_in = load(save_file);
fprintf('Loaded\n');
out = out_in.source;
clear out_in;

%% Load the data
fprintf('Loading data...');
data_in = load(cfg.data_file); % loads data
fprintf('Loaded\n');
data = data_in.data;
clear data_in;

%% Calculate the covariance

if ~isfield(cfg,'data_samples') || isempty(cfg.data_samples)
    if isfield(data,'avg_trials')
        cfg.data_samples = 1:size(data.avg_trials,2);
    elseif isfield(data,'trials')
        cfg.data_samples = 1:size(data.trials{1},2);
    end
end

save_to_file = false;
switch cfg.cov_type
    case 'time'
        if isfield(data,'R')
            % remove old field
            data.Rtime = data.R;
            data = rmfield(data,'R');
            save_to_file = true;
        end
        
        % compute time-wise covariance if it doesn't exist
        if ~isfield(data,'Rtime')
            data.Rtime = aet_analysis_cov(data.avg_trials);
            save_to_file = true;
        end
        
        % copy covariance
        R = data.Rtime;
        cfg.cov_samples = 1:size(data.avg_trials,2);
        
        if save_to_file
            % calculate it once and save it to the data file
            save(cfg.data_file, 'data','-v7.3');
        end
        
    case 'trial'
        if isempty(cfg.cov_samples)
            error('cov samples is required');
        end
        
        if ~isfield(data,'avg_trials')
            data.avg_trials = zeros(size(data.trials{1}));
            for i=1:length(data.trials)
                data.avg_trials = data.avg_trials + data.trials{i};
            end
            data.avg_trials = data.avg_trials/length(data.trials);
            save_to_file = true;
        end
        
        if ~isfield(data,'avg_trials_zeromean')
            data.avg_trials_zeromean = zeros(size(data.trials{1}));
            for i=1:length(data.trials)
                data.avg_trials_zeromean = data.avg_trials_zeromean...
                    + zero_mean(data.trials{i});
            end
            data.avg_trials_zeromean = data.avg_trials_zeromean/length(data.trials);
            save_to_file = true;
        end
    
        if save_to_file
            % Calculate it once and save it to the data file
            save(cfg.data_file, 'data','-v7.3');
        end
        
        % compute trial-wise covariance if it doesn't exist
        if ~isfield(data,'Rtrial')
            Rtrial = aet_analysis_cov(data.trials);
            %save_to_file = false;
            % don't save to file, it's faster to re-compute than to reload
            % and takes up a lot of disk space
        end
        
        % select covariance for a specific cov_samples
        R = Rtrial(cfg.cov_samples,:,:);
        R = mean(R,1); % [1 channels channels]
        R = squeeze(R);
        clear Rtrial
        
    otherwise
        error('unknown covariance type');
end

%% Finalize locations to scan
if ~isfield(cfg, 'loc')
    % Scanning all vertices in head model
    cfg.loc = 1:size(hm.data.GridLoc,1);
end

%% Finalize the beamformer config
% Print a warning just in case for cvx
if isprop(beamformer,'solver')
    if isequal(beamformer.solver,'cvx')
        warning('reb:beamformer_analysis',...
            'Make sure you''re not running in parfor');
    end
end

%% set up vars for beamforming

n_components = 3;

n_scans = length(cfg.loc);

% select sample points based on the data_samples parameter
data_trials = data.avg_trials_zeromean(:,cfg.data_samples);

% allocate mem
beam_signal = zeros(n_scans, length(cfg.data_samples), n_components);

% set up progress bar
progbar = ProgressBar(n_scans);

filters = out.filter;

%% Scan locations
parfor i=1:n_scans
% for i=1:n_scans

    % update progress bar
    progbar.progress();
    
    beam_signal(i,:,:) = beamformer.output(...
        filters{i}, data_trials, 'P', [])';
    
end
fprintf('\n');

% Update the output
% rearrange the output
out.beamformer_output = permute(beam_signal, [3 1 2]); % [components vertices time]

%% Save beamformer output
source = out;
save(save_file, 'source','-v7.3');


end