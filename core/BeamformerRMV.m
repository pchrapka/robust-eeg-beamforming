classdef BeamformerRMV < Beamformer
    
    properties
        epsilon;
        solver;
        eigenspace;
        n_interfering_sources; % number of interfereing sources
    end
    
    methods
        function obj = BeamformerRMV(varargin)
            p = inputParser();
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
            
            % setup the name
            if p.Results.aniso
                % setup anisotropic rmv
                name = 'rmv aniso';
                if obj.n_interfering_sources > 0
                    obj.name = sprintf('%s %s %d',...
                        name,...
                        obj.eigenspace,...
                        obj.n_interfering_sources);
                else
                    obj.name = name;
                end
            else
                % setup isotropic rmv
                name = 'rmv';
                if obj.n_interfering_sources > 0
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