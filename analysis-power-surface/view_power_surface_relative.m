function [outfile] = view_power_surface_relative(data_set,datafiles,varargin)
%VIEW_POWER_SURFACE_RELATIVE beamformer output power view
%   VIEW_POWER_SURFACE_RELATIVE sets up a view with the beamformer output
%   power plotted on the cortex surface, marked source locations and saves
%   the plot.
%
%   Input
%   -----
%   data_set (SimDataSetEEG object)
%       original data set 
%   datafiles (cell array)
%       file names, output from COMPUTE_POWER
%
%   Parameters
%   ----------
%   sample (integer, default = [])
%       sample idx to plot
%   source_idx 
%       center voxel of beampattern
%   int_idx
%       (optional) index of interfering source
%
%   Output
%   ------
%   outfile
%       cell array of output files
%
%   See also COMPUTE_POWER

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'datafiles',@iscell);
addParameter(p,'sample',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'source_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
parse(p,data_set,datafiles,varargin{:});

%% Power map 3D - relative scale
cfgplt = [];
cfgplt.options.scale = 'relative';
if ~isempty(p.Results.sample)
    cfgplt.options.sample = p.Results.sample;
end

cfg = [];
cfg.data_set = data_set;

outfile = cell(length(datafiles),1);
for i=1:length(datafiles)
    % Set up plot options
    cfgplt.file = datafiles{i};
    
    % Set up plot save options
    cfg.plot_func = 'plot_power3d';
    cfg.plot_cfg = cfgplt;
    
    % Get file name
    outfile{i} = plot_save_filename(cfg);
    
    % Check if plot exists
    if exist(outfile{i}, 'file')
        fprintf('Skipping %s\n\tImage exists\n', outfile{i});
        continue;
    end
    % TODO Consider adding flags to control viewing vs saving vs
    % overwriting
    
    % Plot the data
    plot_power3d(cfgplt);
    
    % Plot source markers
    plot_sources3d(cfgplt.head,...
        'source_idx',p.Results.source_idx,'int_idx',p.Results.int_idx);
    
    % Save the plot
    cfg.plot_func = 'plot_power3d';
    cfg.plot_cfg = cfgplt;
    outfile{i} = plot_save(cfg);
    close;
end

end