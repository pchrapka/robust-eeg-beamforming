%% rms_analysis_iters_summary
% Summarizes the RMSE results produced by rms_analysis_iters_*

clc;

%% Common params
mismatch = true;
clustered_data = false; % only for mult_src

sim_name = 'sim_data_bem_100_100t';
iteration = '1-100';
snr = 0;

tag = '';
if mismatch
    tag = [tag '_3sphere'];
end
if clustered_data
    tag = [tag '_cluster'];
end

%% Set up configs
k = 1;
source_name = 'single_cort_src_1';
cfgs(k).data_set = SimDataSetEEG(sim_name,source_name,snr,'iter',iteration);
cfgs(k).tag = tag;
k = k+1;
source_name = 'mult_cort_src_10';
cfgs(k).data_set = SimDataSetEEG(sim_name,source_name,snr,'iter',iteration);
cfgs(k).tag = tag;
k = k+1;
source_name = 'distr_cort_src_2';
cfgs(k).data_set = SimDataSetEEG(sim_name,source_name,snr,'iter',iteration);
cfgs(k).tag = tag;

%% Summarize the results
for i=1:length(cfgs)
    % Select the config
    cfg = cfgs(i);
    fprintf('\n%s %s\n', cfg.data_set.source, cfg.tag);
    
    % Get the data file name
    data_file = db.save_setup('data_set',cfg.data_set,'tag',cfg.tag);
    
    % Load data
    data_in = load(data_file);
    results = data_in.rms_data;
    
    % Summarize the data
    [M, col_labels] = rms.rms_summarize(results);
    
    % Display the results
    fprintf('%s | %s | %s | %s | %s | %s | %s | %s \n', col_labels{:});
    fprintf('%s | %d | %d | %f | %f | %f | %f | %f \n', M{:});
    
    % Output the results to a csv file
    cfg.rms_col_labels = col_labels;
    cfg.rms_out = M;
    rms.rms_summarize_csv(cfg);
end