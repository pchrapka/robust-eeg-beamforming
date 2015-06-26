function view_power_surface_relative(cfg)
%VIEW_POWER_SURFACE_RELATIVE beamformer output power view
%   VIEW_POWER_SURFACE_RELATIVE sets up a view with the beamformer output
%   power plotted on the cortex surface, marked source locations and saves
%   the plot.
%
%   Data Options
%   ------------
%   cfg.head        
%       head model cfg (see hm_get_data)
%   cfg.datafiles
%       array of file names
%
%   View Options
%   ------------
%   cfg.sample
%       (optional) sample idx to plot
%
%   Data Set
%   --------
%   cfg.data_set with the following fields
%   sim_name    simulation config name
%   source_name source config name
%   snr         snr
%   iteration   simulation iteration
%
%     Example:
%     cfg.data_set.sim_name = 'sim_data_bem_1_100t';
%     cfg.data_set.source_name = 'mult_cort_src_10';
%     cfg.data_set.snr = 0;
%     cfg.data_set.iteration = '1';

%% Power map 3D - relative scale
scale = 'relative';

% TODO Specify time, get from plot_save_paper

cfgplt = [];
cfgplt.head = cfg.head;
cfgplt.options.scale = scale;
if isfield(cfg,'sample')
    cfgplt.options.sample = cfg.sample;
end
for i=1:length(cfg.datafiles)
    % Plot the data
    cfgplt.file = cfg.datafiles{i};
%     plot_beampattern3d(cfgplt);
    plot_power3d(cfgplt);
    
    % Plot source markers
    plot_sources3d(cfgplt);
    % FIXME will probably need to fix this
    
    % Save the plot
    cfg.plot_func = 'plot_power3d';
    cfg.plot_cfg = cfgplt;
    plot_save(cfg);
end
close all

end