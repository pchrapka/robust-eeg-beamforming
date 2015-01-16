function [cfg] = add_struct(cfg)
% adds all fields in a struct to the current row
%   cfg.map
%       mapping of fieldnames to labels and whether it's a nested struct
%   cfg.item
%       (struct) data to be added to data
%   cfg.col_labels
%       column labels for data
%   cfg.row_idx
%       row in which to add the cell
%   cfg.data
%       (cell array) collection of data

% Get the fieldnames
fields = fieldnames(cfg.item);
for i=1:length(fields)
    % Set up config and add the cell
    cfg.field_name =  fields{i};
    cfg = metrics.add_field(cfg);
end

end