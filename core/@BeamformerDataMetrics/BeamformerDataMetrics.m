classdef BeamformerDataMetrics < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        % data names
        dataset;
        beamformer;
        metrics;
        
        % data file names
        bfdata_file = '';
        eegdata_file = '';
        
        % actual data
        eegdata = [];
        bfdata = [];
        metricsdata = {};

        eegdata_loaded = false;
        bfdata_loaded = false;
        metricsdata_loaded = false;
        metricsdata_modified = false;
    end
    
    methods
        function obj = BeamformerDataMetrics(dataset,beamformer,varargin)
            p = inputParser();
            addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
            addRequired(p,'beamformer',@(x) ~isempty(x) && ischar(x));
            parse(p,dataset,beamformer,varargin{:});
            
            obj.dataset = p.Results.data_set;
            obj.beamformer = p.Results.beamformer;
            obj.metrics = obj.get_filename();
            
            obj.eegdata_file = db.save_setup('data_set',obj.dataset);
            obj.bfdata_file = db.save_setup('data_set',obj.dataset,'tag',obj.beamformer);
            
        end
        
        function outputfile = get_filename(obj)
            %GET_FILENAME returns the metrics filename 
            
            % get the default
            outputfile = db.save_setup('data_set',obj.dataset,'tag',obj.beamformer);
            
            % get the data file dir
            [out_dir,name,ext] = fileparts(outputfile);
            out_dir = fullfile(out_dir,'metrics');
            
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
                        temp = load(obj.eegdata_file);
                        obj.eegdata = temp.data;
                        obj.eegdata_loaded = true;
                    end
                case 'bfdata'
                    if ~obj.bfdata_loaded
                        % Load bf data
                        obj.bfdata = load(obj.bfdata_file);
                        obj.bfdata_loaded = true;
                    end
                case 'metricsdata'
                    if ~obj.metricsdata_loaded
                        % Load metrics data
                        if exist(obj.metrics,'file')
                            temp = load(obj.metrics);
                            obj.metricsdata = temp.metrics;
                        else
                            obj.metricsdata = {};
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
                obj.metricsdata_modified = false;
            end
        end
        
        function [flag_exist,metric_idx] = exist_metric(obj,metric_config)
            
            flag_exist = false;
            metric_idx = 0;
            
            nmetrics = length(obj.metricsdata);
            for i=1:nmetrics
                % check for the metric name
                if isequal(obj.metricsdata{i}.name,metric_config.name)
                    % found a matching name
                    flag_exist = true;
                    metric_idx = i;
                    
                    fields = fieldnames(metric_config);
                    nfields = length(fields);
                    
                    % check if all the config fields are the same
                    for j=1:nfields
                        field = fields{j};
                        
                        % check if the field exists
                        if isfield(obj.metricsdata{i},field)
                            % check if the config is the same
                            if ~isequal(obj.metricsdata{i}.(field),metric_config.(field))
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
            obj.metricsdata{nmetrics+1} = output;
            obj.metricsdata_modified = true;
        end
        
        function remove_metric(obj, idx)
            %REMOVE_METRIC removes a metric
            
            obj.metricsdata{idx} = [];
            obj.metricsdata_modified = true;
        end
        
        function W = get_W(obj, location)
            %GET_W returns spatial filter from beamformer data
            % Extract W from beamformer data
            idx_w = obj.bfdata.source.loc == location;
            W = obj.bfdata.source.filter(:,idx_w);
            if length(size(W{1})) > 2
                if size(W{1},1) > 1
                    error('not implemented for mutliple time points');
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
        [output] = snr_beamformer_output(S,N,W,varargin);
        [output] = sinr_beamformer_output(S,I,N,W,varargin);
        [output] = snr_input(S,N,varargin);
        
        % Validation
        [result] = validate_signal_matrix(A)
        
        function output = zero_mean(signal)
            nsamples = size(signal,2);
            signal_mean = mean(signal,2);
            output = signal - repmat(signal_mean,1,nsamples);
        end
    end
    
end

