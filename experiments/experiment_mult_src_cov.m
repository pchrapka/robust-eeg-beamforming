close all;

%% Set up config to get the data file
snr = 0;

source_names = {...
    'mult_cort_src_10',...
    ...'mult_cort_src_14',...
    'mult_cort_src_15',...
    'mult_cort_src_16',...
    'mult_cort_src_17'};

%% Load the data
data = cell(size(source_names));
for i=1:length(source_names)
    % Get the file name
    source_name = strrep(source_names{i},'_',' ');
    
    data_set = SimDataSetEEG(...
        'sim_data_bem_1_100t',...
        source_names{i},...
        snr,...
        'iter',1);

    file_name = data_set.get_full_filename();
    % Add extension
    file_name = strcat(file_name,'.mat');
    
    % Load the EEG data
    data_in = load(file_name);
    
    % Load the covariance matrix
    data{i}.R = data_in.data.R;
    
    % SVD decomposition
    [U,S,V] = svd(data{i}.R);
    data{i}.U = U;
    data{i}.S = S;
    data{i}.V = V;
    data{i}.name = source_name;
end

%% Plot the SVD results
figure;
for i=1:length(data)
    fprintf('\n-- %s --\n', data{i}.name);
    singular_values = diag(data{i}.S);
    
    subplot(2,2,i);
    stem(singular_values);
    title(data{i}.name);
    
    max_val = max(singular_values);
    sorted_val = sort(singular_values,1,'descend');
    fprintf('Top 5 Singular values\n');
    fprintf('| Value | Percent of Max |\n');
    fprintf('| %f | %0.2f |\n',[sorted_val(1:5) 100*sorted_val(1:5)./max_val]');
    
end

%% Plot the covariance
figure;
for i=1:length(data)
    subplot(2,2,i);
    imagesc(data{i}.R);
    title(data{i}.name);
end