function output = vertex_distances(cfg)
%VERTEX_DISTANCES calculates the distance between all the vertices and a
%vertex of interest
%
%   cfg.head    
%       IHeadModel obj, see HeadModel
%   cfg.voi_idx
%       index for vertex of interest
%   cfg.location_idx
%       vector of indices where distance is to be calculated
%
%   Output
%   ------
%   output.distance

%% Calculate the distances

% Get the coordinates of the max
[~,r_voi] = cfg.head.get_vertices('type','index','idx',cfg.voi_idx);

% Get the coordinates of the poi 
[~,r] = cfg.head.get_vertices('type','index','idx',cfg.location_idx);

d_vec = r - repmat(r_voi,size(r,1),1);
d_vec = d_vec.^2;
output.distance = sqrt(sum(d_vec,2));

end