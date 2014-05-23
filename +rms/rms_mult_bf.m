function [rmse, rms_input] = rms_mult_bf(cfg)
%RMS_MULT_BF calculates the RMS error of the beamformer output on data
%from a multiple source scenario
%
%   cfg.bf_power
%       beamformer power
%   cfg.head
%       head struct (see hm_get_data)
%   cfg.true_peak
%       index of the true peak
%   cfg.cluster (boolean, default = false)
%       flag for clustering measurements around each source

if ~isfield(cfg,'cluster'), cfg.cluster = false; end

if cfg.cluster
    % Get all the vertices
    n_vertices = size(cfg.head.GridLoc,1);
    % cfg for hm_get_vertices
    cfg_vert = [];
    cfg_vert.head = cfg.head;
    cfg_vert.type = 'index';
    cfg_vert.idx = cfg.true_peak;
    [~,cluster_points] = hm_get_vertices(cfg_vert);
    
    
    % Calculate the midpoint
    midpoint = sum(cluster_points)/2;
    % Calculate normal (points 1->2)
    normal = cluster_points(2,:) - cluster_points(1,:);
    
    % Get all the vertices
    cfg_vert = [];
    cfg_vert.head = cfg.head;
    cfg_vert.type = 'index';
    cfg_vert.idx = 1:n_vertices;
    [~,vertices] = hm_get_vertices(cfg_vert);
    
    difference = vertices - repmat(midpoint, size(vertices,1), 1);
    dot_product = dot(difference, repmat(normal, size(vertices,1), 1),2);
    % cluster 1 corresponds to cluster_point(1,:)
    % cluster 2 corresponds to cluster_point(2,:)
    cluster_idx = (dot_product > 0)*2 + (dot_product <= 0)*1;
    
    %     X = [vertices bf_power(:)];
    %     cluster1 = X(cluster_idx == 1,:);
    %     cluster2 = X(cluster_idx == 2,:);
    %     figure
    %     h1 = scatter3(cluster1(:,1),cluster1(:,2),...
    %         cluster1(:,3),100,cluster1(:,4),'d','filled');
    %     hold on
    %     h2 = scatter3(cluster2(:,1),cluster2(:,2),...
    %         cluster2(:,3),100,cluster2(:,4),'filled');
    
    % Calculate the RMS error for each cluster
    n_rms = length(cfg.true_peak);
    rmse = zeros(n_rms,1);
    rms_peak = zeros(n_rms,1);
    for i=1:n_rms
        
        % Create the input power vector
        input_power = zeros(size(cfg.bf_power));
        input_power(cfg.true_peak(i)) = 1;
        
        % Get indices of each cluster
        poi = (cluster_idx == i);
        
        % Select one cluster at a time
        bf_power = cfg.bf_power(poi);
        input_power = input_power(poi);
        
        % Calculate the RMSE
        [rmse(i), rms_input(i)] = rms.rms_error(bf_power, input_power);
    end
else
%     % Create the input power
%     input_power = zeros(size(cfg.bf_power));
%     input_power(cfg.true_peak) = 1;
    
    % Calculate the RMSE error
    [rmse, rms_input] = rms.rms_error(cfg.bf_power, cfg.input_power);
end


end