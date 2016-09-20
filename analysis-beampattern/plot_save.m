function [outfile] = plot_save(cfg)
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
%   cfg.force
%       overwrite existing image, default = false
%
%   Data Set
%   --------
%   cfg.data_set 
%       SimDataSetEEG object
%
%   See also GET_PLOT_SAVE_TEMPLATE, PLOT_SAVE_FILENAME

if ~isfield(cfg, 'force'),  cfg.force = false;  end;

% Set up the file name
outfile = plot_save_filename(cfg);

% Skip the save if the file exists
if exist(outfile, 'file') && ~cfg.force
    fprintf('Skipping %s\n', outfile);
    fprintf('\tAlready exists\n');
    return;
else
    fprintf('Saving %s\n', outfile);
end

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
        imwrite(img, outfile);
        
    otherwise
        [imgdir, imgfile,imgext] = fileparts(outfile);
        
        cfgsave= [];
        cfgsave.out_dir = imgdir;
        cfgsave.file_name = [imgfile imgext];  
        lumberjack.save_figure(cfgsave);
        
end

end