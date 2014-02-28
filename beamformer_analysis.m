function beamformer_analysis(cfg)
%BEAMFORMER_ANALYSIS
%   BEAMFORMER_ANALYSIS(CFG)
%
%   cfg
%       head_cfg
%       beamformer_config
%       data_file
%       loc    indices of vertices to scan (default = all vertices)
%       force   (optional, boolean) default = false
%           forces beamformer analysis and overwrites any existing analysis
%       perturb_config (optional)
%           config specifying the covariance matrix of random perturbation
%           for leadfield matrix
%       tag (optional)
%           additional tag for the output file name
%       

if ~isfield(cfg,'force'), cfg.force = false; end

%% Load the data
data_in = load(cfg.data_file); % loads data
data = data_in.data;
clear data_in;

%% Load the beamformer config
cfg_beam = beamformer_configs.get_config(...
    cfg.beamformer_config{:}, 'data', data);

%% Set up the output file name
tmpcfg = [];
tmpcfg.file_name = cfg.data_file;
% Construct the tag
tmpcfg.tag = strrep(cfg_beam.name,' ','_');
% Add perturb name to the output file
if isfield(cfg, 'perturb_config')
    tmpcfg.tag = [tmpcfg.tag '_' cfg.perturb_config];
end
% Add the additional tag to the output file name, typically if it's a
% different head model
if isfield(cfg, 'tag')
    tmpcfg.tag = [tmpcfg.tag '_' cfg.tag];
end
save_file = db.save_setup(tmpcfg);

%% Check if the analysis already exists
if exist(save_file,'file') && ~cfg.force
    if verLessThan('matlab', '7.14')
        [~,name,~,~] = fileparts(save_file);
    else
        [~,name,~] = fileparts(save_file);
    end
   fprintf('File exists: %s\n', name);
   fprintf('Skipping beamformer analysis\n');
   return
else
    fprintf('Analyzing: %s\n',cfg.data_file);
    fprintf('Running: %s\n',cfg_beam.name);
end

%% Load the head model
data_in = hm_get_data(cfg.head_cfg);
head = data_in.head;
clear data_in;

%% Finalize locations to scan
if ~isfield(cfg, 'loc')
    % Scanning all vertices in head model
    cfg.loc = 1:size(head.GridLoc,1);
end

%% Calculate the covariance
if ~isfield(data,'R')
    data.R = aet_analysis_cov(data.avg_trials);
    % Calculate it once and save it to the data file
    save(cfg.data_file, 'data');
end

%% Finalize the beamformer config
% Add the covariance matrix
cfg_beam.R = data.R;
% Add the head model if it's not a perturbed scenario
if ~isfield(cfg, 'perturb_config')
    cfg_beam.head_model = head;
end
% Print a warning just in case for cvx
if isfield(cfg_beam,'solver')
    if isequal(cfg_beam.solver,'cvx')
        warning('reb:beamformer_analysis',...
            'Make sure you''re not running in parfor');
    end
end

%% Load the perturb config
if isfield(cfg, 'perturb_config')
    cfg_mis = perturb_configs.get_config(...
        cfg.perturb_config, data);
    fprintf('Mismatch: %s\n',cfg.perturb_config);
end

%% Set up the output
out = [];
out.data_file = cfg.data_file;
out.head_cfg = cfg.head_cfg;
out.snr = data.snr;
out.iteration = data.iteration;
out.beamformer_config = cfg.beamformer_config;

n_components = 3;
n_time = size(data.avg_trials,2);
n_vertices = length(cfg.loc);
out.beamformer_output = zeros(n_components, n_vertices, n_time);

n_scans = length(cfg.loc);

%% Scan locations
for i=1:n_scans
    fprintf('%s snr %d iter %d %d/%d\n',...
        cfg_beam.name,out.snr,out.iteration,i,n_scans);
    idx = cfg.loc(i);
    
    % Check if it's a perturbed scenario
    % FIXME This stuff should really be in the data generation pipeline
    % Not in the beamformer
    if isfield(cfg, 'perturb_config')
        cfg_mis.head_model = head;
        cfg_mis.loc = idx;
        [cfg_beam.H,E] = aet_analysis_perturb_leadfield(cfg_mis);
    end
    
    % Set the location to scan
    cfg_beam.loc = idx;
    % Calculate the beamformer
    beam_out = aet_analysis_beamform(cfg_beam);
    out.filter{i} = beam_out.W;
    out.leadfield{i} = beam_out.H;
    out.loc(i) = idx;
    if isfield(cfg, 'perturb_config')
        out.perturb{i} = E;
    end
    
    % Calculate the beamformer output for each component
    tmpcfg =[];
    tmpcfg.W = beam_out.W;
    tmpcfg.type = cfg_beam.type;
    beam_signal = aet_analysis_beamform_output(...
        tmpcfg, data.avg_trials);
    
    % Save the output of the beamformer
    for j=1:n_components
        out.beamformer_output(j,i,:) = beam_signal(j,:);
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