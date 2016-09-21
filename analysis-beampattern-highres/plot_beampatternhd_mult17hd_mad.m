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
    
    vobj = ViewSources(cfg.outputfile{i});
    
    % Plot the data
    vobj.plot('beampattern',cfgplt);
    
    % Save the plot
    vobj.save();
end
close all

%% Beampattern 3D - mad scale
scale = 'mad';

cfgplt = [];
cfgplt.options.scale = scale;
cfgplt.options.mad_multiple = mad_multiple;
for i=1:length(cfg.outputfile)
    
    vobj = ViewSources(cfg.outputfile{i});
    
    % Plot the data
    vobj.plot('beampattern3d',cfgplt);
    
    % Plot source markers
    vobj.show_sources();
    
    vobj.save();
end
close all

end