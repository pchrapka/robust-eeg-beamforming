function plot_save(cfg)
%PLOT_SAVE saves the current figure in a standardized format
%   PLOT_SAVE(CFG) saves the current figure to the output database. The
%   directory and file name format is standardized in
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
%   See also GET_PLOT_SAVE_TEMPLATE

% Get the image directory
cfg.file_type = 'img';
temp = metrics.filename(cfg);
[imgdir,~,~] = fileparts(temp);

% Set up the file name
imgfile = get_plot_save_template(cfg.plot_func, cfg.plot_cfg);

fprintf('Saving %s \n\tto %s\n', imgfile, imgdir);
% Save the plot
switch (cfg.plot_func)
    case {'plot_beampattern3d','plot_power3d'}
        % Set background to white
        set(gcf, 'Color', [1 1 1]);
        
        % Focus on figure (captures the contents the topmost figure)
        pause(0.1);
        drawnow;
        figure(gcf);
        drawnow;
        frameGfx = getscreen(gcf);
        img = frameGfx.cdata;
        % Save the image
        imwrite(img, fullfile(imgdir,[imgfile '.png']));
        
    otherwise
        cfgsave= [];
        cfgsave.out_dir = imgdir;
        cfgsave.file_name = imgfile;  
        lumberjack.save_figure(cfgsave);
        
end

end