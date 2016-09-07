function dist = distance_from_vertex(cfg)
%
%   cfg.head    
%       IHeadModel obj, see HeadModel
%   cfg.vertex_idx
%       index of center vertex (head model index)
%   cfg.voi_idx
%       indices of vertices of interest (head model indices)

%% Calculate the distances

% cfg for hm_get_vertices
cfg_vert = [];
cfg_vert.head = cfg.head;
cfg_vert.type = 'index';

% Select center vertex
cfg_vert.idx = cfg.vertex_idx;
% Get the coordinates of the center
[~,r_center] = hm_get_vertices(cfg_vert);

% Get the coordinates of the vertices of interest 
cfg_vert.idx = cfg.voi_idx;
[~,r] = hm_get_vertices(cfg_vert);

d_vec = r - repmat(r_center, size(r,1), 1);
d_vec = d_vec.^2;
dist = sqrt(sum(d_vec,2));

end