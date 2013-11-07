function beamformer_analysis(cfg)
%BEAMFORMER_ANALYSIS
%   BEAMFORMER_ANALYSIS(CFG)
%
%   cfg
%       head_cfg
%       beamformer_config
%       data_file
%       loc    indices of vertices to scan (default = all vertices)
%       

% Load the head model
data_in = hm_get_data(cfg.head_cfg);
head = data_in.head;
clear data_in;

if ~isfield(cfg, 'loc')
    % Scanning all vertices in head model
    cfg.loc = 1:size(head.GridLoc,1);
end

% Load the data
data_in = load(cfg.data_file); % loads data
data = data_in.data;
clear data_in;
fprintf('Analyzing: %s\n',cfg.data_file);

% Calculate the covariance
if ~isfield(data,'R')
%     data.R = cov(data.avg_trials');
    N = size(data.avg_trials,1);
    data.R = (1/N)*(data.avg_trials*data.avg_trials');
    % Calculate it once and save it to the data file
    save(cfg.data_file, 'data');
end

% Load the beamformer config
cfg_beam = beamformer_configs.get_config(...
    cfg.beamformer_config, data);
fprintf('Running: %s\n',cfg.beamformer_config);
% Finish setting up the beamformer config
cfg_beam.R = data.R;
cfg_beam.head_model = head;
% Print a warning just in case for cvx
if isequal(cfg_beam.solver,'cvx')
    warning('reb:beamformer_analysis',...
        'Make sure you''re not running in parfor');
end

% Set up the output
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

% Setup a progress bar
n_scans = length(cfg.loc);
% cur_path = path;
% if ~exist('progressBar','file')
%     new_path = fullfile('external','progressBar');
%     addpath(new_path);
% end
% progbar = progressBar(n_scans, 'Scanning');

% Scan locations
for i=1:n_scans
%     progbar(i);
    fprintf('%s snr %d iter %d %d/%d\n',...
        cfg.beamformer_config,out.snr,out.iteration,i,n_scans);
    idx = cfg.loc(i);
    
    % Set the location to scan
    cfg_beam.loc = i;
    % Calculate the beamformer
    beam_out = aet_analysis_beamform(cfg_beam);
    out.filter{i} = beam_out.W;
    out.leadfield{i} = beam_out.H;
    out.loc(i) = idx;
    
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

% Save the output
tmpcfg = [];
tmpcfg.file_name = cfg.data_file;
tmpcfg.tag = cfg.beamformer_config;
source = out;
save_file = db.save_setup(tmpcfg);
save(save_file, 'source');

% Revert
% path(cur_path);

end