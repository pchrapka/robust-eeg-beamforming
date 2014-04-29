function [rms_data] = rms_bf_file(cfg)
%DISPERSION_BF_FILE Calculates rms for multiple data sets
%   DISPERSION_BF_FILE(CFG)
%
%   cfg.sample_idx  sample position at which to calculate the rms
%   cfg.beam_cfgs   cell array of beamformer cfg file tags to process
%   cfg.sim_name    simulation config name
%   cfg.source_name source config name
%   cfg.snr         snr
%   cfg.iteration   simulation iteration
%   cfg.head        head model cfg (see hm_get_data);

%% Set up simulation info
cfg_data = [];
cfg_data.sim_name = cfg.sim_name;
cfg_data.source_name = cfg.source_name;
cfg_data.snr = cfg.snr;
cfg_data.iteration = cfg.iteration;

%% Load the head model

data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

%% Calculate rms for all desired beamformer configs
for i=1:length(cfg.beam_cfgs)
    
    % Get the full data file name
    cfg_data.tag = [cfg.beam_cfgs{i} '_mini'];
    data_file = db.save_setup(cfg_data);
    
    % Load the data
    data_in = load(data_file);
    
    % Set up cfg for rms
    cfg_rms = [];
    cfg_rms.head = head;
    cfg_rms.bf_out = data_in.source.beamformer_output;
    cfg_rms.sample_idx = cfg.sample_idx;
    cfg_rms.true_peak = cfg.true_peak;
    
    % Calculate the rms
    rms_data.name{i} = cfg.beam_cfgs{i};
    [rms_data.rms{i}, rms_data.rms_peak{i}] = ...
        rms_bf(cfg_rms);
    
end

%% Save the data
% Set up output file cfg
cfg_out = cfg_data;
if isempty(strfind(cfg.beam_cfgs{1}, '3sphere'))
    cfg_out.tag = 'rms';
else
    cfg_out.tag = 'rms_3sphere';
end
save_file = db.save_setup(cfg_out);
save(save_file, 'rms_data');

end