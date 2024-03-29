function [rmse, rms_input] = rms_mult_bf(cfg)
%RMS_MULT_BF calculates the RMS error of the beamformer output on data
%from a multiple source scenario
%
%   cfg.bf_out
%       beamformer amplitude
%   cfg.input
%       input amplitude
%   cfg.head
%       IHeadModel obj, see HeadModel
%   cfg.true_peak
%       index of the true peak
%   cfg.cluster (boolean, default = false)
%       flag for clustering measurements around each source

if ~isfield(cfg,'cluster'), cfg.cluster = false; end

if cfg.cluster
    warning('reg:rms_mult_bf',...
        'i think clustering might be broken');
    % Get all the vertices
    n_vertices = size(cfg.head.data.GridLoc,1);
    [~,cluster_points] = cfg.head.get_vertices('type','index','idx',cfg.true_peak);
    
    
    % Calculate the midpoint
    midpoint = sum(cluster_points)/2;
    % Calculate normal (points 1->2)
    normal = cluster_points(2,:) - cluster_points(1,:);
    
    % Get all the vertices
    [~,vertices] = cfg.head.get_vertices('type','index','idx',1:n_vertices);
    
    difference = vertices - repmat(midpoint, size(vertices,1), 1);
    dot_product = dot(difference, repmat(normal, size(vertices,1), 1),2);
    % cluster 1 corresponds to cluster_point(1,:)
    % cluster 2 corresponds to cluster_point(2,:)
    cluster_idx = (dot_product > 0)*2 + (dot_product <= 0)*1;
    
    %     X = [vertices bf_out(:)];
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
        input = zeros(size(cfg.bf_out));
        input(cfg.true_peak(i)) = 1;
        
        % Get indices of each cluster
        poi = (cluster_idx == i);
        
        % Select one cluster at a time
        bf_out = cfg.bf_out(poi);
        input = input(poi);
        
        % Calculate the RMSE
        [rmse(i), rms_input(i), ~] = rms.rms_error(bf_out, input);
    end
else
    % Calculate the RMSE error
    [rmse, rms_input, ~] = rms.rms_error(cfg.bf_out, cfg.input);
end


end