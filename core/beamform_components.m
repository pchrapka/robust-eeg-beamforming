function [cfg] = beamform_components(cfg)
%   cfg.beam_cfg
%       beamformer config
%   cfg.data_set
%       struct describing data set
%   
%       example:
%       cfg.data_set.sim_name = 'sim_data_bem_1_100t';
%       cfg.data_set.source_name = 'mult_cort_src_17';
%       cfg.data_set.snr = 0;
%       cfg.data_set.iteration = '1';
%   
%   cfg.force
%       flag for forcing recomputation of metrics, default = false
%
%   Output
%   ------
%   cfg.data_file
%       output data file

if ~isfield(cfg, 'force'), cfg.force = false; end

% Set up file name for beamformer component calculations
cfg.data_set.tag = [cfg.beam_cfg '_bfcomp.mat'];
cfg.data_file = db.get_full_file_name(cfg.data_set);

% Only compute the components if the file doesn't exist or explicitly force
if ~exist(cfg.data_file, 'file') && ~cfg.force
    
    %% Load the original data
    cfg.data_set.tag = [];
    file_name = db.get_full_file_name(cfg.data_set);
    file_name = strcat(file_name, '.mat');
    din = load(file_name);
    
    %% Load the beamformer output data
    
    % Set up the beamformer data file name
    cfg.data_set.tag = cfg.beam_cfg;
    file_name = db.get_full_file_name(cfg.data_set);
    file_name = strcat(file_name, '.mat');
    dbf = load(file_name);
    
    % Extract the filter
    filter = dbf.source.filter;
    
    %% Compute beamformer output of individual components
    % Switch based on component
    cfg_bf = [];
    cfg_bf.filter = filter;
    % Signal
    cfg_bf.data = din.data.avg_signal;
    data.bf_out.signal.data = beamform(cfg_bf);
    % Interference
    cfg_bf.data = din.data.avg_interference;
    data.bf_out.interference.data = beamform(cfg_bf);
    % Noise
    cfg_bf.data = din.data.avg_noise;
    data.bf_out.noise.data = beamform(cfg_bf);
    
    % Save to a file
    save(cfg.data_file, 'data');
end

end