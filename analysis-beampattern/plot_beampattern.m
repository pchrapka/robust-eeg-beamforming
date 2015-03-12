function plot_beampattern()

%% Plot the beampattern
n_data = length(mag_dist_data.name);
cc=jet(n_data);

n_plots = size(beampattern_data,2);
n_cols = 2;
n_rows = ceil(n_plots/n_cols);
figure; 
for i=1:n_plots
    subplot(n_rows, n_cols, i);
    % Combine the data
    data = [distances(:,i) beampattern_data(:,i)];
    % Sort data based on distance
    data = sortrows(data,1);
    if cfg.db
        data(:,2) = db(data(:,2));
    end
    if cfg.normalize
        data(:,2) = data(:,2)/data(1,2);
    end
    plot(data(:,1),data(:,2),...
        'color',cc(i,:));
    xlim([0 data(end,1)]);
    ylabel(mag_dist_data.name{i});
end
% legend(h, mag_dist_data.name);

if isfield(cfg,'interference_idx')
    cfg_dist = [];
    cfg_dist.head = head;
    cfg_dist.vertex_idx = cfg.voxel_idx;
    cfg_dist.voi_idx = cfg.interference_idx;
    dist = distance_from_vertex(cfg_dist);
    y = ylim();
    x = [dist dist];
    line(x,y);
end

end