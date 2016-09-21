function plot_beampatternhd_mult17hd_relative(cfg)

%% Beampattern 1D - relative scale
scale = 'relative';

cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.scale = scale;
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


%% Beampattern 3D - relative scale
scale = 'relative';

cfgplt = [];
cfgplt.head = cfg.head;
cfgplt.options.scale = scale;
for i=1:length(cfg.outputfile)
    % Plot the data
    cfgplt.file = cfg.outputfile{i};
    plot_beampattern3d(cfgplt);
    
    % Plot source markers
    plot_sources3d(cfgplt.head,'file',cfgplt.file);
    
    % Save the plot
    cfg.plot_func = 'plot_beampattern3d';
    cfg.plot_cfg = cfgplt;
    plot_save(cfg);
end
close all

end