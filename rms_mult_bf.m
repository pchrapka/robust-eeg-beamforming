function [rms, rms_peak] = rms_mult_bf(cfg)
%RMS_MULT_BF calculates the RMS error of the beamformer output on data
%from a multiple source scenario
%
%   cfg.bf_power
%       beamformer power
%   cfg.head    
%       head struct (see hm_get_data)
%   cfg.true_peak
%       index of the true peak

% Get all the vertices
n_vertices = size(bf,2);
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
rms = zeros(n_rms,1);
rms_peak = zeros(n_rms,1);
for i=1:n_rms
    poi = (cluster_idx == i);
    [rms(i), rms_peak(i)] = rms_error(...
        cfg.bf_power, cfg.true_peak(i), poi);
end


end