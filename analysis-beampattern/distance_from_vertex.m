function dist = distance_from_vertex(cfg)
%
%   cfg.head    
%       IHeadModel obj, see HeadModel
%   cfg.vertex_idx
%       index of center vertex (head model index)
%   cfg.voi_idx
%       indices of vertices of interest (head model indices)

%% Calculate the distances
% Get the coordinates of the center
[~,r_center] = cfg.head.get_vertices('type','index','idx',cfg.vertex_idx);

% Get the coordinates of the vertices of interest 
[~,r] = cfg.head.get_vertices('type','index','idx',cfg.void_idx);

d_vec = r - repmat(r_center, size(r,1), 1);
d_vec = d_vec.^2;
dist = sqrt(sum(d_vec,2));

end