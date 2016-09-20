classdef SimDataSetEEG
    
    properties (SetAccess = protected)
        sim;
        source;
        snr;
        iter;
    end
    
    methods
        function obj = SimDataSetEEG(sim,source,snr,varargin)
            p = inputParser();
            addRequired(p,'sim',@(x) ~isempty(x) && ischar(x));
            addRequired(p,'source',@(x) ~isempty(x) && ischar(x));
            addRequired(p,'snr',@(x) ~isempty(x) && length(x) == 1);
            addParameter(p,'iter',[],@(x) ~isempty(x) && length(x) == 1);
            parse(p,sim,source,snr,varargin{:});
            
            obj.sim = p.Results.sim;
            obj.source = p.Results.source;
            obj.snr = p.Results.snr;
            obj.iter = p.Results.iter;
        end
        
        function folder = get_dir(obj)
            folder = fullfile('output',obj.sim,obj.source);
        end
        
        function file_name = get_filename(obj,varargin)
            p = inputParser();
            addOptional(p,'tag','',@ischar);
            parse(p,varargin{:});
            if isempty(p.Results.tag)
                file_name = sprintf('%d_%d',obj.snr,obj.iter);
            else
                file_name = sprintf('%d_%d_%s',obj.snr,obj.iter,p.Results.tag);
            end
        end
        
        function out = get_full_filename(obj,varargin)
            p = inputParser();
            addOptional(p,'tag','',@ischar);
            parse(p,varargin{:});
            
            out = fullfile(obj.get_dir(),obj.get_filename(varargin{:}));
        end
    end
end