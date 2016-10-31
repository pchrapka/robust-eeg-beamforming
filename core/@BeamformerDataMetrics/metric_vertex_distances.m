function output = metric_vertex_distances(obj,varargin)
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

p = inputParser();
addParameter(p,'head',[],@(x) isa(x,'IHeadModel'));
addParameter(p,'location_idx',[],@(x) ~isempty(x) && length(x) == 1);
addParameter(p,'voi_idx',[],@(x) ~isempty(x) && length(x) == 1);
parse(p,varargin{:});

% Calculate the distances

% Get the coordinates of the max
[~,r_voi] = p.Results.head.get_vertices('type','index','idx',p.Results.voi_idx);

% Get the coordinates of the poi 
[~,r] = p.Results.head.get_vertices('type','index','idx',p.Results.location_idx);

d_vec = r - repmat(r_voi,size(r,1),1);
d_vec = d_vec.^2;
output.distance = sqrt(sum(d_vec,2));
output.location_idx = p.Results.location_idx;
output.voi_idx = p.Results.voi_idx;

end