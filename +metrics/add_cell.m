function [cfg] = add_cell(cfg)
%
%   cfg.field_name
%       current fieldname to reference in item
%   cfg.map
%       mapping of fieldnames to labels and their formats
%       Example:
%           map.snr.field_label = 'SNR';
%           map.snr.format = '%d';
%   cfg.prefix
%       prefix for the column label, this avoids conflicts if you have
%       a nested struct
%   cfg.item
%       (struct) data to be added to data, must contain a field named
%       cfg.field_name
%   cfg.col_labels
%       column labels for data
%   cfg.col_format
%       column formatting
%   cfg.row_idx
%       row in which to add the cell
%   cfg.data
%       (cell array) collection of data

if isfield(cfg.item, cfg.field_name)
    % Get the field label from the map
    if isfield(cfg, 'prefix')
        field_label = [cfg.prefix ' ' cfg.map.(cfg.field_name).field_label];
    else
        field_label = [cfg.map.(cfg.field_name).field_label];
    end
    
    % Check if the column exists
    if isempty(metrics.get_label_idx(cfg.col_labels, field_label))
        % Add the column
        col_idx = length(cfg.col_labels) + 1;
        cfg.col_labels{col_idx} = field_label;
        cfg.col_format{col_idx} = cfg.map.(cfg.field_name).format;
    end
    % Get the column index
    idx = metrics.get_label_idx(cfg.col_labels, field_label);
    % Add the data
    cfg.data{cfg.row_idx,idx} = cfg.item.(cfg.field_name);
end

end