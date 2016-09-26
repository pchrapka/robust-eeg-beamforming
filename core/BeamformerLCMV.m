classdef BeamformerLCMV < Beamformer
    
    properties (SetAccess = protected)
        n_interfering_sources; % number of interfereing sources
        eig_type;           % eigenspace type
        lambda;             % scaling for regularization
        regularization;     % regularization method
        multiplier;         % multiplier for regularization method
        pinv;               % flag for using pinv
        
        P;  % projection matrix
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
            %   eigenspace (string, default = 'none')
            %       selects an eigenspace beamformer
            %       options: 'eig cov', 'eig filter', 'none'
            %
            %       FIXME explain each one
            %   ninterference (integer, default = 0)
            %       number of interfering sources
            
            p = inputParser();
            if ~verLessThan('matlab','8.5.0')
                p.PartialMatching = false;
            end
            addParameter(p,'multiplier',0.005,@isnumeric);
            addParameter(p,'regularization','none',...
                @(x) any(validatestring(x,{'eig','none'})));
            addParameter(p,'pinv',true,@islogical);
            addParameter(p,'ninterference',0,@isnumeric);
            eig_options = {...
                'eig cov',...
                'eig leadfield',...
                'eig filter',...
                'eig cov leadfield',...
                'none'...
                };
            addParameter(p,'eig_type','none',...
                @(x) any(validatestring(x,eig_options)));
            addParameter(p,'verbosity',0,@isnumeric);
            p.parse(varargin{:});
            
            % FIXME consider splitting this up into 3 classes, parameters
            % would be more straightforward
%             if ~isequal(p.Results.regularization,'none') && ~isequal(p.Results.eig_type,'none')
%                 error('cannot regularize and use eigenspace projection');
%             end
            
            %obj = obj@Beamformer();
            obj.pinv = p.Results.pinv;
            obj.n_interfering_sources = p.Results.ninterference;
            obj.eig_type = p.Results.eig_type;
            obj.multiplier = p.Results.multiplier;
            obj.regularization = p.Results.regularization;
            obj.verbosity = 0;
            obj.lambda = 0;
            obj.P = [];
            
            if obj.n_interfering_sources > 0 && isequal(obj.eig_type,'none')
                error([mfilename ':' mfilename],...
                    'did you forget the eig_type parameter?');
            end
            
            if obj.pinv
                name = 'lcmv';
            else
                name = 'lcmv inv';
            end
            
            if ~isequal(obj.eig_type,'none') && ~isequal(obj.regularization,'none')
                % both eig and regularized
                obj.type = sprintf('lcmv_eig_reg');
                obj.name = sprintf('%s %s %d reg %s',...
                    name,...
                    obj.eig_type,...
                    obj.n_interfering_sources,...
                    obj.regularization);
            
            elseif ~isequal(obj.eig_type,'none')
                % eig
                obj.type = sprintf('lcmv_eig');
                obj.name = sprintf('%s %s %d',...
                    name,...
                    obj.eig_type,...
                    obj.n_interfering_sources);
                
                obj.regularization = 'none';
                
            elseif ~isequal(obj.regularization,'none')
                % regularized
                obj.type = 'lcmv_reg';
                obj.name = sprintf('%s reg %s',...
                    name,...
                    obj.regularization);
            else
                % vanilla
                obj.type = 'lcmv';
                obj.name = name;
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
            
            % Start timer
            opt_start = tic;
            
            data_out = aet_analysis_lcmv_all(H,R,...
                'pinv',obj.pinv,...
                'eig_type',obj.eig_type,...
                'regularization',obj.regularization,...
                'multiplier',obj.multiplier,...
                'ninterference',obj.n_interfering_sources);
            
            % Save paramters
            % End timer
            data.opt_time = toc(opt_start);
            data.opt_status = data_out.status;
            %data.loc = cfg.loc; % REMOVE?
            
            % Save parameters
            data.P = data_out.P;
            data.W = data_out.W;
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
            
            switch obj.eig_type
                case 'none'
                    data = W'*signal;
                otherwise
                    if isempty(p.Results.P)
                        error('missing the projection matrix');
                    end
                    % project the signal data first
                    data = W'*p.Results.P*signal;
            end
            
        end
        
        function P = get_P(obj,R)
            %GET_P gets the projection matrix
            
            % FIXME need a better way of doing this, should get it out of
            % the inverse step
            % How could I reload it afterwards??
            
            if ~isequal(obj.eig_type,'none')
                tmpcfg = [];
                tmpcfg.R = R;
                tmpcfg.n_interfering_sources = obj.n_interfering_sources;
                P = aet_analysis_eig_projection(tmpcfg);
            else
                error('projection matrix does not apply for this beamformer');
            end
        end


    end
    
end