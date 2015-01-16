function [cfg] = add_field(cfg)
% add field as cell in csv-style data struct
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

% Check if the field exists
if isfield(cfg.item, cfg.field_name)
    % Check if there is a mapping
    if ~isfield(cfg.map, cfg.field_name)
        fprintf(['missing the field label mapping for %s.\n'...
            'add the mapping in metrics.to_csv\n'],...
            cfg.field_name );
    end
    
    % Check if the field is a struct
    if isstruct(cfg.item.(cfg.field_name))
        old = [];
        % Add a whole struct
        % Prefix the labels with the current field
        if isfield(cfg, 'prefix')
            % If there already is a prefix, add a suffix to the prefix
            old.prefix = cfg.prefix;
            cfg.prefix = [cfg.prefix ' ' cfg.map.(cfg.field_name).field_label];
        else
            cfg.prefix = cfg.map.(cfg.field_name).field_label;
        end
        % Save the old item
        old.item = cfg.item;
        % Set up cfg to go deeper
        cfg.item = cfg.item.(cfg.field_name);
        % Add the struct field
        cfg = metrics.add_struct(cfg);
        
        % Restore the cfg
        cfg.item = old.item;
        if isfield(old,'prefix')
            cfg.prefix = old.prefix;
        else
            cfg = rmfield(cfg, 'prefix');
        end
    else
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

end