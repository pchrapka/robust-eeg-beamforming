function [output] = power_source(data,varargin)
%POWER_SOURCE calculates the power of the source signal
%
%   Input
%   -----
%   data
%       data matrix [components locations samples]
%
%   Parameter
%   ---------
%   mode (string, default = 'components')
%       options: 'components', 'components_samples'
%
%   Output
%   ------
%   output.power
%       power at each location and sample

p = inputParser();
addRequired(p,'data',@ismatrix);
options_mode = {'components','components_samples'};
addParameter(p,'mode','components',@(x) any(validatestring(x,options_mode)));
parse(p,data,varargin{:});

% get signal power over components
data = data.^2;
data = sum(data,1);
data = sqrt(data);
data = squeeze(data);

if isequal(p.Results.mode,'components_sample')
    % data is now [locations samples]
    data = mean(data,2);
end

output.power = data;


end