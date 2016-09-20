function save_csv(cfg)
%SAVE_CSV Outputs the metric data to a csv file
%   SAVE_CSV(CFG)
%   
%   Output file
%   cfg.file_name
%   cfg.save_name
%   cfg.tag
%
%   Data
%
%   cfg.col_labels  column labels from rms.rms_summarize
%   cfg.col_format  column labels from rms.rms_summarize
%   cfg.data         rms data from rms.rms_summarize


file_out =  db.save_setup(...
    'file_name',cfg.file_name,...
    'save_name',cfg.save_name,...
    'tag',cfg.tag,...
    'ext','.csv');

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
        % Output data
        if ischar(data{row_idx, col_idx}) && isequal(cfg.col_format{col_idx},'%d')
            fprintf(file_ID,...
                cfg.col_format{col_idx}, str2double(data{row_idx, col_idx}));
        else
            fprintf(file_ID,...
                cfg.col_format{col_idx}, data{row_idx, col_idx});
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