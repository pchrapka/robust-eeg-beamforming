function plot_beampatternhd_mult17hd_globaldist(cfg)

%% Beampattern 1D - global scale
scale = 'globalabsolute-dist';

cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.scale = scale;
if ~isequal(scale, 'absolute') && ~isequal(scale, 'relative')
    cfgplt.data_limit = get_beampattern_data_limit(cfg.outputfile, scale);
end
for i=1:length(cfg.outputfile)
    
    vobj = ViewSources(cfg.outputfile{i});
    
    % Plot the data
    vobj.plot('beampattern',cfgplt);
    
    % Save the plot
    vobj.save();
end
close all

%% Beampattern 3D - global absolute scale
scale = 'globalabsolute-dist';

cfgplt = [];
cfgplt.options.scale = scale;
if ~isequal(scale, 'absolute') && ~isequal(scale, 'relative')
    cfgplt.options.data_limit = get_beampattern_data_limit(cfg.outputfile, scale);
end

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