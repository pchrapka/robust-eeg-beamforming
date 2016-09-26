function [beampattern, varargout] = beampattern(cfg)
%BEAMPATTERN calculates the beampattern of a beamformer
%   cfg.beamformer_file
%               (string) path to beamformer output data
%   cfg.voxel_idx
%               index of voxel of interest
%   cfg.distances
%               (boolean), flag to calculate distances between each vertex
%               and the vertex of interest
%   cfg.head    IHeadModel obj, see HeadModel

% Load the beamformer output data
data_in = load(cfg.beamformer_file);

% Determine the number of locations
n_locs = cfg.head.get_numvertices();

% Allocate memory
beampattern = zeros(n_locs,1);
beamtrace = zeros(n_locs,1);
if cfg.distances
    distances = zeros(n_locs,1);
end
% FIXME beampattern needs to be the proper size

% Get index of voxel location in the data array
W = data_in.source.filter{data_in.source.loc == cfg.voxel_idx};

progbar = ProgressBar(n_locs,'Computing beampattern');
hm = cfg.head;
distances_flag = cfg.distances;
voxel_idx = cfg.voxel_idx;
parfor loc=1:n_locs
    % update progress bar
    progbar.progress();
    
    % Extract the leadfield at each index
    H = hm.get_leadfield(loc);
    
    % Calculate the frobenius norm of the gain matrix
    beampattern(loc,1) = norm(W'*H, 'fro');
    beamtrace(loc,1) = trace(W'*H);
    
    if distances_flag
        % Calculate the distance of the current vertex from the voxel of
        % interest
        cfg_dist = [];
        cfg_dist.head = hm;
        cfg_dist.vertex_idx = voxel_idx;
        cfg_dist.voi_idx = loc;
        distances(loc,1) = distance_from_vertex(cfg_dist);
    end
end
progbar.stop();

% Output the distances, if needed
if cfg.distances
    varargout(1) = {distances};
end

end