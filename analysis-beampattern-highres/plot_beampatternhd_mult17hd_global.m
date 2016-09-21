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
    
    vobj = ViewSources(cfg.outputfile{i});
    
    % Plot the data
    vobj.plot('beampattern',cfgplt);
    
    % Save the plot
    vobj.save();
end
close all

%% Beampattern 3D - global absolute scale
scale = 'globalabsolute';

if ~isequal(scale, 'absolute') && ~isequal(scale, 'relative')
    data_limit = get_beampattern_data_limit(cfg.outputfile, scale);
end

for i=1:length(cfg.outputfile)
    
    vobj = ViewSources(cfg.outputfile{i});
    
    % Plot the data
    cfgplt = [];
    cfgplt.options.scale = scale;
    cfgplt.options.data_limit = data_limit;
    vobj.plot('beampattern3d',cfgplt);
    
    % Plot source markers
    vobj.show_sources();
    
    vobj.save();

end
close all

end