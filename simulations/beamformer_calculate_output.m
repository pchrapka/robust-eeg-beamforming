function beamformer_calculate_output(cfg)
%BEAMFORMER_CALCULATE_OUTPUT
%   BEAMFORMER_CALCULATE_OUTPUT(CFG)
%
%   cfg
%       beamformer_config
%           cell array of key-value pairs specifying the beamformer to use,
%           see beamformer_config.get_config()
%       data_file
%           name of file containing the EEG data
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

if ~isfield(cfg,'force'), cfg.force = false; end
if isequal(cfg.data_file,'dummy'), return; end % Check for a dummy file

%% Load the EEG data
data_in = load(cfg.data_file); % loads data
data = data_in.data;
clear data_in;

%% Load the beamformer
fbeamformer = str2func(cfg.beamformer_config{1});
beamformer = fbeamformer(cfg.beamformer_config{2:end});

%% Set up the output file name
tmpcfg = [];
tmpcfg.file_name = cfg.data_file;
% Construct the tag
name_temp = strrep(beamformer.name,'.','-');
tmpcfg.tag = strrep(name_temp,' ','_');
% Add the additional tag to the output file name, typically if it's a
% different head model
if isfield(cfg, 'tag')
    tmpcfg.tag = [tmpcfg.tag '_' cfg.tag];
end
save_file = db.save_setup(tmpcfg);

%% Load the analysis
if exist(save_file,'file') && ~cfg.force
    [~,name,~,~] = util.fileparts(save_file);
    fprintf('Loading: %s\n', name);
    bf_data = load(save_file);
else
    fprintf('Not found: %s\n',cfg.data_file);
    return
end

%% Finalize locations to scan
if ~isfield(cfg, 'loc')
    % Load the vertices that were scanned from last time
    cfg.loc = bf_data.source.loc;
end

%% Copy the last output
out = bf_data.source;

n_components = 3;
n_time = size(data.avg_trials,2);
n_vertices = length(cfg.loc);
out.beamformer_output = zeros(n_components, n_vertices, n_time);

n_scans = length(cfg.loc);

%% Scan locations
for i=1:n_scans
    fprintf('%s snr %d iter %d %d/%d\n',...
        beamformer.name,out.snr,out.iteration,i,n_scans);
    
    % Calculate the beamformer output for each component
    tmpcfg =[];
    tmpcfg.W = bf_data.source.filter{i};
    tmpcfg.type = beamformer.type;
    beam_signal = aet_analysis_beamform_output(...
        tmpcfg, data.avg_trials);
    
    % Save the output of the beamformer
    if isfield(cfg, 'time_idx')
        % Save only one time index
        for j=1:n_components
            % Save only one time index
            out.beamformer_output(j,i,1) = ...
                beam_signal(j, cfg.time_idx);
        end
        out.beamformer_output_type = ...
            ['time index: ' num2str(cfg.time_idx)];
    else
        % Save all of the beamformer output
        for j=1:n_components
            out.beamformer_output(j,i,:) = ...
                beam_signal(j,:);
        end
        out.beamformer_output_type = ...
            ['time index: 1:' size(beam_signal,2)];
    end
end
fprintf('\n');

%% Save the output
source = out;
save(save_file, 'source');
% Save just the beamformer_output
source = [];
source.beamformer_output = out.beamformer_output;
% Create a new file name
cfg.file_name = save_file;
cfg.tag = 'mini';
save_file = db.save_setup(cfg);
save(save_file, 'source');

% Revert
% path(cur_path);

end