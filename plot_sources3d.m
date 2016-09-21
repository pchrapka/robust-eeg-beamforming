function plot_sources3d(hm,varargin)
%PLOT_SOURCES3D plots source markers
%   PLOT_BEAMPATTERN3D plots source markers
%   surface
%
%   Input
%   -----
%   hm
%       IHeadModel obj, see HeadModel
%
%   Parameters
%   ----------
%   Mode 1 - load source locations from file
%   file
%       filename of beampattern data, as computed by COMPUTE_BEAMPATTERN
%
%   Mode 2 - specify source locations
%   source_idx 
%       center voxel of beampattern
%   int_idx
%       (optional) index of interfering source
%
%   See also COMPUTE_BEAMPATTERN

p = inputParser();
addRequired(p,'hm',@(x) isa(x,'IHeadModel'));
addParameter(p,'file','',@ischar);
addParameter(p,'source_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
parse(p,hm,varargin{:});

if ~isempty(p.Results.file)
    % Load the data
    din = load(p.Results.file);
    source_idx = din.data.options.voxel_idx;
    if isfield(din.data.options, 'interference_idx');
        int_idx = din.data.options.interference_idx;
    end
else
    source_idx = p.Results.source_idx;
    if ~isempty(p.Results.int_idx)
        int_idx = p.Results.int_idx;
    end
end

%% Plot the source location
% Get the source location
[~, loc] = hm.get_vertices('type','index','idx',source_idx);

hold on;
% Plot a black circle
scatter3(loc(1), loc(2), loc(3), 100, [0 0 0], 'filled');

%% Plot the interference location
if exist('int_idx','var')
    % Get the interference location
    [~, loc] = hm.get_vertices('type','index','idx',int_idx);
    
    hold on;
    % Plot a black x
    scatter3(loc(1), loc(2), loc(3), 100, [0 0 0], 's', 'filled');
end
    

end