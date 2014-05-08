function [rms, rms_peak] = rms_bf(cfg)
%RMS_BF calculates the RMS error of the beamformer
%
%   cfg.head    head struct (see hm_get_data)
%   cfg.bf_out  beamformer output [components vertices samples]
%   cfg.sample_idx
%               sample index at which to calculate the dispersion
%   cfg.true_peak
%               index of the true peak
%
%   cfg.cluster
%       simple clustering based on a plane between two vertices specified
%       by cfg.true_peak

% TODO At what time do I do it? 
% - User-input?
% - Max response?

% Load the beamformer output
% data_bf = load(cfg.bf_out);
bf = cfg.bf_out;

% Double check that the beamformer output is correct
n_comp = size(bf,1);
if n_comp ~= 3
    error('rmvb:rms_bf',...
        ['Check the size of the beamformer output ' num2str(n_comp)]);
end

%% Calculate the power at each index and the user's sample index
% Select the data at the user sample index
bf_select = squeeze(bf(:,:,cfg.sample_idx)); 

% Square each element
bf_select = bf_select.^2;
% Sum the components at each index and each time point
bf_sum = sum(bf_select,1);
% Take the square root of each element
bf_power = sqrt(bf_sum);

if ~isvector(bf_power)
    warning('rmvb:rms_bf',...
        'A matrix version has not been implemented');
end

%% Cluster the data
if cfg.cluster
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
        [rms(i), rms_peak(i)] = calc_rms(...
            bf_power, cfg.true_peak(i), poi);
    end
    
else
    % Calculate the RMS error
    poi = true(size(bf_power));
    [rms, rms_peak] = calc_rms(bf_power, cfg.true_peak, poi);
end
end

function [rms, rms_peak] = calc_rms(bf_power, true_peak, poi)
% Select all points except the peak
poi(true_peak) = false;

% Calculate the RMS error
rms = sqrt(sum(bf_power(poi).^2)/length(bf_power));
rms_peak = bf_power(true_peak);
end