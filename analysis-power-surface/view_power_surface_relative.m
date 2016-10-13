function [outfile] = view_power_surface_relative(datafiles,samples,varargin)
%VIEW_POWER_SURFACE_RELATIVE beamformer output power view
%   VIEW_POWER_SURFACE_RELATIVE sets up a view with the beamformer output
%   power plotted on the cortex surface, marked source locations and saves
%   the plot.
%
%   Input
%   -----
%   datafiles (cell array)
%       file names, output from COMPUTE_POWER
%   samples (integer or vector)
%       sample indices to plot
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
%   Output
%   ------
%   outfile
%       cell array of output files
%
%   See also COMPUTE_POWER

p = inputParser();
addRequired(p,'datafiles',@iscell);
addRequired(p,'samples',@(x) ~isempty(x) && length(x) >= 1);
addParameter(p,'source_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'save',true,@islogical);
parse(p,datafiles,samples,varargin{:});

%% Power map 3D - relative scale
outfile = cell(length(datafiles),1);
for i=1:length(datafiles)
    
    vobj = ViewSources(datafiles{i});
    
    % Plot the data
    cfgplt = [];
    cfgplt.options.scale = 'relative';
    if ~isempty(p.Results.samples)
        cfgplt.options.samples = p.Results.samples;
    end
    vobj.plot('power3d',cfgplt);
    
    % Plot source markers
    vobj.show_sources('source_idx',p.Results.source_idx,...
        'int_idx',p.Results.int_idx);
    
    vobj.save();
    
    % Save the plot
    if p.Results.save
        % Set up plot save options
        outfile{i} = vobj.save();
    end
    
    close;
end

end