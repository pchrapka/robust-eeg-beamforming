close all;
clc;

aet_init();

%% Set up config to get the data file
snr = '0';

cfg = [];
cfg.sim_name = 'sim_data_bem_1_100t';
src_erp = {...
    'mult_cort_src_10',...
    ...'mult_cort_src_14',...
    ...'mult_cort_src_15',...
    ...'mult_cort_src_16',...
    'mult_cort_src_17',...
    'mult_cort_src_sine_2',...
    'distr_cort_src_2',...
    'distr_cort_src_3',...
    ...'single_cort_src_4',...
    'single_cort_src_1',...
    };
src_single_complex = {...
    'single_cort_src_complex_1',...
    'single_cort_src_complex_2',...
    'single_cort_src_complex_2_freq',...
    'single_cort_src_complex_2_dip',...
    };
src_mult_complex = {...
    'mult_cort_src_complex_1',...
    'mult_cort_src_complex_1_freq',...
    'mult_cort_src_complex_1_freq_pos',...
    'mult_cort_src_complex_1_dip',...
    'mult_cort_src_complex_1_dip_pos',...
    'mult_cort_src_complex_1_pos',...
    'mult_cort_src_complex_1_pos_exact',...
    'mult_cort_src_complex_2_pos_exact',...
    };
src_distr_complex = {...
    'distr_cort_src_complex_1',...
    'distr_cort_src_complex_2',...
    };
src_single_experimental = {...
    'single_cort_src_erp_sine_exp_1',...
    'single_cort_src_biphasic_1',...
    };
cfg.source_names = [...
    src_single_complex...
    src_mult_complex...
    src_distr_complex...
    src_single_complex...
    src_single_experimental...
    ];
cfg.snr = snr;
cfg.iteration = 1;

%% Load the data
data = cell(size(cfg.source_names));
for i=1:length(cfg.source_names)
    % Get the file name
    cfg.source_name = cfg.source_names{i};
    source_name = strrep(cfg.source_name,'_',' ');
    file_name = db.get_full_file_name(cfg);
    % Add extension
    file_name = strcat(file_name,'.mat');
    
    % Load the EEG data
    data_in = load(file_name);
    
    % Load the covariance matrix
    if ~isfield(data_in.data,'R')
        data_in.data.R = aet_analysis_cov(data_in.data.avg_trials);
        data = data_in.data;
        save(file_name, 'data');
        clear data
    end
    data{i}.R = data_in.data.R;
    
    % Calculate the rank of the input only
    data{i}.R_signal = aet_analysis_cov(data_in.data.avg_signal);
    rank_signal = rank(data{i}.R_signal);
    % Calculate the rank of the input and noise
    rank_trial = rank(data{i}.R);
    
    % SVD decomposition
    [U,S,V] = svd(data{i}.R);
    data{i}.trial.U = U;
    data{i}.trial.S = S;
    data{i}.trial.V = V;
    
    [U,S,V] = svd(data{i}.R_signal);
    data{i}.signal.U = U;
    data{i}.signal.S = S;
    data{i}.signal.V = V;
    
    data{i}.name = source_name;
    
    % Analyze the singular values
    sing_val_trial = diag(data{i}.trial.S);
    max_val_trial = max(sing_val_trial);
    sorted_val_trial = sort(sing_val_trial,1,'descend');
    
    sing_val_signal = diag(data{i}.signal.S);
    max_val_signal = max(sing_val_signal);
    sorted_val_signal= sort(sing_val_signal,1,'descend');
    
    % Print out data
    fprintf('\n-- %s --\n', data{i}.name);
    fprintf('\trank all: %d\n\trank input: %d\n',...
        rank_trial, rank_signal);
    
    indent = '\t';

%     fprintf([indent '## Trial\n']);
%     fprintf([indent 'Top 5 Singular values\n']);
%     fprintf([indent '| Value | Percent of Max |\n']);
%     fprintf([indent '| %f | %0.2f |\n'],[sorted_val_trial(1:5)...
%         100*sorted_val_trial(1:5)./max_val_trial]');
    fprintf([indent '## Signal\n']);
    fprintf([indent 'Top 5 Singular values\n']);
    fprintf([indent '| Value | Percent of Max |\n']);
    fprintf([indent '| %f | %0.2f |\n'],[sorted_val_signal(1:5)...
        100*sorted_val_signal(1:5)./max_val_signal]');
end

% %% Plot the SVD results
% figure;
% for i=1:length(data)
%     fprintf('\n-- %s --\n', data{i}.name);
%     singular_values = diag(data{i}.S);
%     
%     subplot(2,2,i);
%     stem(singular_values);
%     title(data{i}.name);
%     
%     max_val = max(singular_values);
%     sorted_val = sort(singular_values,1,'descend');
%     fprintf('Top 5 Singular values\n');
%     fprintf('| Value | Percent of Max |\n');
%     fprintf('| %f | %0.2f |\n',[sorted_val(1:5) 100*sorted_val(1:5)./max_val]');
%     
% end
% 
% %% Plot the covariance
% figure;
% for i=1:length(data)
%     subplot(2,2,i);
%     imagesc(data{i}.R);
%     title(data{i}.name);
% end