function [rms_data] = rms_bf_iterations(cfg)
%RMS_BF_ITERATIONS Calculates RMS error for multiple iterations of an EEG
%data set
%   RMS_BF_ITERATIONS(CFG) calculates the RMS error for multiple iterations
%   of an EEG data set. Only looks at one beamformer config.
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
%   cfg.iterations  list of simulation iterations
%
%     Example:
%     cfg.sim_name = 'sim_data_bem_1_100t_1000s';
%     cfg.source_name = 'mult_cort_src_10';
%     cfg.snr = snr;
%     cfg.iterations = 5:20;
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
%   cfg.head    IHeadModel obj, see HeadModel
%

% Save some variables
rms_data.name = cfg.beam_cfg;
% Set the location_idx
if isfield(cfg,'location_idx')
    rms_data.location_idx = cfg.location_idx;
else
    rms_data.location_idx = 0;
end

% Set the sample_idx
if isfield(cfg,'sample_idx')
    rms_data.sample_idx = cfg.sample_idx;
else
    rms_data.sample_idx = 0;
end

%% Calculate rms for all desired iterations
parfor i=1:length(cfg.iterations)
    
    % Copy the config
    cfg_temp = cfg;
    % Choose the iteration
    cfg_temp.iteration = cfg_temp.iterations(i);
    % Save the iteration
    iteration(i) = cfg_temp.iteration;
    fprintf('Calculating RMSE for: %s, iter: %d\n',...
        cfg_temp.beam_cfg, cfg_temp.iteration);
    
    % Calculate the rms
    [rmse(i,:), rms_input(i,:)] = ...
        rms.rms_bf_file(cfg_temp);
end

rms_data.iteration = iteration;
rms_data.rmse = rmse;
rms_data.rms_input = rms_input;

    
end
