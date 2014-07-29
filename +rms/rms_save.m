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
if isfield(cfg,'iterations')
    cfg_data.iteration = [num2str(min(cfg.iterations))...
        '-' num2str(max(cfg.iterations))];
else
    cfg_data.iteration = cfg.iteration;
end

%% Save the data
% Set up output file cfg
cfg_out = cfg_data;
if isempty(strfind(cfg.beam_cfgs{1}, '3sphere'))
    cfg_out.tag = 'rms';
else
    cfg_out.tag = 'rms_3sphere';
end
if isfield(cfg,'location_idx')
    cfg_out.tag = [cfg_out.tag '_loc' num2str(cfg.location_idx)];
end
if isfield(cfg,'sample_idx')
    cfg_out.tag = [cfg_out.tag '_sam' num2str(cfg.sample_idx)];
end
if isfield(cfg,'cluster')
    if cfg.cluster
        cfg_out.tag = [cfg_out.tag '_cluster'];
    end
end
save_file = db.save_setup(cfg_out);
if verLessThan('matlab', '7.14')
    [~,name,~,~] = fileparts(save_file);
else
    [~,name,~] = fileparts(save_file);
end
fprintf('Saving as: %s\n', name);
save(save_file, 'rms_data');

end