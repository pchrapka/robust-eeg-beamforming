function plot_power_surface(data_set,beamformers,varargin)
%   Input
%   -----
%   data_set (SimDataSetEEG object)
%       original data set 
%   beamformers (cell array)
%       beamformer cfg file tags to process
%
%   Parameters
%   ----------
%   source_idx 
%       center voxel of beampattern
%   int_idx
%       (optional) index of interfering source
%   mode (string, default = instant)
%       mode for power calculation, 
%       'instant' = instantaneous for each location and sample
%       'average' = average over samples
%   sample (integer, default = [])
%       sample idx to plot
%

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addParameter(p,'source_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'mode','instant',@(x) any(validatestring(x,{'instant','average'})));
addParameter(p,'sample',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'force',false,@islogical); % REMOVE? unused

parse(p,data_set,beamformers,varargin{:});

%% Compute the beamformer output power
outputfiles = compute_power(p.Results.data_set, p.Results.beamformers,'mode',p.Results.mode);

%% Plot the surface
switch p.Results.mode
    case 'instant'
        % do nothing
    case 'average'
        if p.Results.sample > 0 
            warning('sample idx is not required when using average power');
        end
end

view_power_surface_relative(p.Results.data_set,outputfiles,...
    'sample',p.Results.sample,...
    'source_idx',p.Results.source_idx,'int_idx',p.Results.int_idx);

end