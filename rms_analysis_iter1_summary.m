function rms_analysis_iter1_summary(cfg_in)
% Summarizes the RMSE results produced by rms_analysis_iter1_*
% clc;


% %% Get the data file name
% cfg_template = [];
% cfg_template.sim_name = 'sim_data_bem_1_100t';
% cfg_template.source_name = '';
% cfg_template.snr = '0';
% cfg_template.iteration = '1';
% cfg_template.tag = 'rms';
% cfgs.source_name = cfg_in.source_name;

%% Set up configs
% k = 1;
% cfgs = cfg_template;
% cfgs.source_name = 'single_cort_src_1';
% k = k+1;
% cfgs(k) = cfg_template;
% cfgs(k).source_name = 'mult_cort_src_10';
% cfgs(k).source_name = 'mult_cort_src_16';
% cfgs(k).source_name = 'mult_cort_src_17';
% k = k+1;
% cfgs(k) = cfg_template;
% cfgs(k).source_name = 'distr_cort_src_2';


%% Summarize the results
data = {};

% Select the config
cfg = [];
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = '';
cfg.snr = '0';
cfg.iteration = '1';
cfg.tag = 'rms';
cfg.source_name = cfg_in.source_name;

fprintf('\n%s %s\n', cfg.source_name, cfg.tag);

% Get the template data file name
data_file = db.save_setup(cfg);
if verLessThan('matlab', '7.14')
    [file_path,name,ext,~] = fileparts(data_file);
else
    [file_path,name,ext] = fileparts(data_file);
end

% Get all the matching files in the directory
data_files = dir(fullfile(file_path, [name '*.mat']));
for j=1:length(data_files)
    % Set up the data file
    data_file = fullfile(file_path, data_files(j).name);
    
    % Load data
    data_in = load(data_file);
    results = data_in.rms_data;
    
    % Summarize the data
    [M, col_labels] = rms.rms_summarize(results);
    
    % Display the results
    fprintf('%s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s | %s\n', col_labels{:});
    fprintf('%s | %d | %d | %f | %f | %f | %f | %f | %f | %f | %f | %f \n', M{:});
    
    % Collect the data
    data = [data M];
end

% Output the results to a csv file
cfg.rms_col_labels = col_labels;
cfg.rms_out = data;
cfg.tag = [cfg.tag '_summary'];
rms.rms_summarize_csv(cfg);