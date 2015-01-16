function [output] = beamform(cfg)
%BEAMFORM calculates the beamformer output
%   cfg.filter
%       cell array of spatial filters [channels components]
%   cfg.data
%       data matrix [channels samples]
%
%   Output
%   ------
%   output
%       cell array of beamformer outputs at each location [components samples]


% Allocate memory
n_locs = length(cfg.filter);
output = cell(n_locs,1);

for i=1:length(cfg.filter)
    % Calculate the beamformer output [components x samples]
    output{i} = cfg.filter{i}'*cfg.data;
end

end