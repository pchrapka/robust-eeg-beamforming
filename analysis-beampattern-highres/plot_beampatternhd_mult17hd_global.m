function plot_beampatternhd_mult17hd_global(cfg)

%% Beampattern 1D - global scale
scale = 'globalabsolute';

cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.scale = scale;
if ~isequal(scale, 'absolute') && ~isequal(scale, 'relative')
    cfgplt.data_limit = get_beampattern_data_limit(cfg.outputfile, scale);
end
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

%% Beampattern 3D - global absolute scale
scale = 'globalabsolute';

cfgplt = [];
cfgplt.head = cfg.head;
cfgplt.options.scale = scale;
if ~isequal(scale, 'absolute') && ~isequal(scale, 'relative')
    cfgplt.options.data_limit = get_beampattern_data_limit(cfg.outputfile, scale);
end
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