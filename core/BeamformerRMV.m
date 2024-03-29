classdef BeamformerRMV < Beamformer
    
    properties
        epsilon;        % isotropic error uncertainty
        solver;         % optimization solver
        eig_type;       % eigenspace method
        n_interfering_sources; % number of interfereing sources
        
        P;  % projection matrix
        
        aniso_mode;
        aniso;
        aniso_var_pct;
        aniso_radius;
        aniso_multiplier;
        aniso_c;
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
            %   aniso_mode (string, default = 'normal')
            %       select anisotropic RMVB mode, options include: normal,
            %       random, radius
            %
            %       normal - uses a specific definition of the uncertainty
            %       model. Optional parameter c.
            %       random - generaters the uncertainty matrix with a
            %       random perturbation. Requires var_percent parameter
            %       radius - generates the uncertainty matrix from the
            %       covariance computed from nearby points in the estimated
            %       head model. Requires radius parameter
            %
            %   multiplier (double, default = 0.1)
            %       Multiple of principle error component used to specify
            %       uncertainty matrix. Used when aniso_mode = 'normal'
            %
            %   c (double, default = 20)
            %       upper bound on uncertainty for normal aniso
            %
            %   var_percent (double, default = 0)
            %       sets variance for anisotropic RMVB when aniso_mode =
            %       'random'. the variance is specified as a percent, which
            %       will correspond to the percent of the norm of the
            %       leadfield matrix.
            %
            %   radius (integer, default = [])
            %       radius around point in mm
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
            if ~verLessThan('matlab','8.5.0')
                p.PartialMatching = false;
            end
            addParameter(p,'epsilon',0,@isnumeric);
            addParameter(p,'aniso',false,@islogical);
            options_aniso = {'normal','random','radius'};
            addParameter(p,'aniso_mode','normal',@(x) any(validatestring(x,options_aniso)));
            addParameter(p,'radius',[],@(x) isnumeric(x) && isscalar(x) && (x > 0));
            addParameter(p,'multiplier',0.1,@(x) isnumeric(x) && isscalar(x) && (x > 0) && (x <= 1));
            addParameter(p,'c',20,@(x) isnumeric(x) && isscalar(x) && (x > 0));
            addParameter(p,'var_percent',0,@(x) isnumeric(x) && (x >= 0));
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
            obj.aniso = p.Results.aniso;
            obj.aniso_mode = p.Results.aniso_mode;
            obj.aniso_var_pct = p.Results.var_percent;
            obj.aniso_radius = p.Results.radius;
            obj.aniso_multiplier = p.Results.multiplier;
            obj.aniso_c = p.Results.c;
            obj.epsilon = p.Results.epsilon;
            obj.eig_type = p.Results.eig_type;
            obj.n_interfering_sources = p.Results.ninterference;
            obj.solver = 'yalmip';
            obj.verbosity = p.Results.verbosity;
            obj.P = [];
            
            if obj.n_interfering_sources > 0 && isequal(obj.eig_type,'none')
                error([mfilename ':' mfilename],...
                    'did you forget the eig_type parameter?');
            end
            
            % setup the name
            if obj.aniso
                % setup anisotropic rmv
                name = 'rmv aniso';
                
                % check aniso_mode and aniso_var_pct
                switch obj.aniso_mode
                    case 'random'
                        if obj.aniso_var_pct == 0
                            error('%s: missing variance for anisotropic %s', mfilename, obj.aniso_mode);
                        end
                        if ~isempty(obj.aniso_radius)
                            warning('%s: radius not needed for anisotropic %s', mfilename, obj.aniso_mode);
                            obj.aniso_radius = [];
                        end
                        name = sprintf('%s random varpct %0.2f',name,obj.aniso_var_pct);
                        obj.aniso_radius = [];
                    case 'normal'
                        if abs(obj.aniso_var_pct) > 0
                            warning('%s: variance not needed for anisotropic %s', mfilename, obj.aniso_mode);
                            obj.aniso_var_pct = 0;
                        end 
                        if ~isempty(obj.aniso_radius)
                            warning('%s: radius not needed for anisotropic %s', mfilename, obj.aniso_mode);
                            obj.aniso_radius = [];
                        end
                        name = sprintf('%s mult %0.2f c %d',name,obj.aniso_multiplier,obj.aniso_c);
                    case 'radius'
                        if abs(obj.aniso_var_pct) > 0
                            warning('%s: variance not needed for anisotropic %s', mfilename, obj.aniso_mode);
                            obj.aniso_var_pct = 0;
                        end
                        name = sprintf('%s radius %d',name,obj.aniso_radius);
                        obj.aniso_var_pct = 0;
                    otherwise
                        error('%s: unknown aniso mode %s',mfilename,obj.aniso_mode);
                end
                
                % check eigenspace args
                if ~isequal(obj.eig_type,'none')
                    obj.name = sprintf('%s %s %d',...
                        name,...
                        obj.eig_type,...
                        obj.n_interfering_sources);
                else
                    obj.name = name;
                end
                
                obj.epsilon = 0;
            else
                % setup isotropic rmv
                name = 'rmv';
                if obj.epsilon == 0
                    error('%s: missing epsilon for isotropic RMVB', mfilename);
                end
                
                if ~isequal(obj.eig_type,'none')
                    % eig
                    obj.name = sprintf('%s %s %d epsilon %d',...
                        name,...
                        obj.eig_type,...
                        obj.n_interfering_sources,...
                        obj.epsilon);
                else
                    % not eig
                    obj.name = sprintf('%s epsilon %d',...
                        name,...
                        obj.epsilon);
                end
                
                obj.aniso_var_pct = 0;
            end
            
        end
        
        function A = create_uncertainty(obj, H_actual, H_estimate, idx)
            %CREATE_UNCERTAINTY Calculates the uncertainty ellipse
            %from two lead field matrices
            %   CREATE_UNCERTAINTY(H_ACTUAL, H_ESTIMATE, IDX) returns a
            %   matrix describing an ellipse of uncertainty between an actual and an
            %   estimated head model at the location specified by IDX.
            %
            %   This is a simple model of uncertainty so there are a few assumptions.
            %   The ellipse is pointed along the vector describing the difference
            %   between the components of the leadfield matrices and the length of that
            %   semi-axis is the magnitude of the difference. All other semi-axes are
            %   half of that length and point in orthogonal directions to the
            %   difference vector.
            %
            %   The matrix A is intended for use with aet_analysis_rmv.
            %
            %   Input
            %   H_actual    IHeadModel obj, see HeadModel
            %               or leadfield matrix [channels x 3]
            %   H_estimate  IHeadModel obj, see HeadModel
            %               or leadfield matrix [channels x 3]
            %
            %   Ouput
            %   Depends on the input
            %   For head models
            %   A   cell array {n_leadfields 1} where each cell contains a {3 x 1} cell
            %       array of matrices A_i [channels x channels]
            %   For single leadfield matrices
            %   A   {3 x 1} cell array of matrices A_i [channels x channels]
            %
            %   The output is the same as for a single leadfield matrix
            %
            %   See also AET_ANALYSIS_RMV
            
            p = inputParser();
            addRequired(p,'H_actual',@(x) isa(x,'IHeadModel') || ismatrix(x));
            addRequired(p,'H_estimate',@(x) isa(x,'IHeadModel') || ismatrix(x));
            addRequired(p,'idx',@(x) isnumeric(x) && isscalar(x) && (x > 0));
            parse(p,H_actual,H_estimate,idx);
            
            % Calculate A based on the difference between the leadfield matrices
            switch obj.aniso_mode
                case {'normal','random'}
                    % Get the leadfield matrices at the current index
                    % The inputs are leadfield matrices, so just copy them
                    lf_actual = H_actual.get_leadfield(idx);
                    lf_estimate = H_estimate.get_leadfield(idx);
                    A = obj.calculate_A_simple(lf_actual, lf_estimate);
                case 'radius'
                    A = obj.calculate_A_radius(H_estimate,idx);
                otherwise
                    error('%s: unknown aniso mode :%s',mfilename, obj.aniso_mode);
            end
        end
        
        function data = inverse(obj, H, R, varargin)
            %
            %   Input
            %   -----
            %   H (matrix)
            %       leadfield matrix
            %   R (matrix)
            %       covariance matrix
            %   A (matrix)
            %       uncertainty matrix for anisotropic RMVB
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
            
            if obj.aniso && isempty(p.Results.A);
                error('%s: missing uncertainty matrix A',mfilename);
            end
            
            if ~obj.aniso && ~ismepty(p.Results.A);
                warning('%s: ignoring uncertainty matrix A for non-anisotropic RMVB',mfilename);
            end
              
            % Set up cfg
            cfg_rmv = [];
            cfg_rmv.H = H;
            cfg_rmv.R = R;
            cfg_rmv.verbosity = obj.verbosity;
            cfg_rmv.solver = obj.solver;
            cfg_rmv.eigenspace = obj.eig_type;
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
                    %if isempty(p.Results.P)
                    %    error('missing the projection matrix');
                    %end
                    % project the signal data first
                    %data = W'*p.Results.P*signal;
                    data = W'*signal;
            end
            
        end
        
        function P = get_P(obj,R)
            %GET_P sets the projection matrix
            
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
    
    methods (Access = private)
        function A = calculate_A_radius(obj, HM_estimate, idx)
            
            Hest = HM_estimate.get_leadfield(idx);
            
            % Get size
            [n, comp] = size(Hest);
            
            % Initialize A
            A = cell(comp, 1);
            for j=1:comp
                A{j} = zeros(n,n);
            end
            
            % get all the indices within the radius
            [inds, ~] = HM_estimate.get_vertices(...
                'type','radius',...
                'radius',obj.aniso_radius/1000,...
                'center_idx',idx);
            % check if the center_idx itself is included in the results
            idx_temp = find(inds == idx, 1);
            if ~isempty(idx_temp)
                % remove it
                inds(idx_temp) = [];
            end
            
            for i=1:length(inds)
                H = HM_estimate.get_leadfield(inds(i));
                Hdiff = H - Hest;
                for j=1:comp
                    A{j} = A{j} + Hdiff(:,j)*(Hdiff(:,j)');
                end
            end
            
            % normalize by number of leadfields considered
            for j=1:comp
                A{j} = A{j}/length(inds);
            end
        end
        
        function A = calculate_A_simple(obj, H_actual, H_estimate)
            %CALCULATE_A_SIMPLE Calculates a set of 3 A matrices describing
            %an ellipsoidal uncertainty between the components of 2
            %leadfield matrices.
            %
            %This is a simple model of uncertainty so there are a few
            %assumptions. The ellipse is pointed along the vector
            %describing the difference between the components of the
            %leadfield matrices and the length of that semi-axis is the
            %magnitude of the difference. All other semi-axes are half of
            %that length and point in orthogonal directions to the
            %difference vector.
            
            if ~isequal(size(H_actual), size(H_estimate))
                error('aet:aet_analysis_rmv_uncertainty_create',...
                    'lead field matrices should be the same size');
            end
            
            % Get the size
            [n comp] = size(H_actual);
            
            % Initialize A
            A = cell(comp, 1);
            
            % Create each A{i}
            for i=1:comp
                % Initialize A{i}
                A{i} = zeros(n,n);
                
                % Get the current column from lead field matrices
                switch obj.aniso_mode
                    case 'normal'
                        h_actual = H_actual(:,i);
                    case 'random'
                        sigma = obj.aniso_var_pct*norm(H_actual(:,i))/sqrt(n);
                        h_actual = normrnd(H_actual(:,i), sigma);
                end
                
                h_estimate = H_estimate(:,i);
                
                % Calculate the difference, pointing towards the estimate
                d = h_estimate - h_actual;
                
                % Create an orthonormal basis from d
                x=d(:).'/norm(d);
                yz=null(x).';
                ortho_basis=[x;yz];  %The rows of this matrix are the axes
                
                % Set the size of the sphere to be the size of d
                d_mag = norm(d);
                
                % Create components of SVD, A = U*S*V'
                % NOTE: You can also do U*S = diag(d);
                % The other semi axes should be smaller since we know the exact
                % uncertainty. So we're going to make it really small
                semi_axis_length = min([obj.aniso_multiplier*d_mag obj.aniso_c]); %min([1 d_mag/2]);
                fprintf('%s: semi axis length %0.2f\n',mfilename,semi_axis_length);
                S = diag([d_mag ones(1,n-1)*semi_axis_length]);
                U = ortho_basis';
                V = eye(n);
                A{i} = U*S*V';
                
                % Create components of ED, A = Q*L*Q';
                % http://see.stanford.edu/materials/lsoeldsee263/15-symm.pdf
                % The other semi axes should be larger since they are probably more
                % uncertain than the one known uncertainty
                %     semi_axis_length = [d_mag ones(1,n-1)*d_mag*2];
                %     eig_values = 1./(semi_axis_length.^2);
                %     L = diag(eig_values);
                %     Q = ortho_basis';
                %
                %     A{i} = Q*L*Q';
                
            end
            
        end
    end
    
end