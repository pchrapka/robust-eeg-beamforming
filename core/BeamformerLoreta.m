classdef BeamformerLoreta < Beamformer
    %BeamformerLoreta Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        %lambda; %regularization parameter
        multipler; % multiplier for regularization parameter
        regularization;
    end
    
    methods
        function obj = BeamformerLoreta(varargin)
            %BeamformerLoreta eLoreta Beamformer object
            %   BeamformerLoreta('name',value,...) creates a BeamformerLoreta
            %   object
            %
            %   Parameters
            %   ----------
            %   verbosity (integer, default = 0)
            %       verbosity level
            %   lambda (float, default = 0.05)
            %       regularization parameter
            
            p = inputParser();
            if ~verLessThan('matlab','8.5.0')
                p.PartialMatching = false;
            end
            addParameter(p,'multiplier',0.005,@isnumeric);
            addParameter(p,'regularization','none',...
                @(x) any(validatestring(x,{'eig','none'})));
            %addParameter(p,'lambda',0.05,@isnumeric);
            addParameter(p,'verbosity',0,@isnumeric);
            p.parse(varargin{:});
            
            %obj.lambda = p.Results.lambda;
            obj.multiplier = p.Results.multiplier;
            obj.regularization = p.Results.regularization;
            obj.verbosity = p.Results.verbosity;
            
            obj.type = 'eloreta';
            if isequal(obj.regularization,'none')
                obj.name = obj.type;
            else
                obj.name = sprintf('%s reg %s', obj.regularization);
                %obj.name = sprintf('%s reg %0.3f',obj.type,obj.lambda);
            end
        end
        
        function data = inverse(obj, H, R)
            %
            %   Input
            %   -----
            %   H (matrix)
            %       leadfield matrix
            %   R (matrix)
            %       covariance matrix
            %
            %   Output
            %   ------
            %   data.opt_time	beamforming duration
            %       opt_status 	optimization status, relevant for robust beamformers
            %       W           weight matrix [channels x 3]
            %       H           leadfield matrix [channels x 3]
            %       P           projection matrix
            
            % Start timer
            opt_start = tic;
            
            dims = size(H);
            H_temp = zeros([dims(1) 1 dims(2)]);
            for i=1:dims(2)
                H_temp(:,1,i) = H(:,i);
            end
            
            lambda_cfg = [];
            lambda_cfg.R = R;
            lambda_cfg.type = obj.regularization;
            lambda_cfg.multiplier = obj.multiplier;
            lambda = aet_analysis_beamform_get_lambda(lambda_cfg);
            
            W_temp = mkfilt_eloreta_v2(H_temp, lambda);
            W = squeeze(W_temp);
            
            % Save paramters
            % End timer
            data.opt_time = toc(opt_start);
            data.opt_status = 'Success';
            %data.loc = cfg.loc; % REMOVE?
            
            % Save parameters
            data.P = [];
            data.W = W;
            data.H = H;
        end
        
        function data = output(obj, W, signal, varargin )
            %OUTPUT compute beamformer output
            %   OUTPUT(obj, W, signal) compute beamformer output
            %
            %   Input
            %   -----
            %   signal (matrix)
            %       signal matrix [channels timepoints]
            %   W (matrix)
            %       spatial filter, [channels components], output of
            %       inverse()
            %
            %   Parameters
            %   ----------
            %   P (matrix)
            %       projection matrix [channels channels]
            %
            %   Output
            %   ------
            %   data            
            %       dipole moment over time [components timepoints]
            
            p = inputParser();
            addParameter(p,'P',[],@ismatrix);
            parse(p,varargin{:});
            
            data = W'*signal;
            
        end
    end
    
end

