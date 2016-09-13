function beamformer_analysis(cfg)
%BEAMFORMER_ANALYSIS
%   BEAMFORMER_ANALYSIS(CFG)
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
%           the time-wise covariance is computed over all time samples of
%           the average trial. the trial-wise covariance is computed over
%           all trials at each sample.
%       sample_idx (optional, default = full sample range)
%           indices of signal samples to use
%
%           when cov_type = 'trial', the beamformer filters are computed
%           using a sample specific covariance
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
%       time_idx (optional)
%           selects only one time index of the beamformer output when
%           saving the beamformer output, saves a considerable amount of
%           space
%       

if ~isfield(cfg,'force'),           cfg.force = false; end
% if isequal(cfg.data_file,'dummy'),  return; end % Check for a dummy file
% REMOVE
if ~isfield(cfg,'cov_type'),        cfg.cov_type = 'time'; end
if ~isfield(cfg,'sample_idx'),      cfg.sample_idx = 1:100; end % this should cause an error

%% Load the data
data_in = load(cfg.data_file); % loads data
data = data_in.data;
clear data_in;

%% Calculate the covariance
switch cfg.cov_type
    case 'time'
        if isfield(data,'R')
            % remove old field
            data.Rtime = data.R;
            data = rmfield(data,'R');
            save(cfg.data_file, 'data','-v7.3');
        end
        
        % compute time-wise covariance if it doesn't exist
        if ~isfield(data,'Rtime')
            data.Rtime = aet_analysis_cov(data.avg_trials);
            
            % calculate it once and save it to the data file
            save(cfg.data_file, 'data','-v7.3');
        end
        
        % copy covariance
        R = data.Rtime;
        cfg.sample_idx = 1:size(data.avg_trials,2);
        
    case 'trial'
        % compute trial-wise covariance if it doesn't exist
        if ~isfield(data,'Rtrial')
            data.Rtrial = aet_analysis_cov(data.trials);
        end
        
        % select covariance for a specific sample_idx
        if length(cfg.sample_idx) > 1
            error('feature not implemented');
        end
        R = data.Rtrial(cfg.sample_idx,:,:);
        
        if ~isfield(data,'avg_trials')
            data.avg_trials = zeros(size(data.trials{1}));
            for i=1:length(data.trials)
                data.avg_trials = data.avg_trials + data.trials{i};
            end
            data.avg_trials = data.avg_trials/length(data.trials);
            
            % TODO data.R will be [nsamples, nchannels, nchannels]
            % seems like a time idx option
        end
    
        % Calculate it once and save it to the data file
        save(cfg.data_file, 'data','-v7.3');
    otherwise
        error('unknown covariance type');
end

%% Load the beamformer
fbeamformer = str2func(cfg.beamformer_config{1});
beamformer = fbeamformer(cfg.beamformer_config{2:end});

%% Set up the output file name
% Construct the beamformer tag
bf_tag = strrep(beamformer.name,'.','-');
bf_tag = strrep(bf_tag,' ','_');

tmpcfg = [];
tmpcfg.file_name = cfg.data_file;
if isfield(cfg, 'tag')
    % Add the additional tag to the output file name, typically if it's a
    % different head model
    tmpcfg.tag = [bf_tag '_' cfg.tag];
else
    tmpcfg.tag = bf_tag;
end
save_file = db.save_setup(tmpcfg);

%% Check if the analysis already exists
if exist(save_file,'file') && ~cfg.force
    [~,name,~,~] = util.fileparts(save_file);
    fprintf('File exists: %s\n', name);
    fprintf('Skipping beamformer analysis\n');
    return
else
    fprintf('Analyzing: %s\n',cfg.data_file);
    fprintf('Running: %s\n',beamformer.name);
end

%% Load the head model
if isfield(cfg.head, 'current')
    % Get the estimated head model
    % Need to differentiate between actual and estimated head models in
    % mismatched scenario
    cfg.head.current.load();
    cfg.head.actual.load();
    hm = cfg.head.current;
else
    % Get the actual head model
    cfg.head.load();
    hm = cfg.head;
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
n_time = size(data.avg_trials,2);
n_vertices = length(cfg.loc);

n_scans = length(cfg.loc);

% Copy data for the parfor
out_snr = data.snr;
out_iteration = data.iteration;
scan_locs = cfg.loc;

% select sample points based on the sample_idx parameter
data_trials = data.avg_trials(:,cfg.sample_idx);

% allocate mem
beam_signal = zeros(n_scans, length(cfg.sample_idx), n_components);

%% Scan locations
parfor i=1:n_scans
% for i=1:n_scans
    
    idx = scan_locs(i);
    fprintf('%s snr %d iter %d loc %d %d/%d\n',...
        beamformer.name, out_snr, out_iteration, i, n_scans, idx);
    
    % Check for anisotropic rmv beamformer
    args = {};
    if ~isempty(regexp(beamformer.name, 'rmv aniso', 'match'))    
        % Generate the uncertainty matrix
        A = beamformer.create_uncertainty(...
            cfg.head.actual,...
            cfg.head.current, idx);
        args = {'A',A};
    end
    
    % get the leafield matrix from the head model
    H = hm.get_leadfield(idx);
    
    switch cfg.cov_type
        case 'time'
            % Calculate the beamformer
            beam_out = beamformer.inverse(H, R, args{:});
            
            out_filter{i} = beam_out.W;
            %     out_leadfield{i} = beam_out.H;
            out_loc(i) = idx;
            
            % Calculate the beamformer output for each component
            %     tmpcfg =[];
            %     tmpcfg.W = beam_out.W;
            %     tmpcfg.type = beamformer.type;
            beam_signal(i,:,:) = beamformer.output(...
                beam_out.W, data_trials)';
        case 'trial'
            if length(cfg.sample_idx) > 1
                warning('untested feature');
            end
            
            W = [];
            beam_signal_temp = zeros(length(cfg.sample_idx),n_components);
            for j=1:length(cfg.sample_idx)
                % Calculate the beamformer
                beam_out = beamformer.inverse(H, squeeze(R(j,:,:)), args{:});
                W(j,:,:) = beam_out.W;
                out_loc(i) = idx;
                
                beam_signal_temp(j,:) = beamformer.output(...
                    beam_out.W, data_trials(:,j))';
            end
            beam_signal(i,:,:) = beam_signal_temp;
            out_filter{i} = W;
    end
    
%     % Save the output of the beamformer
%     if isfield(cfg, 'time_idx')
%         % Save only one time index
%         for j=1:n_components
%             % Save only one time index
%             out_beamformer_output(j,i,1) = ...
%                 beam_signal(j, cfg.time_idx);
%         end
%         out_beamformer_output_type = ...
%             ['time index: ' num2str(cfg.time_idx)];
%     else
%         % Save all of the beamformer output
%         for j=1:n_components
%             out_beamformer_output(j,i,:) = ...
%                 beam_signal(j,:);
%         end
%         out_beamformer_output_type = ...
%             ['time index: 1:' size(beam_signal,2)];
%     end
end
fprintf('\n');

%% Set up the output
out = [];
out.data_file = cfg.data_file;
out.snr = data.snr;
out.iteration = data.iteration;
out.beamformer_config = cfg.beamformer_config;

% save the head model config, but not data
if isfield(cfg.head,'current')
    out.head_cfg.current.type = cfg.head.current.type;
    out.head_cfg.current.file = cfg.head.current.file;
    
    out.head_cfg.actual.type = cfg.head.actual.type;
    out.head_cfg.actual.file = cfg.head.actual.file;
else
    out.head_cfg.type = cfg.head.type;
    out.head_cfg.file = cfg.head.file;
end

% rearrange the output
% out.beamformer_output = zeros(n_components, n_vertices, n_time);
% beam_signal = zeros(n_scans, length(cfg.sample_idx), n_components);
out.beamformer_output = permute(beam_signal, [3 1 2]); % [components vertices time]
% for i=1:n_scans
%     % Save all of the beamformer output
%     for j=1:n_components
%         if isfield(cfg,'sample_idx')
%             out.beamformer_output(j,i,cfg.sample_idx) = ...
%                 beam_signal{i}(j,cfg.sample_idx);
%         else
%             out.beamformer_output(j,i,:) = ...
%                 beam_signal{i}(j,:);
%         end
%     end
%     out.beamformer_output_type = ...
%         ['time index: 1:' size(beam_signal,2)];
% end

out.filter = out_filter;
% out.leadfield = out_leadfield;
out.loc = out_loc;
% out.beamformer_output = out_beamformer_output;
% out.beamformer_output_type = out_beamformer_output_type;

%% Save beamformer output
source = out;
save(save_file, 'source','-v7.3');

%% Save beamformer output mini 
% % Save just the beamformer_output
% source = [];
% source.beamformer_output = out.beamformer_output;
% % Create a new file name
% cfg.file_name = save_file;
% cfg.tag = 'mini';
% save_file = db.save_setup(cfg);
% save(save_file, 'source');

% Revert
% path(cur_path);

end