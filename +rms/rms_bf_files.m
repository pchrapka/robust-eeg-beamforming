function [rms_data] = rms_bf_files(cfg)
%RMS_BF_FILES Calculates rms for one EEG data set and multiple beamformer
%configs
%   RMS_BF_FILES(CFG) calculates the RMS error for multiple beamformer
%   output data files based on one EEG data set.
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
%     cfg.sim_name = 'sim_data_bem_1_100t_1000s';
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
%   cfg.head    IHeadModel obj, see HeadModel
%

rms_data(length(cfg.beam_cfgs)).name = '';
%% Calculate rms for all desired beamformer configs
for i=1:length(cfg.beam_cfgs)
    
    % Choose the beamformer config
    cfg.beam_cfg = cfg.beam_cfgs{i};
    
    % Save some data
    rms_data(i).name = cfg.beam_cfgs{i};
    rms_data(i).iteration = cfg.iteration;
    
    % Set the location_idx
    if isfield(cfg,'location_idx')
        rms_data(i).location_idx = cfg.location_idx;
    else
        rms_data(i).location_idx = 0;
    end
    
    % Set the sample_idx
    if isfield(cfg,'sample_idx')
        rms_data(i).sample_idx = cfg.sample_idx;
    else
        rms_data(i).sample_idx = 0;
    end
        
    % Calculate the rms
    [rms_data(i).rmse, rms_data(i).rms_input] = ...
        rms.rms_bf_file(cfg);
end

end
