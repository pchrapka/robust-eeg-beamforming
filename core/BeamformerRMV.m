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
            %       random
            %
            %       random - generaters the uncertainty matrix with a
            %       random perturbation
            %
            %   var_percent (double, default = 0)
            %       sets variance for anisotropic RMVB when aniso_mode =
            %       'random'. the variance is specified as a percent, which
            %       will correspond to the percent of the norm of the
            %       leadfield matrix.
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
            addParameter(p,'aniso_mode','normal',@(x) any(validatestring(x,{'normal','random'})));
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
                            error('%s: missing variance for anisotropic random', mfilename);
                        end
                        name = sprintf('%s random varpct %0.2f',name,obj.aniso_var_pct);
                    case 'normal'
                        if abs(obj.aniso_var_pct) > 0
                            warning('%s: variance not needed for anisotropic normal', mfilename);
                        end 
                        obj.aniso_var_pct = 0;
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
            
            if idx > 0
                % Get the leadfield matrices at the current index
                H_actual = H_actual.get_leadfield(idx);
                
                H_estimate = H_estimate.get_leadfield(idx);
                % Continue with the function
            end
            
            if isobject(H_actual) && isobject(H_estimate)
                % load data
                H_actual.load();
                H_estimate.load();
                
                % Check if the head models are the same size
                if ~isequal(size(H_actual.data.GridLoc), size(H_estimate.data.GridLoc))
                    error('aet:aet_analysis_rmv_uncertainty',...
                        'head models should be the same size');
                end
                
                n = size(H_actual.data.GridLoc,1);
                % Allocate memory
                A = cell(n,1);
                for i=1:n
                    % Get the leadfield matrices at the current index
                    lf_actual = H_actual.get_leadfield(i);
                    lf_estimate = H_estimate.get_leadfield(i);
                    
                    % Calculate A based on the difference between the leadfield
                    % matrices
                    A{i,1} = obj.calculate_A(lf_actual, lf_estimate);
                end
            elseif isnumeric(H_actual) && isnumeric(H_estimate)
                
                % The inputs are leadfield matrices, so just copy them
                lf_actual = H_actual;
                lf_estimate = H_estimate;
                
                % Calculate A based on the difference between the leadfield matrices
                A = obj.calculate_A(lf_actual, lf_estimate);
            else
                error('aet:aet_analysis_rmv_uncertainty_create',...
                    'H_actual and H_estimate are not consistent');
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
        function A = calculate_A(obj, H_actual, H_estimate)
            %CALCULATE_A Calculates a set of 3 A matrices describing an ellipsoidal
            %uncertainty between the components of 2 leadfield matrices.
            %
            %This is a simple model of uncertainty so there are a few assumptions. The
            %ellipse is pointed along the vector describing the difference between the
            %components of the leadfield matrices and the length of that semi-axis is
            %the magnitude of the difference. All other semi-axes are half of that
            %length and point in orthogonal directions to the difference vector.
            
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
                        sigma = sqrt(obj.aniso_var_pct*norm(H_actual(:,i))/n);
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
                semi_axis_length = min([d_mag/10 20]); %min([1 d_mag/2]);
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