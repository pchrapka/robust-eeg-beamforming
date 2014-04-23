function [dispersion_data] = dispersion_bf_file(cfg)
%DISPERSION_BF_FILE Calculates dispersion for multiple data sets
%   DISPERSION_BF_FILE(CFG)
%
%   cfg.sample_idx  sample position at which to calculate the dispersion
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

%% Calculate dispersion for all desired beamformer configs
for i=1:length(cfg.beam_cfgs)
    
    % Get the full data file name
    cfg_data.tag = [cfg.beam_cfgs{i} '_mini'];
    data_file = db.save_setup(cfg_data);
    
    % Load the data
    data_in = load(data_file);
    
    % Set up cfg for dispersion
    cfg_disp = [];
    cfg_disp.head = head;
    cfg_disp.bf_out = data_in.source.beamformer_output;
    cfg_disp.sample_idx = cfg.sample_idx;
    
    % Calculate the dispersion
    dispersion_data.name{i} = cfg.beam_cfgs{i};
    [dispersion_data.value{i}, dispersion_data.n_points{i}] = ...
        dispersion(cfg_disp);
    
end

%% Save the data
% Set up output file cfg
cfg_out = cfg_data;
if isempty(strfind(cfg.beam_cfgs{1}, '3sphere'))
    cfg_out.tag = 'dispersion';
else
    cfg_out.tag = 'dispersion_3sphere';
end
save_file = db.save_setup(cfg_out);
save(save_file, 'dispersion_data');

end