

% Set up config to get the data file
snr = 0;

data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t',...
    'distr_cort_src_2',...
    snr,...
    'iter',1);

% Get the file name
file_name = data_set.get_full_filename();
% Add extension
file_name = [file_name '.mat'];

% Load the EEG data
data_in = load(file_name);

% Load the covariance matrix
R = data_in.data.R;

% SVD decomposition
[U,S,V] = svd(R);

singular_values = diag(S);

stem(singular_values);

% Find the max singular value
max_val = max(singular_values);

% Filter singular values that exceed some threshold
threshold_percent = 0.05;
threshold = max_val*threshold_percent;

n_singular_values = sum(singular_values > threshold);
fprintf('Number of singular values exceeding %0.2f%%\n', threshold_percent*100);
fprintf('of max singular value: %d\n',n_singular_values);

% Show the top 5 singular values
sorted_val = sort(singular_values,1,'descend');
fprintf('Top 5 Singular values\n');
fprintf('| Value | Percent of Max |\n');
fprintf('| %f | %0.2f |\n',[sorted_val(1:5) 100*sorted_val(1:5)./max_val]');
