function template = get_plot_save_template(plot_func, plot_cfg)
% 
%   plot_func
%       name of plot function
%   plot_cfg
%       config used with plotting function
%       

switch(plot_func)
    case 'plot_beampattern'
        [~,name,~] = fileparts(plot_cfg.file);
        template = [name '_' plot_cfg.scale];
        
    case 'plot_beampattern3d'
        [~,name,~] = fileparts(plot_cfg.file);
        template = [name '3d_' plot_cfg.options.scale];
        
    otherwise
        error(['reb:' mfilename],...
            'unknown function plot_func %s', plot_func);
        
end

end