function plot_beampatternhd_mult17hd_relativedist(cfg)

%% Beampattern 1D - relative-dist scale
scale = 'relative-dist';

cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.scale = scale;
for i=1:length(cfg.outputfile)
    vobj = ViewSources(cfg.outputfile{i});
    
    % Plot the data
    vobj.plot('beampattern',cfgplt);
    
    % Save the plot
    vobj.save();
end
close all


%% Beampattern 3D - relative-dist scale
scale = 'relative-dist';

cfgplt = [];
cfgplt.options.scale = scale;
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