classdef ViewSources < handle
    
    properties (SetAccess = protected)
        file;
        hm;
        plot_last;
        plot_last_cfg;
        data_set;
    end
    
    methods (Static,Access = protected)
        % plot routines
        plot_beampattern3d(headmodel, datafile, cfg);
        plot_beampattern3d_diff(headmodel, datafile, cfg);
        plot_beampattern(datafile, cfg);
        plot_beampattern_diff(datafile, cfg);
        plot_power3d(headmodel, datafile,cfg);
    end
    
    methods
        function obj = ViewSources(datafile)
            %VIEWSOURCES creates ViewSources object
            %   VIEWSOURCES creates ViewSources object
            
            p = inputParser();
            addRequired(p,'file',@ischar);
            parse(p,datafile);
            
            obj.file = p.Results.file;
            obj.data_set = [];
            obj.hm = [];
            obj.plot_last = '';
            obj.plot_last_cfg = [];
        end
        
        function plot(obj,type,cfg)
            %PLOT plots the source data
            %   PLOT plots the source data
            
            switch type
                case 'beampattern3d'
                    obj.load_headmodel();
                    ViewSources.plot_beampattern3d(obj.hm, obj.file, cfg);
                case 'beampattern3d_diff'
                    obj.load_headmodel();
                    ViewSources.plot_beampattern3d_diff(obj.hm, obj.file, cfg);
                case 'beampattern'
                    ViewSources.plot_beampattern(obj.file, cfg);
                case 'beampattern_diff'
                    ViewSources.plot_beampattern_diff(obj.file, cfg);
                case 'power3d'
                    obj.load_headmodel();
                    ViewSources.plot_power3d(obj.hm, obj.file,cfg);
                otherwise
                    error('unknown plot type: %s',type);
            end
            
            obj.plot_last = type;
            obj.plot_last_cfg = cfg;
        end
        
        function show_sources(obj,varargin)
            %SHOW_SOURCES shows sources on current plot
            %   SHOW_SOURCES shows sources on current plot
            
            obj.load_headmodel();
            
            if ~isempty(varargin)
                plot_sources3d(obj.hm, varargin{:});
            else
                plot_sources3d(obj.hm, 'file', obj.file);
            end
        end
        
        function load_data_set(obj)
            %LOAD_DATA_SET loads the data set object
            %   LOAD_DATA_SET loads the data set object
            
            if isempty(obj.data_set)
                % load the data
                din = load(obj.file);
                
                % copy the data set info
                obj.data_set = din.data.data_set;
            end
            
        end
            
        
        function load_headmodel(obj)
            %LOAD_HEADMODEL loads the head model
            %   LOAD_HEADMODEL loads the head model
            
            if isempty(obj.hm)
                % Load the data
                din = load(obj.file);
                
                % Load the head model
                % load beamformer data
                dinbf = load(din.data.bf_file);
                
                % get head model config
                if isfield(dinbf.source.head_cfg,'actual')
                    head_cfg = dinbf.source.head_cfg.actual;
                else
                    head_cfg = dinbf.source.head_cfg;
                end
                
                % load head model
                hmfactory = HeadModel();
                obj.hm = hmfactory.createHeadModel(head_cfg.type,head_cfg.file);
                obj.hm.load();
            end
        end
        
        function outfile = save(obj)
            %SAVE saves the current figure in a standardized format
            %   SAVE saves the current figure to the output database
            
            % Set up the file name
            outfile = obj.get_plot_filename();
            print_save(outfile);
            
            % Save the plot
            switch (obj.plot_last)
                case {'beampattern3d','power3d'}
                    
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
        
        function outfile = get_plot_filename(obj)
            %GET_PLOT_FILENAME creates a filename for the plot configuration
            %   GET_PLOT_FILENAME(CFG) creates a filename for the plot configuration
            
            obj.load_data_set();

            % Get the image directory
            cfg = [];
            cfg.data_set = obj.data_set;
            cfg.file_type = 'img';
            temp = metrics.filename(cfg);
            [imgdir,~,~] = fileparts(temp);
            
            % Set up the file name
            switch obj.plot_last
                case 'beampattern'
                    [~,name,~] = fileparts(obj.file);
                    imgfile = [name '_' obj.plot_last_cfg.scale];
                    
                case 'beampattern3d'
                    [~,name,~] = fileparts(obj.file);
                    imgfile = [name '3d_' obj.plot_last_cfg.options.scale];
                    
                case 'power3d'
                    [~,name,~] = fileparts(obj.file);
                    if isfield(obj.plot_last_cfg.options,'samples')
                        if length(obj.plot_last_cfg.options.samples) > 1
                            idx_start = min(obj.plot_last_cfg.options.samples);
                            idx_end = max(obj.plot_last_cfg.options.samples);
                            imgfile = sprintf('%s3d_s%ds%d',...
                                name, idx_start, idx_end);
                        else
                            imgfile = sprintf('%s3d_s%d',...
                                name, obj.plot_last_cfg.options.samples);
                        end
                    else
                        error('missing samples field');
                    end
                    
                otherwise
                    error(['reb:' mfilename],...
                        'unknown function plot_func %s', plot_func);
                    
            end
            
            % Save the plot
            switch obj.plot_last
                case {'beampattern3d','power3d'}
                    outfile = fullfile(imgdir,[imgfile '.png']);
                    
                otherwise
                    outfile = fullfile(imgdir, imgfile);
                    
            end
        end
    end
    
end