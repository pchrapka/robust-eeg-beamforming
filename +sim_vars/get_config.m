function params = get_config(cfg)
%GET_CONFIG returns a config of simulation variables
%   GET_CONFIG(CFG) returns a config of simulation variables specified
%   by CFG.
%   
%   Input
%   cfg         struct with the following fields
%       id      id for simulation parameters config
%       data    cfg describing data files to use during the simulation
%               see sim_vars.get_data_files
%       force   adds a flag that forces the analysis to be redone,
%               overwriting the existing output files
%       head    (optional) head model config, default is
%               'head_Default1_3sphere_500V.mat'
%           type    'brainstorm' or 'fieldtrip'
%           file    head model file name in head-models project
%       tag     additional tag for the output file
%   
%   NOTE New configs need to be added here explicity.

k = 1;
if isfield(cfg, 'data')
    params(k).name = 'data_file';
    params(k).values = sim_vars.get_data_files(cfg.data);
    k = k+1;
else
    warning('sim_vars:get_config',...
        'no data files specified');
end 

% Head model
if ~isfield(cfg,'head')
    cfg.head.type = 'brainstorm';
    cfg.head.file = 'head_Default1_3sphere_500V.mat';
end
params(k).name = 'head_cfg';
params(k).values = {cfg.head};
k = k+1;

% Beamformer locations
params(k).name = 'loc';
params(k).values = {};
k = k+1;

% Beamformer configs
params(k).name = 'beamformer_config';
params(k).values = {};

switch cfg.id
    case 'sim_vars_test'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:2};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'lcmv'},{'lcmv','n_src',2},{'lcmv','reg','eig'}};
        
    case 'sim_vars_test_rmv_aniso'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:2};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','aniso',true},...
            {'rmv','aniso',true,'eig_type','eig post','n_src',1}};
        
    case 'sim_vars_test_mismatch'
       
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:2};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'lcmv'},{'lcmv','n_src',2},{'lcmv','reg','eig'}};
        
        % Mismatch covariance matrix
        idx = length(params) + 1;
        params(idx).name = 'perturb_config';
        params(idx).values = {...
            'perturb_1',...
            'perturb_2'};
        
    case 'sim_vars_lcmv_basic'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'lcmv'},...
            {'lcmv','reg','eig'}};
        
    case 'sim_vars_lcmv'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'lcmv'},...
            {'lcmv','n_src',1},...
            {'lcmv','n_src',2},...
            {'lcmv','n_src',3},...
            {'lcmv','reg','eig'}};
        
    case 'sim_vars_lcmv_mismatch'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'lcmv'},...
            {'lcmv','n_src',1},...
            {'lcmv','n_src',2},...
            {'lcmv','n_src',3},...
            {'lcmv','reg','eig'}};
        
        % Mismatch covariance matrix
        idx = length(params) + 1;
        params(idx).name = 'perturb_config';
        params(idx).values = {...
            'perturb_1',...
            'perturb_2'};   
        
    case 'sim_vars_rmv'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',50},...
            {'rmv','epsilon',100},...
            {'rmv','epsilon',150},...
            {'rmv','epsilon',200},...
            {'rmv','epsilon',250},...
            {'rmv','epsilon',300},...
            {'rmv','epsilon',350},...
            {'rmv','epsilon',400}};      
        
    case 'sim_vars_rmv_coarse'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',50},...
            {'rmv','epsilon',100},...
            {'rmv','epsilon',200},...
            {'rmv','epsilon',300},...
            {'rmv','epsilon',400}};
        
    case 'sim_vars_rmv_coarse_mismatch'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',50},...
            {'rmv','epsilon',100},...
            {'rmv','epsilon',200},...
            {'rmv','epsilon',300},...
            {'rmv','epsilon',400}};
        
        % Mismatch covariance matrix
        idx = length(params) + 1;
        params(idx).name = 'perturb_config';
        params(idx).values = {...
            'perturb_1',...
            'perturb_2'};      
        
    case 'sim_vars_rmv_eig_coarse'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',50},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',100},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',200},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',300},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',400}};
        
    case 'sim_vars_rmv_eig_coarse_mismatch'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',50},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',100},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',200},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',300},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',400}};
        
        % Mismatch covariance matrix
        idx = length(params) + 1;
        params(idx).name = 'perturb_config';
        params(idx).values = {...
            'perturb_1',...
            'perturb_2'};
        
    case 'sim_vars_rmv_eig_experiment'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',0.0001},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',0.001},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',0.01},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',0.1},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',1}};
        
    case 'sim_vars_single_src_paper_matched'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',20},...
            {'rmv','epsilon',50},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',20},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',50},...
            {'rmv','eig_type','eig pre','n_src',0,'epsilon',20},...
            {'rmv','eig_type','eig pre','n_src',0,'epsilon',50},...
            {'lcmv'},...
            {'lcmv','n_src',0},...
            {'lcmv','reg','eig'}};
        
    case 'sim_vars_single_src_paper_mismatched'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',50},...
            {'rmv','epsilon',100},...
            {'rmv','epsilon',150},...
            {'rmv','epsilon',200},...
            {'rmv','aniso',true},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',50},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',100},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',150},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',200},...
            {'rmv','aniso',true,'eig_type','eig post','n_src',0},...
            {'rmv','eig_type','eig pre','n_src',0,'epsilon',0.01},...
            {'rmv','eig_type','eig pre','n_src',0,'epsilon',0.1},...
            {'rmv','eig_type','eig pre','n_src',0,'epsilon',1},...
            {'rmv','eig_type','eig pre','n_src',0,'epsilon',10},...
            {'rmv','aniso',true,'eig_type','eig pre','n_src',0},...
            {'lcmv'},...
            {'lcmv','n_src',0},...
            {'lcmv','reg','eig'}};
        
    case 'sim_vars_mult_src_basic_matched'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'lcmv'},...
            {'rmv','epsilon',0.01},...
            {'rmv','epsilon',5}};
        
    case 'sim_vars_mult_src_basic_mismatched'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'lcmv'},...
            ...{'rmv','epsilon',0.01},...
            ...{'rmv','epsilon',5},...
            {'rmv','aniso',true}};
        
    case 'sim_vars_mult_src_paper_matched'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',20},...
            {'rmv','epsilon',50},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',20},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',50},...
            {'lcmv'},...
            {'lcmv','n_src',1},...
            {'lcmv','reg','eig'}};
        
    case 'sim_vars_mult_src_paper_mismatched'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',50},...
            {'rmv','epsilon',100},...
            {'rmv','epsilon',150},...
            {'rmv','epsilon',200},...
            {'rmv','aniso',true},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',50},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',100},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',150},...
            {'rmv','eig_type','eig post','n_src',1,'epsilon',200},...
            {'rmv','aniso',true,'eig_type','eig post','n_src',1},...
            {'lcmv'},...
            {'lcmv','n_src',1},...
            {'lcmv','reg','eig'}};        
        
    case 'sim_vars_distr_src_paper_matched'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',20},...
            {'rmv','epsilon',50},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',20},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',50},...
            {'lcmv'},...
            {'lcmv','n_src',0},...
            {'lcmv','reg','eig'}};
        
    case 'sim_vars_distr_src_paper_mismatched'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            {'rmv','epsilon',50},...
            {'rmv','epsilon',100},...
            {'rmv','epsilon',150},...
            {'rmv','epsilon',200},...
            {'rmv','aniso',true},...
            {'rmv','eig_type','eig post','n_src',0','epsilon',50},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',100},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',150},...
            {'rmv','eig_type','eig post','n_src',0,'epsilon',200},...
            {'rmv','aniso',true,'eig_type','eig post','n_src',0},...
            {'lcmv'},...
            {'lcmv','n_src',0},...
            {'lcmv','reg','eig'}};         

    otherwise
        error('sim_vars:get_config',...
            'unknown sim_vars configuration');
        
end

if cfg.force
    idx = length(params) + 1;
    params(idx).name = 'force';
    params(idx).values = {cfg.force};
end

if isfield(cfg, 'tag')
    idx = length(params) + 1;
    params(idx).name = 'tag';
    params(idx).values = {cfg.tag};
end

end
