function [out] = to_csv(data)
%
%   data
%       output from metrics.run_metrics_on_files and saved by metrics.save

% Create a mapping between the field name and field label
map.bf_name.field_label = 'Beamformer';
map.bf_name.format = '%s';
map.data_set.field_label = 'Data Set';
map.data_set.format = '%s';
map.sim_name.field_label = 'Sim Name';
map.sim_name.format = '%s';
map.source_name.field_label = 'Source Name';
map.source_name.format = '%s';
map.snr.field_label = 'SNR';
map.snr.format = '%d';
map.iteration.field_label = 'Iteration';
map.iteration.format = '%d';
map.metrics.field_label = 'Metrics';
map.metrics.format = '%s';
map.name.field_label = 'Name';
map.name.format = '%s';
map.location_idx.field_label = 'Location Index';
map.location_idx.format = '%d';
map.output.field_label = 'Output';
map.output.format = '%f';

cfg = [];
cfg.map = map;
cfg.col_labels = {};
cfg.row_idx = 1;
% Loop through each data item
for i=1:length(data)
    % Copy the current item
    item = data(i);
    
    % Insert a row for each metric
    for j=1:length(item.metrics)
        % Insert item data
        fields = fieldnames(item);
        for k=1:length(fields)
            field_name = fields{k};
            field_struct = isstruct(item.(field_name));
            switch field_name
                case 'metrics'
                    % Add the cells related to the metric
                    % Prefix the labels
                    cfg.prefix = cfg.map.(field_name).field_label;
                    % Set to the current metrics item
                    cfg.item = item.metrics(j);
                    % Add the metric
                    cfg = metrics.add_struct(cfg);
                otherwise
                    switch field_struct
                        case 0
                            % Add individual cell
                            % Update the cfg
                            cfg.field_name = field_name;
                            if isfield(cfg, 'prefix')
                                cfg = rmfield(cfg,'prefix');
                            end
                            cfg.item = item;
                            cfg = metrics.add_cell(cfg);
                        case 1
                            % Add a whole struct
                            % Prefix the labels
                            cfg.prefix = cfg.map.(field_name).field_label;
                            % Set the current field as the item
                            cfg.item = item.(field_name);
                            cfg = metrics.add_struct(cfg);
                        otherwise
                            error('metrics:to_csv',...
                                'unrecognized field type');
                    end
            end
        end
        
        % Incerement the row
        cfg.row_idx = cfg.row_idx + 1;
    end

end

% Set up the output
out.col_format = cfg.col_format;
out.col_labels = cfg.col_labels;
out.data = cfg.data;

end