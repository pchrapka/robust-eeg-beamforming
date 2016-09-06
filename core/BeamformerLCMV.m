classdef BeamformerLCMV < Beamformer
    
    properties
        n_interfering_sources; % number of interfereing sources
        eigenspace;         % eigenspace flag
        lambda;             % scaling for regularization
        regularization;     % regularization method
        multiplier;         % multiplier for regularization method
    end
    
    methods
        function obj = BeamformerLCMV(varargin)
            %BeamformerLCMV Linearly Constrained Minimum Variance
            %Beamformer object
            %   BeamformerLCMV('name',value,...) creates a BeamformerLCMV
            %   object
            %
            %   Parameters
            %   ----------
            %   verbosity (integer, default = 0)
            %       verbosity level
            %
            %   LCMV
            %   ----
            %   default beamformer, no additional parameters are required
            %
            %   Regularized LCMV Beamformer
            %   ---------------------------
            %
            %   regularization (string, default = 'none')
            %       selects the type of diagonal loading regularization,
            %       options: eig or none
            %       
            %       eig - adds the identity scaled by the smallest
            %       eigenvalue of the covariance matrix
            %
            %   multiplier  (double, default = 0.005)
            %       multiplier for eigenvalue determined when
            %       regularization = 'eig'
            %
            %   Eigenspace LCMV Beamformer
            %   --------------------------
            %   eigenspace (logical, default = false)
            %       selects eigenspace beamformer
            %   ninterference (integer, default = 0)
            %       number of interfering sources
            
            p = inputParser();
            if ~verLessThan('matlab','8.5.0')
                p.PartialMatching = false;
            end
            addParameter(p,'multiplier',0.005,@isnumeric);
            addParameter(p,'regularization','none',...
                @(x) any(validatestring(x,{'eig','none'})));
            addParameter(p,'ninterference',0,@isnumeric);
            addParameter(p,'eigenspace',false,@islogical);
            addParameter(p,'verbosity',0,@isnumeric);
            p.parse(varargin{:});
            
            % FIXME consider splitting this up into 3 classes, parameters
            % would be more straightforward
            
            %obj = obj@Beamformer();
            obj.n_interfering_sources = p.Results.ninterference;
            obj.eigenspace = p.Results.eigenspace;
            obj.multiplier = p.Results.multiplier;
            obj.regularization = p.Results.regularization;
            obj.verbosity = 0;
            obj.lambda = 0;
            
            if obj.n_interfering_sources > 0 && ~obj.eigenspace
                error([mfilename ':' mfilename],...
                    'did you forget ''eigenspace'',true as parameters?');
            end
            
            if obj.eigenspace
                % eig
                obj.type = 'lcmv_eig';
                obj.name = sprintf('lcmv eig %d',...
                    obj.n_interfering_sources);
                
                obj.regularization = 'none';
                
            elseif ~isequal(obj.regularization,'none')
                % regularized
                obj.type = 'lcmv_reg';
                obj.name = sprintf('lcmv reg %s',...
                    obj.regularization);
            else
                % vanilla
                obj.type = 'lcmv';
                obj.name = 'lcmv';
            end
            
        end
        
        function data = inverse(obj, H, R) %
            %
            %   Output
            %   ------
            %   data.opt_time	beamforming duration
            %       opt_status 	optimization status, relevant for robust beamformers
            %       idx         location index
            %       variance    variance otrace(transpose(W)*R*W))
            %       W           weight matrix [channels x 3]
            %       H           leadfield matrix [channels x 3]
            
            % FIXME
            % Start timer
            opt_start = tic;

            switch obj.type
                case 'lcmv'
                    % Linearly constrained minimum variance beamformer
                    
                    % Set up cfg
                    cfg_lcmv = [];
                    cfg_lcmv.H = H;
                    cfg_lcmv.R = R;
                    
                    % Run beamformer
                    data_out = aet_analysis_lcmv(cfg_lcmv);
                    
                case 'lcmv_eig'
                    % Eigenspace based LCMV beamformer
                    
                    % Set up cfg
                    cfg_lcmv = [];
                    cfg_lcmv.H = H;
                    cfg_lcmv.R = R;
                    cfg_lcmv.n_interfering_sources = ...
                        cfg.n_interfering_sources;
                    
                    % Run beamformer
                    data_out = aet_analysis_lcmv_eig(cfg_lcmv);
                    
                case 'lcmv_reg'
                    % Regularized LCMV beamformer
                    % aka Diagonal loading
                    
                    % Set up lambda
                    % FIXME change to OOP and param list
                    lambda_cfg = [];
                    lambda_cfg.R = R;
                    lambda_cfg.type = obj.regularization;
                    lambda_cfg.multiplier = obj.multiplier;
                    obj.lambda = aet_analysis_beamform_get_lambda(lambda_cfg);
                    
                    % New code
                    % obj = obj.set_lambda(R);
                    
                    % Set up cfg
                    cfg_lcmv = [];
                    cfg_lcmv.H = H;
                    cfg_lcmv.R = R + cfg.lambda*eye(size(R));
                    
                    % Run beamformer
                    data_out = aet_analysis_lcmv(cfg_lcmv);
                otherwise
                    error('unknown beamformer type');
            end
            
            % Save paramters
            % End timer
            data.opt_time = toc(opt_start);
            data.opt_status = data_out.status;
            %data.loc = cfg.loc; % REMOVE?
            
            % Save parameters
            data.W = data_out.W;
            data.H = H;
        end
    end
    
%     methods (Access = protected)
%         function obj = set_lambda(obj, R)
%             % FIXME 
%             % aet_analysis_beamform_get_lambda
%             % obj.lambda = ;
%         end
%     end
    
end