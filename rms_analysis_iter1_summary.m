%% rms_analysis_iter1_summary
% Summarizes the RMSE results produced by rms_analysis_iter1_*
clc;

%% Common params
snr = '0';
mismatch = true;
clustered_data = false; % only for mult_src

%% Get the data file name
cfg_template = [];
cfg_template.sim_name = 'sim_data_bem_1_100t';
cfg_template.source_name = '';
cfg_template.snr = snr;
cfg_template.iteration = '1';
if mismatch
    cfg_template.tag = 'rms_3sphere';
else
    cfg_template.tag = 'rms';
end
if clustered_data
    cfg_template.tag = [cfg_template.tag '_cluster'];
end

%% Set up configs
k = 1;
% cfgs = cfg_template;
% cfgs.source_name = 'single_cort_src_1';
% k = k+1;
cfgs(k) = cfg_template;
% cfgs(k).source_name = 'mult_cort_src_10';
cfgs(k).source_name = 'mult_cort_src_16';
k = k+1;
% cfgs(k) = cfg_template;
% cfgs(k).source_name = 'distr_cort_src_2';


%% Summarize the results
for i=1:length(cfgs)
    % Select the config
    cfg = cfgs(i);
    fprintf('\n%s %s\n', cfg.source_name, cfg.tag);
    
    % Get the data file name
    data_file = db.save_setup(cfg);
    % FIXME Might need to split the extension and do a search
    % Or just explicitly list all the matching files
    
    % Load data
    data_in = load(data_file);
    results = data_in.rms_data;
    
    % Summarize the data
    [M, col_labels] = rms.rms_summarize(results);
    
    % Display the results
    fprintf('%s | %s | %s | %s | %s | %s \n', col_labels{:});
    fprintf('%s | %d | %d | %f | %f | %f \n', M{:});
    
    % Output the results to a csv file
    cfg.rms_col_labels = col_labels;
    cfg.rms_out = M;
    rms.rms_summarize_csv(cfg);
end