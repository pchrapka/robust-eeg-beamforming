function [outfile] = view_power_surface_relative(cfg)
%VIEW_POWER_SURFACE_RELATIVE beamformer output power view
%   VIEW_POWER_SURFACE_RELATIVE sets up a view with the beamformer output
%   power plotted on the cortex surface, marked source locations and saves
%   the plot.
%
%   Data Options
%   ------------
%   cfg.datafiles (cell array)
%       file names, output from COMPUTE_POWER
%
%   View Options
%   ------------
%   cfg.sample
%       (optional) sample idx to plot
%
%   Data Set
%   --------
%   cfg.data_set 
%       SimDataSetEEG object
%
%   Output
%   ------
%   outfile
%       cell array of output files
%
%   See also COMPUTE_POWER

%% Power map 3D - relative scale
scale = 'relative';

cfgplt = [];

cfgplt.options.scale = scale;
if isfield(cfg,'sample')
    cfgplt.options.sample = cfg.sample;
end

outfile = cell(length(cfg.datafiles),1);
for i=1:length(cfg.datafiles)
    % Set up plot options
    cfgplt.file = cfg.datafiles{i};
    
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
    plot_sources3d(cfgplt);
    
    % Save the plot
    cfg.plot_func = 'plot_power3d';
    cfg.plot_cfg = cfgplt;
    outfile{i} = plot_save(cfg);
    close;
end

end