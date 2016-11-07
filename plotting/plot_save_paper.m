% NOTE
% This script imports the data into Brainstorm and then uses a bunch of
% hacked code to interact with Brainstorm
%
% WARNING Old script for plotting power results, use power_surface_lowres

fprintf('*** DEPRECATED:%s ***\n Use power_surface_lowres instead', mfilename);

% brainstorm.bstcust_start
save_images = true;
% save_images = false;
% brainstorm.bstcust_plot_close

%% ==== single_cort_src_1 ====
% Get the data file
cfg_data = [];
cfg_data.data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t_1000s',...
    'single_cort_src_1',...
    0,...
    'iter',1);
cfg_data.mismatch = false;

time = 0.476;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

% Get the data file
cfg_data = [];
cfg_data.data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t_1000s',...
    'single_cort_src_1',...
    0,...
    'iter',1);
cfg_data.mismatch = true;
cfg_data.mismatch_tags = {'3sphere'};

time = 0.476;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);


% %% ==== mult_cort_src_10 ====
% % Get the data file
% cfg_data = [];
% cfg_data.data_set = SimDataSetEEG(...
%     'sim_data_bem_1_100t_1000s',...
%     'mult_cort_src_10',...
%     0,...
%     'iter',1);
% cfg_data.mismatch = false;
% 
% % Get the study idx
% study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% % Plot and save the data
% time = 0.460;
% brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);
% 
% % Get the data file
% cfg_data = [];
% cfg_data.data_set = SimDataSetEEG(...
%     'sim_data_bem_1_100t_1000s',...
%     'mult_cort_src_10',...
%     0,...
%     'iter',1);
% cfg_data.mismatch = true;
% cfg_data.mismatch_tags = {'3sphere'};
% 
% % Get the study idx
% study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% % Plot and save the data
% time = 0.460;
% brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

%% ==== mult_cort_src_17 ====
% Get the data file
cfg_data = [];
cfg_data.data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t_1000s',...
    'mult_cort_src_17',...
    0,...
    'iter',1);
cfg_data.mismatch = false;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
time = 0.520;
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

% Get the data file
cfg_data = [];
cfg_data.data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t_1000s',...
    'mult_cort_src_17',...
    0,...
    'iter',1);
cfg_data.mismatch = true;
cfg_data.mismatch_tags = {'3sphere'};

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
time = 0.520;
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

%% ==== distr_cort_src_2 ====
% Get the data file
cfg_data = [];
cfg_data.data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t_1000s',...
    'distr_cort_src_2',...
    0,...
    'iter',1);
cfg_data.mismatch = false;

time = 0.464;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

% Get the data file
cfg_data = [];
cfg_data.data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t_1000s',...
    'distr_cort_src_2',...
    0,...
    'iter',1);
cfg_data.mismatch = true;
cfg_data.mismatch_tags = {'3sphere'};

time = 0.464;

% Get the study idx
study_idx = brainstorm.bstcust_study_id_simdata(cfg_data);
% Plot and save the data
brainstorm.bstcust_plot(study_idx, cfg_data.snr, time, save_images);

