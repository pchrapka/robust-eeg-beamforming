close all;

%% Set up config to get the data file

% Specify the point of interest
location_idx = 295;

cfg = [];
hmfactory = HeadModel();
cfg.head = hmfactory.createHeadModel('brainstorm', 'head_Default1_bem_500V.mat');

%% Load the head model
cfg.head.load();
head = cfg.head.data;
% FIXME don't copy data

%% Get the coordinates of the poi
cfg_vert = [];
cfg_vert.head = head;
cfg_vert.type = 'index';

cfg_vert.idx = location_idx;
[~,r] = hm_get_vertices(cfg_vert);

%% Get the coordinates of all the vertices
cfg_vert.idx = 1:size(head.GridLoc,1);
[~,r_all] = hm_get_vertices(cfg_vert);

%% Calculate the distance between the poi and all the other vertices
d_vec = r_all - repmat(r,size(r_all,1),1);
d_vec = d_vec.^2;
d_mag = sqrt(sum(d_vec,2));

%% Sort the vertices by distance from the poi
% Add vertex index as the second column
d_mag(:,2) = 1:size(head.GridLoc,1);
% Sort rows in ascending order
sorted = sortrows(d_mag, 1);

%% Print the closest vertices

n_closest = 10;
fprintf('%d closest vertices to %d:\n', n_closest, location_idx);
for i=1:n_closest
    fprintf('\t%d %f\n', sorted(i,2), sorted(i,1));
end