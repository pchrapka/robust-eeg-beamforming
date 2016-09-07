function [rms_data] = rms_bf_configs_iterations(cfg)
%RMS_BF_CONFIGS_ITERATIONS Calculates RMS error for multiple beamformer
%configs and multiple iterations of an EEG data set
%   RMS_BF_CONFIGS_ITERATIONS(CFG) calculates RMS error for multiple
%   beamformer configs and multiple iterations of an EEG data set
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
%   cfg.iterations  list of simulation iterations
%
%     Example:
%     cfg.sim_name = 'sim_data_bem_1_100t';
%     cfg.source_name = 'mult_cort_src_10';
%     cfg.snr = snr;
%     cfg.iterations = 5:20;
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
%   cfg.head    IHeadModel obj, see HeadModel
%

%% Calculate rms for all desired iterations
% Start parallel execution
cfg_par = [];
cfg_par.ncores = 10;
aet_parallel_init(cfg_par)

for i=1:length(cfg.beam_cfgs)
    
    % Choose the beamformer config
    cfg.beam_cfg = cfg.beam_cfgs{i};
    
    % Calculate the RMSE for this set of data
    rms_data(i) = rms.rms_bf_iterations(cfg);
end

% End parallel execution
cfg_par = [];
aet_parallel_close(cfg_par)

end