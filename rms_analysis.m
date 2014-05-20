%% rms_analysis
clc;

%% Common params
snr = '0';
mismatch = false;
clustered_data = false; % only for mult_src

%% Get the data file name
cfg = [];
cfg.sim_name = 'sim_data_bem_1_100t';
cfg.source_name = 'distr_cort_src_2';
% cfg.source_name = 'single_cort_src_1';
% cfg.source_name = 'mult_cort_src_10';
cfg.snr = snr;
cfg.iteration = '1';
if mismatch
    cfg.tag = 'rms_3sphere';
else
    cfg.tag = 'rms';
end
if clustered_data
    cfg.tag = [cfg.tag '_cluster'];
end
data_file = db.save_setup(cfg);

%% Load data
data_in = load(data_file);
results = data_in.rms_data;

%% Display the results
rmse_2_rms_input = 20*log10(...
    results.rmse./results.rms_input);
% Output the columns
col_labels = {'Beamformer', 'Peak Index', 'RMS Error',...
    'RMS Input', '20log(RMSE/RMS Input)'};
fprintf('%s | %s | %s | %s | %s\n', col_labels{:});
M = {};
for i=1:size(results.rmse,2)
    A = [results.name;...
        num2cell(results.true_peak_idx(:,i)');...
        num2cell(results.rmse(:,i)');...
        num2cell(results.rms_input(:,i)');...
        num2cell(rmse_2_rms_input(:,i)')];
    
    M = [M A];
end
fprintf('%s %d %f %f %f\n',M{:});

%% Output the results
% Set csv file name
cfg.ext = '.csv';
file_out =  db.save_setup(cfg);

% Open the file
file_ID = fopen(file_out,'wt');

% Output the header
cols = length(col_labels);
for col_idx = 1:cols
    fprintf(file_ID, '%s', col_labels{col_idx});
    if col_idx ~= cols
        fprintf(file_ID, ',');
    end
end
fprintf(file_ID, '\n');

% Output the data
data = M';
[rows, cols] = size(data);
for row_idx = 1:rows
    for col_idx = 1:cols
        % Output data depending on type
        if col_idx == 1
            fprintf(file_ID, '%s', data{row_idx, col_idx});
        elseif col_idx == 2
            fprintf(file_ID, '%d', data{row_idx, col_idx});
        else
            fprintf(file_ID, '%f', data{row_idx, col_idx});
        end
        % Add comma except at the end of the row
        if col_idx ~= cols
            fprintf(file_ID, ',');
        end
    end
    % New line at the end of the row
    fprintf(file_ID, '\n');
end
fclose(file_ID);
