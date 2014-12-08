function output = vertex_distances(cfg)
%VERTEX_DISTANCES calculates the distance between all the vertices and a
%vertex of interest
%
%   cfg.head    
%       head struct (see hm_get_data)
%   cfg.voi_idx
%       index for vertex of interest
%   cfg.location_idx
%       vector of indices where distance is to be calculated
%
%   Output
%   ------
%   output.distance

%% Calculate the distances

% cfg for hm_get_vertices
cfg_vert = [];
cfg_vert.head = cfg.head;
cfg_vert.type = 'index';
cfg_vert.idx = cfg.voi_idx;
% Get the coordinates of the max
[~,r_voi] = hm_get_vertices(cfg_vert);

% Get the coordinates of the poi 
cfg_vert.idx = cfg.location_idx;
[~,r] = hm_get_vertices(cfg_vert);

d_vec = r - repmat(r_voi,size(r,1),1);
d_vec = d_vec.^2;
output.distance = sqrt(sum(d_vec,2));

end