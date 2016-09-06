classdef BeamformerRMV < Beamformer
    
    properties
        epsilon;        % isotropic error uncertainty
        solver;         % optimization solver
        eigenspace;     % eigenspace method
        n_interfering_sources; % number of interfereing sources
    end
    
    methods
        function obj = BeamformerRMV(varargin)
            %BeamformerRMV Robust Minimum Variance Beamformer object
            %   BeamformerRMV('name',value,...) creates a BeamformerRMV
            %   object
            %
            %   Parameters
            %   ----------
            %   verbosity (integer, default = 0)
            %       verbosity level
            %
            %   Isotropic RMVB
            %   --------------
            %   default beamformer
            %
            %   epsilon (double, default = 0)
            %       level of uncertainty in leadfield matrix, used to
            %       compute A = sqrt(epsilon^2/3) * I
            %
            %   Anisotropic RMVB
            %   ----------------
            %   aniso (logical, default = false)
            %       selects anisotropic RMVB
            %
            %   Eigenspace RMVB (anisotropic/isotropic)
            %   ---------------
            %   eigenspace (string, default = 'none')
            %       selects an eigenspace beamformer
            %       options: 'eig pre cov', 'eig pre leadfield', 'eig
            %       post', 'none'
            %
            %       FIXME explain each one
            %   ninterference (integer, default = 0)
            %       number of interfering sources for eigenspace beamformer
            
            p = inputParser();
            p.PartialMatching = false;
            addParameter(p,'epsilon',0,@isnumeric);
            addParameter(p,'aniso',false,@islogical);
            eig_options = {...
                'eig pre cov',...
                'eig pre leadfield',...
                'eig post',...
                'none'...
                };
            addParameter(p,'eig_type','none',...
                @(x) any(validatestring(x,eig_options)));
            addParameter(p,'ninterference',0,@isnumeric);
            addParameter(p,'verbosity',0,@isnumeric);
            p.parse(varargin{:});
            
            %obj = obj@Beamformer();
            
            % set values
            obj.type = 'rmv';
            obj.epsilon = p.Results.epsilon;
            obj.eigenspace = p.Results.eig_type;
            obj.n_interfering_sources = p.Results.ninterference;
            obj.solver = 'yalmip';
            obj.verbosity = p.Results.verbosity;
            
            if obj.n_interfering_sources > 0 && isequal(obj.eigenspace,'none')
                error([mfilename ':' mfilename],...
                    'did you forget the eigenspace parameter?');
            end
            
            % setup the name
            if p.Results.aniso
                % setup anisotropic rmv
                name = 'rmv aniso';
                if ~isequal(obj.eigenspace,'none')
                    obj.name = sprintf('%s %s %d',...
                        name,...
                        obj.eigenspace,...
                        obj.n_interfering_sources);
                else
                    obj.name = name;
                end
                obj.epsilon = 0;
            else
                % setup isotropic rmv
                name = 'rmv';
                if ~isequal(obj.eigenspace,'none')
                    % eig
                    obj.name = sprintf('%s %s %d epsilon %d',...
                        name,...
                        obj.eigenspace,...
                        obj.n_interfering_sources,...
                        obj.epsilon);
                else
                    % not eig
                    obj.name = sprintf('%s epsilon %d',...
                        name,...
                        obj.epsilon);
                end
            end
            
        end
        
        function A = create_uncertainty(obj, head_actual, head_estimate, idx)
            % FIXME
            A = aet_analysis_rmv_uncertainty_create(...
                head_actual, head_estimate, idx);
        end
        
        function data = inverse(obj, H, R, varargin)
            %
            %
            %   Output
            %   ------
            %   data.opt_time	beamforming duration
            %       opt_status 	optimization status, relevant for robust beamformers
            %       idx         location index
            %       variance    variance otrace(transpose(W)*R*W))
            %       W           weight matrix [channels x 3]
            %       H           leadfield matrix [channels x 3]
            
            p = inputParser();
            addParameter(p,'A',{},@iscell);
            %addParameter(p,'Afile','',@ischar);
            p.parse(varargin{:});
            
            % check uncertainty matrix
            if obj.epsilon > 0 && ~isempty(p.Results.A)
                error([mfilename ':aet_analysis_beamform'],...
                    'Use either isotropic or anisotropic');
            end
              
            % Set up cfg
            cfg_rmv = [];
            cfg_rmv.H = H;
            cfg_rmv.R = R;
            cfg_rmv.verbosity = obj.verbosity;
            cfg_rmv.solver = obj.solver;
            cfg_rmv.eigenspace = obj.eigenspace;
            cfg_rmv.n_interfering_sources = obj.n_interfering_sources;
            
            if obj.epsilon > 0
                % Set up A for isotropic
                nchannels = size(R,1);
                ndims = 3;
            
                epsilon_vec = ones(ndims,1)*sqrt(obj.epsilon^2/ndims);
                A = cell(ndims,1);
                for i=1:ndims
                    A{i} = epsilon_vec(i,1)*eye(nchannels);
                end
                
                % Copy the uncertainty matrix
                cfg_rmv.A = A;
            else
                % Copy the uncertainty matrix
                cfg_rmv.A = p.Results.A;
            end
            
            % Start timer
            opt_start = tic;
        
            % Run beamformer
            data_out = aet_analysis_rmv(cfg_rmv);
            
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
    
end