close all;

%% Set up config to get the data file
snr = '0';

cfg = [];
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_names = {...
    'mult_cort_src_10',...
    ...'mult_cort_src_14',...
    'mult_cort_src_15',...
    'mult_cort_src_16',...
    'mult_cort_src_17',...
    'mult_cort_src_sine_2',...
    'distr_cort_src_2',...
    'distr_cort_src_3',...
    ...'single_cort_src_4',...
    'single_cort_src_1'
    };
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
    R_input = aet_analysis_cov(data_in.data.avg_signal);
    rank_input = rank(R_input);
    % Calculate the rank of the input and noise
    rank_signal = rank(data{i}.R);
    
    % SVD decomposition
    [U,S,V] = svd(data{i}.R);
    data{i}.U = U;
    data{i}.S = S;
    data{i}.V = V;
    data{i}.name = source_name;
    
    % Analyze the singular values
    singular_values = diag(data{i}.S);
    max_val = max(singular_values);
    sorted_val = sort(singular_values,1,'descend');
    
    % Print out data
    fprintf('\n-- %s --\n', data{i}.name);
    fprintf('rank all: %d\n\trank input: %d\n',...
        rank_signal, rank_input);

    fprintf('Top 5 Singular values\n');
    fprintf('| Value | Percent of Max |\n');
    fprintf('| %f | %0.2f |\n',[sorted_val(1:5)...
        100*sorted_val(1:5)./max_val]');
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