
% brainstorm.bstcust_start
save_images = true;
% save_images = false;
% brainstorm.bstcust_plot_close

%% ==== single_cort_src_1 ====
% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'single_cort_src_1';
cfg_data.snr = '0';
cfg_data.iteration = '1';
cfg_data.mismatch = false;

time = 0.476;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'single_cort_src_1';
cfg_data.snr = '0';
cfg_data.iteration = '1';
cfg_data.mismatch = true;
cfg_data.mismatch_tags = {'3sphere'};

time = 0.476;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);


%% ==== mult_cort_src_10 ====
% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_10';
cfg_data.snr = '0';
cfg_data.iteration = '1';
cfg_data.mismatch = false;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
time = 0.460;
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'mult_cort_src_10';
cfg_data.snr = '0';
cfg_data.iteration = '1';
cfg_data.mismatch = true;
cfg_data.mismatch_tags = {'3sphere'};

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
time = 0.460;
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

%% ==== distr_cort_src_2 ====
% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'distr_cort_src_2';
cfg_data.snr = '0';
cfg_data.iteration = '1';
cfg_data.mismatch = false;

time = 0.452;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

% Get the data file
cfg_data = [];
cfg_data.sim_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'distr_cort_src_2';
cfg_data.snr = '0';
cfg_data.iteration = '1';
cfg_data.mismatch = true;
cfg_data.mismatch_tags = {'3sphere'};

time = 0.452;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

