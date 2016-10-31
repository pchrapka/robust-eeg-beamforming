classdef BeamformerDataMetrics < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % data names
        dataset;
        beamformer;
        metrics;
        
        % actual data
        eegdata = [];
        bfdata = [];
        metricsdata = [];
    end
    
    properties (SetAccess = protected)
        eegdata_loaded = false;
        bfdata_loaded = false;
        metricsdata_loaded = false;
        metricsdata_modified = false;
    end
    
    methods
        function obj = BeamformerDataMetrics(dataset,beamformer,varargin)
            p = inputParser();
            addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
            addRequired(p,'beamformer',@(x) ~isempty(x) && iscell(x));
            parse(p,dataset,beamformer,varargin{:});
            
            obj.dataset = p.Results.dataset;
            obj.beamformer = p.Results.beamformer;
            obj.metrics = obj.get_filename();
            
        end
        
        function outputfile = get_filename(obj)
            %GET_FILENAME returns the metrics filename 
            
            % get the default
            outputfile = db.save_setup('data_set',obj.dataset,'tag',obj.beamformer);
            
            % get the data file dir
            [out_dir,name,ext] = fileparts(outputfile);
            out_dir = fullfle(out_dir,'metrics');
            
            % create the dir
            if ~exist(out_dir, 'dir')
                mkdir(out_dir);
            end
            
            % put it together again
            outputfile = fullfile(out_dir, [name ext]);
        end
        
        [output] = run_metrics(obj,metrics,varargin);
    
    end
    
    methods (Access = protected)
        function load_data(obj,type)
            %LOAD_DATA loads data
            switch type
                case 'eegdata'
                    if ~obj.eegdata_loaded
                        % Load eeg data
                        eeg_data_file = db.save_setup('data_set',obj.dataset);
                        obj.eegdata = load(eeg_data_file);
                        obj.eegdata_loaded = true;
                    end
                case 'bfdata'
                    if ~obj.bfdata_loaded
                        % Load bf data
                        bf_data_file = db.save_setup('data_set',cfg.data_set,'tag',cfg.beam_cfg);
                        obj.bfdata = load(bf_data_file);
                        obj.bfdata_loaded = true;
                    end
                case 'metricsdata'
                    if ~obj.metricsdata_loaded
                        % Load metrics data
                        if exist(obj.metrics,'file')
                            temp = load(obj.metrics);
                            obj.metricsdata = temp.metrics;
                        else
                            obj.metricsdata = [];
                        end
                        obj.metricsdata_loaded = true;
                    end
                otherwise
                    error('unknown data type');
            end
        end
        
        function save(obj)
            if obj.metricsdata_loaded && obj.metricsdata_modified
                metrics = obj.metricsdata;
                save(obj.metrics, 'metrics');
            end
        end
        
        function [flag_exist,metric_idx] = exist_metric(obj,metric_config)
            
            flag_exist = false;
            metric_idx = 0;
            
            nmetrics = length(obj.metricsdata);
            for i=1:nmetrics
                if isequal(obj.metricsdata(i).name,metric_config.name)
                    flag_exist = true;
                    metric_idx = i;
                    fields = fieldnames(metric_config);
                    nfields = length(fields);
                    for j=1:nfields
                        field = fields{j};
                        % check if the field exists
                        if isfield(obj.metricsdata(i),field)
                            % check if the data is the same
                            if ~isequal(obj.metricsdata(i).(field),metric_config.(field))
                                % do something
                                flag_exist = false;
                                break;
                            end 
                        else
                            flag_exist = false;
                            break;
                        end
                    end
                end
            end
            
            if ~flag_exist
                metric_idx = 0;
            end
        end
        
        function add_metric(obj, output)
            %ADD_METRIC adds a metric
            
            nmetrics = length(obj.metricsdata);
            obj.metricsdata(nmetrics+1) = output;
            obj.metricsdata_modified = true;
        end
        
        function W = get_W(obj, location)
            %GET_W returns spatial filter from beamformer data
            % Extract W from beamformer data
            idx_w = obj.bfdata.source.loc == location;
            W = obj.bfdata.source.filter{idx_w};
            if length(size(W)) > 2
                if size(W,1) > 1
                    error('not implemented for mutliple time points');
                else
                    W = squeeze(W);
                end
            end
        end
        
        
        % Metric Functions
        [output] = metric_snr_beamformer_output(obj,varargin);
        [output] = metric_inr_beamformer_output(obj,varargin);
        [output] = metric_sinr_beamformer_output(obj,varargin);
        [output] = metric_isnr_beamformer_output(obj,varargin);
        [output] = metric_snr_input(obj,varargin);
        [output] = metric_inr_input(obj,varargin);
        [output] = metric_vertex_distances(obj,varargin)

    end
    
    methods (Static)
        % Helper metric functions
        [output] = snr_beamformer_output(S,N,W);
        [output] = sinr_beamformer_output(S,I,N,W);
        [output] = snr_input(S,N);
    end
    
end

