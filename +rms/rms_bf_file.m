function [rms_data] = rms_bf_file(cfg)
%RMS_BF_FILE Calculates rms for multiple data files
%   RMS_BF_FILE(CFG) calculates the RMS error for multiple beamformer
%   output data files. Saves the output in the same directory as the
%   original EEG data set, with the same file name and the following
%   suffixes: '_rms' or '_rms_3sphere'.
%
%   Beamformer Config
%   -----------------
%   cfg.beam_cfgs   cell array of beamformer cfg file tags to process
%
%     Example: 
%     cfg.beam_cfgs = {...
%         'rmv_epsilon_20',...
%         'lcmv'
%         };
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
%   cfg.true_peak
%       index of the true peak
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

%% Calculate rms for all desired beamformer configs
for i=1:length(cfg.beam_cfgs)
    % Get the full data file name
    cfg_data.tag = [cfg.beam_cfgs{i} '_mini'];
    bf_data_file = db.save_setup(cfg_data);
    
    % Load the beamformer data
    bf_data_in = load(bf_data_file);
    
    % Set up cfg for rms
    cfg_rms = [];
    if isfield(cfg,'head')
        cfg_rms.head = head;
    end
    cfg_rms.bf_out = bf_data_in.source.beamformer_output;
    cfg_rms.sample_idx = cfg.sample_idx;
    cfg_rms.true_peak = cfg.true_peak;
    cfg_rms.source_type = cfg.source_type;
    if isfield(cfg,'cluster')
        cfg_rms.cluster = cfg.cluster;
    end
    
    % Calculate the input signal
    % NOTE This won't be exact
    cfg_input = [];
    cfg_input.sim_name = cfg.sim_name;
    cfg_input.source_name = cfg.source_name;
    cfg_rms.input_signal = rms.rms_calc_input_signal(cfg_input);
    
    % Calculate the rms
    rms_data.name{i} = cfg.beam_cfgs{i};
    rms_data.iteration{i} = cfg_data.iteration;
    rms_data.true_peak_idx(i,:) = cfg.true_peak;
    [rms_data.rmse(i,:), rms_data.rms_input(i,:)] = ...
        rms.rms_bf(cfg_rms);
end

end