classdef BeamformerLCMV < Beamformer
    
    properties
        nsources_int; % number of interfereing sources
        lambda;
    end
    
    methods
        function obj = BeamformerLCMV(varargin)
            p = inputParser();
            addParameter(p,'multiplier',0.005,@isnumeric);
            addParameter(p,'regularization','none',...
                @(x) any(validatestring(x,{'eig','none'})));
            addParameter(p,'ninterference',0,@isnumeric);
            p.parse(varargin{:});
            
            %obj = obj@Beamformer();
            obj.nsources_int = 0;
            obj.verbosity = 0;
            obj.lambda = 0;
            
            if p.Results.ninterference > 0
                % eig
                obj.type = 'lcmv_eig';
                obj.name = sprintf('lcmv eig %d',...
                    p.Results.ninterference);
                
                obj.nsources_int = p.Results.ninterference;
                
            elseif ~isequal(p.Results.regularization,'none')
                % regularized
                obj.type = 'lcmv_reg';
                obj.name = sprintf('lcmv reg %s',...
                    p.Results.regularization);
            else
                % vanilla
                obj.type = 'lcmv';
                obj.name = 'lcmv';
            end
            
        end
        
        function data = inverse(obj, H, R)
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
                    lambda_cfg.type = p.Results.regularization;
                    lambda_cfg.multiplier = p.Results.multiplier;
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
            data.loc = cfg.loc;
            
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