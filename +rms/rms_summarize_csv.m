function rms_summarize_csv(cfg)
%RMS_SUMMARIZE_CSV Outputs the RMSE summary to a csv file
%   RMS_SUMMARIZE_CSV(CFG)
%   
%   Output file
%       see db.save_setup
%
%   Method 1
%   cfg.data_set
%   cfg.tag         (optional)
%
%   Data
%
%   cfg.rms_col_labels  column labels from rms.rms_summarize
%   cfg.rms_out         rms data from rms.rms_summarize


% Set csv file name
tag = 'rms';
if isfield(cfg,'tag')
    tag = [tag cfg.tag];
end
file_out =  db.save_setup('data_set',data_set,'ext','.csv','tag',tag);

% Open the file
file_ID = fopen(file_out,'wt');

% Output the header
cols = length(cfg.rms_col_labels);
for col_idx = 1:cols
    fprintf(file_ID, '%s', cfg.rms_col_labels{col_idx});
    if col_idx ~= cols
        fprintf(file_ID, ',');
    end
end
fprintf(file_ID, '\n');

% Output the data
data = cfg.rms_out';
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

end