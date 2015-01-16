function [rmse, rms_input] = rms_bf_file(cfg)
%RMS_BF_FILE Calculates rms for a beamformer output file
%   RMS_BF_FILE(CFG) calculates the RMS error for a beamformer output data
%   file.
%
%   Beamformer Config
%   -----------------
%   cfg.beam_cfg   	beamformer config
%
%     Example: 
%     cfg.beam_cfg = 'rmv_epsilon_20';
%       
%   Data Set
%   --------
%   cfg.sim_name    simulation config name
%   cfg.source_name source config name
%   cfg.snr         snr
%   cfg.iteration   simulation iteration
%
%     Example:
%     cfg.sim_name = 'sim_data_bem_1_100t';
%     cfg.source_name = 'mult_cort_src_10';
%     cfg.snr = snr;
%     cfg.iteration = '1';
%
%
%   RMS Calculation
%   ---------------
%   cfg.sample_idx
%       sample index at which to calculate the RMS error
%   cfg.location_idx
%       location index at which to calculate the RMS error
%   cfg.source_type     ('single', 'distr', 'mult')
%       type of source being analyzed
%
%   Extra arguments based on source_type
%   source_type = 'mult'
%   cfg.head    head struct (see hm_get_data)
%

%% Set up simulation info
cfg_data = [];
cfg_data.sim_name = cfg.sim_name;
cfg_data.source_name = cfg.source_name;
cfg_data.snr = cfg.snr;
cfg_data.iteration = cfg.iteration;

%% Load the head model

if isfield(cfg,'head')
    data_in = hm_get_data(cfg.head);
    head = data_in.head;
    clear data_in;
end

%% Calculate rms for the beamformer source file
% Get the full data file name
eeg_data_file = db.save_setup(cfg_data);
cfg_data.tag = cfg.beam_cfg;
bf_data_file = db.save_setup(cfg_data);

% Load the beamformer data
bf_data_in = load(bf_data_file);

% Set up cfg for rms
cfg_rms = [];
cfg_rms.source_type = cfg.source_type;
cfg_rms.bf_out = bf_data_in.source.beamformer_output;

if isfield(cfg,'head')
    cfg_rms.head = head;
end
if isfield(cfg,'sample_idx')
    cfg_rms.sample_idx = cfg.sample_idx;
end
if isfield(cfg,'location_idx')
    cfg_rms.location_idx = cfg.location_idx;
end
if isfield(cfg,'cluster')
    cfg_rms.cluster = cfg.cluster;
end

% % Calculate the input signal
% % NOTE This won't be exact
% cfg_input = [];
% cfg_input.sim_name = cfg.sim_name;
% cfg_input.source_name = cfg.source_name;
% cfg_rms.input_signal = rms.rms_calc_input_signal(cfg_input);
% FIXME Remove this code

% Load the input signal from the original data
eeg_data_in = load(eeg_data_file);
if ~isfield(eeg_data_in.data,'avg_dipole_signal')
    fprintf('Rerun the analysis for %s %s\n',...
        cfg.sim_name, cfg.source_name);
    error('reb:rms_bf_file',...
        'missing avg_dipole_signal');
end
cfg_rms.input_signal = eeg_data_in.data.avg_dipole_signal;

% Calculate the rms
[rmse, rms_input] = rms.rms_bf(cfg_rms);

end