function orientation = dipole_orientation(cfg)
%DIPOLE_ORIENTATION returns the dipole orientations normal to the surface
%of the brain. 
%   cfg.head    struct containing head model
%   cfg.idx     vertices

% Get number of vertices
n_locs = length(cfg.idx);
% Get the origin of the head model
origin = hm_get_origin(cfg.head);

% Allocate memory
orientation = zeros(n_locs,3);
for i=1:n_locs
    % Set up cfg to get the location of the vertex
    cfg1 = [];
    cfg1.head = cfg.head;
    cfg1.type = 'index';
    cfg1.idx = cfg.idx(i);
    % Get the location of the vertex
    [~,loc] = hm_get_vertices(cfg1);
    
    % Approximate a normal vector by using the vector from the origin to
    % the point on the cortex
    vector = loc - origin;
    % Normalize the orientation
    orientation(i,:) = vector/norm(vector);
end

end