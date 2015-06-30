function [outfile] = plot_save_filename(cfg)
%PLOT_SAVE_FILENAME creates a filename for the plot configuration
%   PLOT_SAVE_FILENAME(CFG) creates a filename for the plot configuration.
%   The directory and file name format is standardized in
%   GET_PLOT_SAVE_TEMPLATE
%   
%   Plot info
%   ---------
%   cfg.plot_func
%       name of plotting function
%   cfg.plot_cfg
%       config used for plotting function
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
%
%   See also GET_PLOT_SAVE_TEMPLATE, PLOT_SAVE

% Get the image directory
cfg.file_type = 'img';
temp = metrics.filename(cfg);
[imgdir,~,~] = fileparts(temp);

% Set up the file name
imgfile = get_plot_save_template(cfg.plot_func, cfg.plot_cfg);

% Save the plot
switch (cfg.plot_func)
    case {'plot_beampattern3d','plot_power3d'}
        outfile = fullfile(imgdir,[imgfile '.png']);
        
    otherwise
        outfile = fullfile(imgdir, imgfile);
        
end

end