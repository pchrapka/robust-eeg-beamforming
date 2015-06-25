function plot_beampatternhd_mult17hd_mad(cfg)

mad_multiple = 8;
%% Beampattern 1D - mad scale
scale = 'mad';

cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.scale = scale;
cfgplt.mad_multiple = mad_multiple;
for i=1:length(cfg.outputfile)
    % Plot the data
    cfgplt.file = cfg.outputfile{i};
    plot_beampattern(cfgplt);
    
    % Save the plot
    cfg.plot_func = 'plot_beampattern';
    cfg.plot_cfg = cfgplt;
    plot_save(cfg);
end
close all

%% Beampattern 3D - mad scale
scale = 'mad';

cfgplt = [];
cfgplt.head = cfg.head;
cfgplt.options.scale = scale;
cfgplt.options.mad_multiple = mad_multiple;
for i=1:length(cfg.outputfile)
    % Plot the data
    cfgplt.file = cfg.outputfile{i};
    plot_beampattern3d(cfgplt);
    
    % Plot source markers
    plot_sources3d(cfgplt);
    
    % Save the plot
    cfg.plot_func = 'plot_beampattern3d';
    cfg.plot_cfg = cfgplt;
    plot_save(cfg);
end
close all

end