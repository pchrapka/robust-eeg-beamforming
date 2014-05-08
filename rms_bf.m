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
%   cfg.n_clusters

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
    cfg_vert.idx = 1:n_vertices;
    [~,vertices] = hm_get_vertices(cfg_vert);
    
%     % Concatenate the location data with the power data
%     X = [vertices bf_power(:)]; 
%     % Fit the gaussian mixture model
%     obj = gmdistribution.fit(X, cfg.n_clusters);
%     
%     idx = cluster(obj,X);
%     cluster1 = X(idx == 1,:);
%     cluster2 = X(idx == 2,:);
%     figure
%     h1 = scatter3(cluster1(:,1),cluster1(:,2),cluster1(:,3),100,cluster1(:,4),'d','filled');
%     hold on
%     h2 = scatter3(cluster2(:,1),cluster2(:,2),cluster2(:,3),100,cluster2(:,4),'filled');
%     
%     opts = statset('Display','final');
% 
%     [idx,ctrs] = kmeans(X,2,...
%         'Distance','city',...
%         'Replicates',5,...
%         'Options',opts);
%     
%     cluster1 = X(idx == 1,:);
%     cluster2 = X(idx == 2,:);
% %     figure
% %     h1 = scatter3(cluster1(:,1),cluster1(:,2),cluster1(:,3),100,'r.');
% %     hold on
% %     h2 = scatter3(cluster2(:,1),cluster2(:,2),cluster2(:,3),100,'g.');
% %     scatter3(ctrs(:,1),ctrs(:,2),ctrs(:,3),110,'kx');
%     
%     figure
%     scatter3(cluster1(:,1),cluster1(:,2),cluster1(:,3),100,cluster1(:,4),'d','filled')
%     hold on
%     scatter3(cluster2(:,1),cluster2(:,2),cluster2(:,3),100,cluster2(:,4),'filled')
end

%% Select points of interest

poi = true(size(bf_power));
% Select all points except the peak
poi(cfg.true_peak) = false;

%% Calculate the RMS error
rms = sqrt(sum(bf_power(poi).^2)/length(bf_power));
rms_peak = bf_power(cfg.true_peak);
end