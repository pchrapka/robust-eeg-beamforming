%% brainstorm_import
% Import data from beamformer analysis to Brainstorm

% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_test';
cfg_data.source_name = 'mult_cort_src_3';
cfg_data.snr = '0';
cfg_data.iteration = '1';

% Format data to import to Brainstorm
cfg = [];
cfg.data_file = db.get_full_file_name(cfg_data);
cfg.eeg = eeg;          % export from Brainstorm
cfg.source = source;    % export from Brainstorm
% Beamformer analyses to import
cfg.tags = {'lcmv','lcmv_eig_2','lcmv_reg_eig'};

brainstorm.prep_import(cfg);