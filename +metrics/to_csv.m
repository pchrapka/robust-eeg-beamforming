function [out] = to_csv(data)
%
%   data
%       output from metrics.run_metrics_on_files and saved by metrics.save

% Create a mapping between the field name and field label
% NOTE There should be no duplicate fields or duplicate field labels
map.bf_name.field_label = 'Beamformer';
map.bf_name.format = '%s';
map.data_set.field_label = 'Data Set';
map.data_set.format = '%s';
map.sim_name.field_label = 'Sim Name';
map.sim_name.format = '%s';
map.source_name.field_label = 'Source Name';
map.source_name.format = '%s';
map.iteration.field_label = 'Iteration';
map.iteration.format = '%d';
map.metrics.field_label = 'Metrics';
map.metrics.format = '%s';
map.name.field_label = 'Name';
map.name.format = '%s';
map.location_idx.field_label = 'Location Index';
map.location_idx.format = '%d';
map.sample_idx.field_label = 'Sample Index';
map.sample_idx.format = '%d';
map.output.field_label = 'Output';
map.output.format = '%f';
map.snr.field_label = 'SNR';
map.snr.format = '%f';
map.snrdb.field_label = 'SNR (dB)';
map.snrdb.format = '%f';
map.inr.field_label = 'INR';
map.inr.format = '%f';
map.inrdb.field_label = 'INR (dB)';
map.inrdb.format = '%f';
map.sinr.field_label = 'SINR';
map.sinr.format = '%f';
map.sinrdb.field_label = 'SINR (dB)';
map.sinrdb.format = '%f';
map.flip.field_label = 'Flip';
map.flip.format = '%d';
map.rmse_x.field_label = 'RMSE X';
map.rmse_x.format = '%f';
map.rmse_y.field_label = 'RMSE Y';
map.rmse_y.format = '%f';
map.rmse_z.field_label = 'RMSE Z';
map.rmse_z.format = '%f';
map.rmsedb_x.field_label = 'RMSE X (dB)';
map.rmsedb_x.format = '%f';
map.rmsedb_y.field_label = 'RMSE Y (dB)';
map.rmsedb_y.format = '%f';
map.rmsedb_z.field_label = 'RMSE Z (dB)';
map.rmsedb_z.format = '%f';
map.rmse_alpha.field_label = 'RMSE Norm Constant';
map.rmse_alpha.format = '%f';
map.voi_idx.field_label = 'Vertex of Interest';
map.voi_idx.format = '%d';
map.distance.field_label = 'Dsitance';
map.distance.format = '%f';

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
            switch field_name
                case 'metrics'
                    % Add the cells related to the metric
                    % Prefix the labels
                    cfg.prefix = cfg.map.(field_name).field_label;
                    % Set to the current metrics item
                    cfg.item = item.metrics(j);
                    % Add the metric
                    cfg = metrics.add_struct(cfg);
                    % Remove the prefix
                    cfg = rmfield(cfg, 'prefix');
                otherwise
                    % Add individual cell
                    % Update the cfg
                    cfg.field_name = field_name;
                    cfg.item = item;
                    cfg = metrics.add_field(cfg);
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