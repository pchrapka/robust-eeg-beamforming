function view_power_surface_relative(cfg)
%VIEW_POWER_SURFACE_RELATIVE beamformer output power view
%   VIEW_POWER_SURFACE_RELATIVE sets up a view with the beamformer output
%   power plotted on the cortex surface, marked source locations and saves
%   the plot.
%
%   cfg.head        
%       head model cfg (see hm_get_data)
%   cfg.datafile
%       array of file names

%% Power map 3D - relative scale
scale = 'relative';

% TODO Specify time, get from plot_save_paper

cfgplt = [];
cfgplt.head = cfg.head;
cfgplt.options.scale = scale;
for i=1:length(cfg.outputfile)
    % Plot the data
    cfgplt.file = cfg.outputfile{i};
%     plot_beampattern3d(cfgplt);
    plot_power3d(cfgplt);
    
    % Plot source markers
    plot_sources3d(cfgplt);
    
    % Save the plot
    cfg.plot_func = 'plot_power3d';
    cfg.plot_cfg = cfgplt;
    plot_save(cfg);
end
close all

end