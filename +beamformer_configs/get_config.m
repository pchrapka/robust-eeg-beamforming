function cfg = get_config(type, varargin)
%GET_CONFIG returns a beamformer config
%   GET_CONFIG(TYPE, VARARGIN) returns a beamformer config specified by
%   TYPE.
%
%   optional arguments can be specified as key-value pairs, 
%   i.e. 'epsilon',10
%
%   type = 'rmv'
%       NOTE use either epsilon or aniso
%       'epsilon'   value to use for epsilon
%                   gets converted to A = sqrt(epsilon^2/3) * I
%       'aniso'     (boolean) to use anisotropic uncertainty
%       'eig'       number of interfering sources
%       'data'      struct with a field 'R' containing the covariance
%                   matrix
%
%   type = 'lcmv'
%       'eig'       number of interfering sources
%       'reg'       type of regularization ('eig'), requires 'data'
%       'data'      struct with a field 'R' containing the covariance
%                   matrix

% Parse the inputs
optargs = length(varargin);
switch type
    % Parse rmv inputs
    case 'rmv'
        for i=1:2:optargs
            name = varargin{i};
            value = varargin{i+1};
            switch name
                case 'epsilon'
                    epsilon = value;
                case 'eig'
                    n_interfering_sources = value;
                case 'data'
                    data = value;
                case 'aniso'
                    aniso = value;
                otherwise
                    error('beamformer_configs:get_config',...
                        'unknown rmv option');
            end
        end
        
        n_channels = size(data.R,1);
        if exist('aniso','var') && aniso
            if exist('n_interfering_sources','var')
                cfg = get_rmv_aniso_eig_config(...
                    n_interfering_sources);
            else
                cfg = get_rmv_aniso_config();
            end
        elseif ~exist('n_interfering_sources','var')
            cfg = get_rmv_config(...
                epsilon, n_channels);
        else
            cfg = get_rmv_eig_config(...
                n_interfering_sources, epsilon, n_channels);
        end
        
    % Parse lcmv inputs
    case 'lcmv'
        for i=1:2:optargs
            name = varargin{i};
            value = varargin{i+1};
            switch name
                case 'reg'
                    reg_type = value;
                case 'eig'
                    n_interfering_sources = value;
                case 'data'
                    data = value;
                otherwise
                    error('beamformer_configs:get_config',...
                        'unknown rmv option');
            end
        end
        
        if exist('n_interfering_sources','var')
            cfg = get_lcmv_eig_config(n_interfering_sources);
        elseif exist('reg_type','var')
            multiplier = 0.005;
            cfg = get_lcmv_reg_config(reg_type, multiplier, data.R);
        else
            cfg = get_lcmv_config();
        end
        
    otherwise
        error('beamformer_configs:get_config',...
            'unknown beamformer config');
end

% FIXME Set cfg.loc = cfg.loc;
end

function cfg = get_rmv_aniso_config()
% Sets up an rmv config
cfg = [];
cfg.solver = 'yalmip';
cfg.verbosity = 0;
cfg.type = 'rmv';
cfg.name = 'rmv aniso';
cfg.A = {}; % Initialized later

end

function cfg = get_rmv_aniso_eig_config(n_interfering_sources)
% Sets up an rmv config
cfg = [];
cfg.solver = 'yalmip';
cfg.verbosity = 0;
cfg.type = 'rmv';
cfg.name = ['rmv aniso eig ' num2str(n_interfering_sources)];
cfg.A = {}; % Initialized later

end

function cfg = get_rmv_config(epsilon, n_channels)
% Sets up an rmv config
cfg = [];
cfg.solver = 'yalmip';
cfg.verbosity = 0;
cfg.type = 'rmv';
cfg.name = ...
    ['rmv epsilon ' num2str(epsilon)];

% Set up A
epsilon_vec = ones(3,1)*sqrt(epsilon^2/3);
cfg.A = cell(3,1);
for i=1:length(cfg.A)
    cfg.A{i} = epsilon_vec(i,1)*eye(n_channels);
end

end

function cfg = get_rmv_eig_config(n_interfering_sources, epsilon, n_channels)
% Sets up an rmv config
cfg = [];
cfg.solver = 'yalmip';
cfg.verbosity = 0;
cfg.type = 'rmv';
cfg.name = ...
    ['rmv eig ' num2str(n_interfering_sources)...
    ' epsilon ' num2str(epsilon)];

% Set up A
epsilon_vec = ones(3,1)*sqrt(epsilon^2/3);
cfg.A = cell(3,1);
for i=1:length(cfg.A)
    cfg.A{i} = epsilon_vec(i,1)*eye(n_channels);
end

cfg.eigenspace = true;
cfg.n_interfering_sources = n_interfering_sources;
end

function cfg = get_lcmv_config()
% Sets up an lcmv config
cfg = [];
cfg.verbosity = 0;
cfg.type = 'lcmv';
cfg.name = 'lcmv';
end

function cfg = get_lcmv_reg_config(type, multiplier, R)
% Sets up an lcmv_reg config
cfg = [];
cfg.verbosity = 0;
cfg.type = 'lcmv_reg';
cfg.name = ['lcmv reg ' type];

% Set up lambda
lambda_cfg.R = R;
lambda_cfg.type = type;
lambda_cfg.multiplier = multiplier;
cfg.lambda = aet_analysis_beamform_get_lambda(lambda_cfg);

% FIXME add different types of lambda calculations
% cfg.beam_cfg.lambda = 10*trace(cov(data.avg_noise'));
end

function cfg = get_lcmv_eig_config(n_interfering_sources)
% Sets up an lcmv_eig config
cfg = [];
cfg.verbosity = 0;
cfg.type = 'lcmv_eig';
cfg.name = ['lcmv eig ' num2str(n_interfering_sources)];
cfg.n_interfering_sources = n_interfering_sources;
end