function [outfile] = view_beampattern(datafiles,varargin)
%VIEW_BEAMPATTERN view the beampattern
%   VIEW_BEAMPATTERN sets up a view with the beamformer beampattern plotted
%   on the cortex surface, marked source locations and saves the plot.
%
%   Input
%   -----
%   datafiles (cell array)
%       file names, output from COMPUTE_POWER
%
%   Parameters
%   ----------
%   source_idx 
%       center voxel of beampattern
%   int_idx
%       (optional) index of interfering source
%   save (logical, default = true)
%       flag for saving the plot
%
%   additional options are passed to the plotting function from
%   ViewSources.plot
%
%   Output
%   ------
%   outfile
%       cell array of output files
%
%   See also COMPUTE_POWER

p = inputParser();
p.KeepUnmatched = true;
addRequired(p,'datafiles',@iscell);
% addParameter(p,'sample',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'source_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'save',true,@islogical);
% plot options
addParameter(p,'type','beampattern',@ischar); % defer checking to ViewSource.plot
parse(p,datafiles,varargin{:});

%% Set up plot config

% get the data limit
scale = p.Unmatched.scale;
if ~isequal(scale, 'absolute') && ~isequal(scale, 'relative')...
        && ~isequal(scale, 'relative-dist')
    data_limit = get_beampattern_data_limit(datafiles, scale);
else
    data_limit = [];
end

% Set up plot config
cfgplt = [];
switch p.Results.type
    case 'beampattern'
        cfgplt = p.Unmatched;
        if ~isempty(data_limit)
            cfgplt.data_limit = data_limit;
        end
    case 'beampattern3d'
        cfgplt.options = p.Unmatched;
        if ~isempty(data_limit)
            cfgplt.options.data_limit = data_limit;
        end
    otherwise
        error('unknown beampattern type: %s', p.Results.type);
end

%% Beampattern
outfile = cell(length(datafiles),1);
for i=1:length(datafiles)
    
    vobj = ViewSources(datafiles{i});

    % Plot the data
    vobj.plot(p.Results.type,cfgplt);
    
    if isequal(p.Results.type,'beampattern3d')
        % Plot source markers
        vobj.show_sources('source_idx',p.Results.source_idx,...
            'int_idx',p.Results.int_idx);
    end
    
    % Save the plot
    if p.Results.save
        % Set up plot save options
        outfile{i} = vobj.save();
    end
    
    close;
end

end