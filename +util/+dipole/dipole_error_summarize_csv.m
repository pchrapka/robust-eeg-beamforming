function dipole_error_summarize_csv(cfg)
%DIPOLE_ERROR_SUMMARIZE_CSV Outputs the RMSE summary to a csv file
%   DIPOLE_ERROR_SUMMARIZE_CSV(CFG)
%   
%   Output file
%   cfg.data_set
%   cfg.tag         (optional)
%
%   Data
%
%   cfg.col_labels  column labels
%   cfg.col_format
%       fprintf format string for each column
%   cfg.data        
%       dipole error data in a cell array arranged like a csv file


% Set csv file name
tag = 'dipole_error_summary';
if isfield(cfg,'tag')
    tag = [tag cfg.tag];
end
file_out =  db.save_setup('data_set',data_set,'ext','.csv','tag',tag);

% Open the file
file_ID = fopen(file_out,'wt');

% Output the header
cols = length(cfg.col_labels);
for col_idx = 1:cols
    fprintf(file_ID, '%s', cfg.col_labels{col_idx});
    if col_idx ~= cols
        fprintf(file_ID, ',');
    end
end
fprintf(file_ID, '\n');

% Output the data
data = cfg.data;
[rows, cols] = size(data);
for row_idx = 1:rows
    for col_idx = 1:cols
        % Output data depending on type
        fprintf(file_ID, cfg.col_format{col_idx}, data{row_idx, col_idx});
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