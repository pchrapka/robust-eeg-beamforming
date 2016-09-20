function rms_save(cfg, rms_data)
%RMS_SAVE Saves the RMSE data based on the config supplied to RMS_BF_FILE
%   RMS_SAVE(CFG) Saves the output in the same directory as the
%   original EEG data set, with the same file name and the following
%   suffixes: '_rms' or '_rms_3sphere'.

% if isfield(cfg,'iterations')
%     cfg_data.iteration = [num2str(min(cfg.iterations))...
%         '-' num2str(max(cfg.iterations))];
% else
%     cfg_data.iteration = cfg.iteration;
% end

%% Set up output file tag
if isempty(strfind(cfg.beam_cfgs{1}, '3sphere'))
    tag = 'rms';
else
    tag = 'rms_3sphere';
end
if isfield(cfg,'location_idx')
    tag = [tag '_loc' num2str(cfg.location_idx)];
end
if isfield(cfg,'sample_idx')
    tag = [tag '_sam' num2str(cfg.sample_idx)];
end
if isfield(cfg,'cluster')
    if cfg.cluster
        tag = [tag '_cluster'];
    end
end

%% Save the data
save_file = db.save_setup('data_set',cfg.data_set,'tag',tag);
[~,name,~,~] = util.fileparts(save_file);
fprintf('Saving as: %s\n', name);
save(save_file, 'rms_data');

end