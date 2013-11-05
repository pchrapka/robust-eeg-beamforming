function cfg = get_config(cfg_id, data)
%GET_CONFIG returns a beamformer config
%   GET_CONFIG(CFG_ID, DATA) returns a beamformer config specified by
%   CFG_ID. 
%   
%   NOTE New beamformers need to be added here explicity.
switch cfg_id
    case 'rmv_epsilon_50'
        epsilon = 50;
        cfg = get_rmv_config(epsilon);
    case 'rmv_epsilon_100'
        epsilon = 100;
        cfg = get_rmv_config(epsilon);
    case 'rmv_epsilon_150'
        epsilon = 150;
        cfg = get_rmv_config(epsilon);        
    case 'rmv_epsilon_200'
        epsilon = 200;
        cfg = get_rmv_config(epsilon);        
    case 'rmv_epsilon_250'
        epsilon = 250;
        cfg = get_rmv_config(epsilon);                
    case 'rmv_epsilon_300'
        epsilon = 300;
        cfg = get_rmv_config(epsilon);                
    case 'rmv_epsilon_350'
        epsilon = 350;
        cfg = get_rmv_config(epsilon);        
    case 'rmv_epsilon_400'
        epsilon = 400;
        cfg = get_rmv_config(epsilon);        
    case 'lcmv'
        cfg = get_lcmv_config();
    case 'lcmv_reg_eig'
        type = 'eig';
        multiplier = 0.005;
        cfg = get_lcmv_reg_config(type, multiplier, data.R);
    case 'lcmv_eig_1'
        n_interfering_sources = 1;
        cfg = get_lcmv_eig_config(n_interfering_sources);        
    case 'lcmv_eig_2'
        n_interfering_sources = 2;
        cfg = get_lcmv_eig_config(n_interfering_sources);
    case 'lcmv_eig_3'
        n_interfering_sources = 3;
        cfg = get_lcmv_eig_config(n_interfering_sources);        
    otherwise
        error('beamformer_configs:get_config',...
            'unknown beamformer config');
end

% FIXME Set cfg.loc = cfg.loc;
end

function cfg = get_rmv_config(epsilon)
% Sets up an rmv config
cfg = [];
cfg.solver = 'yalmip';
cfg.verbosity = 0;
cfg.type = 'rmv';
cfg.name = ...
    ['rmv \epsilon ' num2str(epsilon)];
cfg.epsilon = ones(3,1)*sqrt(epsilon^2/3);
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
cfg.name = ['lcmv regularized: ' type];

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
cfg.name = ['lcmv eigenspace: ' num2str(n_interfering_sources)];
cfg.n_interfering_sources = n_interfering_sources;
end