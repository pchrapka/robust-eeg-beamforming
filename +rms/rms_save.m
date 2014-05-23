function rms_save(cfg, rms_data)
%RMS_SAVE Saves the RMSE data based on the config supplied to RMS_BF_FILE
%   RMS_SAVE(CFG) Saves the output in the same directory as the
%   original EEG data set, with the same file name and the following
%   suffixes: '_rms' or '_rms_3sphere'.

%% Set up simulation info
cfg_data = [];
cfg_data.sim_name = cfg.sim_name;
cfg_data.source_name = cfg.source_name;
cfg_data.snr = cfg.snr;
cfg_data.iteration = cfg.iteration;

%% Save the data
% Set up output file cfg
cfg_out = cfg_data;
if isempty(strfind(cfg.beam_cfgs{1}, '3sphere'))
    cfg_out.tag = 'rms';
else
    cfg_out.tag = 'rms_3sphere';
end
if isfield(cfg,'cluster')
    if cfg.cluster
        cfg_out.tag = [cfg_out.tag '_cluster'];
    end
end
save_file = db.save_setup(cfg_out);
save(save_file, 'rms_data');

end