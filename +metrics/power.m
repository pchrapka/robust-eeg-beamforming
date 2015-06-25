function [output] = power(cfg)
%POWER calculates the power of the signal
%   cfg.data
%       data matrix [components locations samples]
%
%   Output
%   ------
%   output.power
%       power at each location and sample

data = cfg.data.^2;
data = sum(data,1);
data = sqrt(data);
data = squeeze(data);

output.power = data;


end