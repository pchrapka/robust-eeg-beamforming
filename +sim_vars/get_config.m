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
%   
%   NOTE New configs need to be added here explicity.

k = 1;
params(k).name = 'data_file';
params(k).values = sim_vars.get_data_files(cfg.data);
k = k+1;

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
            'lcmv','lcmv_eig_2','lcmv_reg_eig'};
        
    case 'sim_vars_test_mismatch'
       
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:2};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'lcmv','lcmv_eig_2','lcmv_reg_eig'};
        
        % Mismatch covariance matrix
        idx = length(params) + 1;
        params(idx).name = 'mismatch_config';
        params(idx).values = {...
            'mismatch_1',...
            'mismatch_2'};
        
    case 'sim_vars_lcmv'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'lcmv',...
            'lcmv_eig_1','lcmv_eig_2','lcmv_eig_3',...
            'lcmv_reg_eig'};
        
    case 'sim_vars_lcmv_mismatch'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'lcmv',...
            'lcmv_eig_1','lcmv_eig_2','lcmv_eig_3',...
            'lcmv_reg_eig'};
        
        % Mismatch covariance matrix
        idx = length(params) + 1;
        params(idx).name = 'mismatch_config';
        params(idx).values = {...
            'mismatch_1',...
            'mismatch_2'};   
        
    case 'sim_vars_rmv'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'rmv_epsilon_50',...
            'rmv_epsilon_100',...
            'rmv_epsilon_150',...
            'rmv_epsilon_200',...
            'rmv_epsilon_250',...
            'rmv_epsilon_300',...
            'rmv_epsilon_350',...
            'rmv_epsilon_400'};      
        
    case 'sim_vars_rmv_coarse'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'rmv_epsilon_50',...
            'rmv_epsilon_100',...
            'rmv_epsilon_200',...
            'rmv_epsilon_300',...
            'rmv_epsilon_400'};
        
    case 'sim_vars_rmv_coarse_mismatch'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'rmv_epsilon_50',...
            'rmv_epsilon_100',...
            'rmv_epsilon_200',...
            'rmv_epsilon_300',...
            'rmv_epsilon_400'};
        
        % Mismatch covariance matrix
        idx = length(params) + 1;
        params(idx).name = 'mismatch_config';
        params(idx).values = {...
            'mismatch_1',...
            'mismatch_2'};      
        
    case 'sim_vars_rmv_eig_coarse'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'rmv_eig_1_epsilon_50',...
            'rmv_eig_1_epsilon_100',...
            'rmv_eig_1_epsilon_200',...
            'rmv_eig_1_epsilon_300',...
            'rmv_eig_1_epsilon_400'};
        
    case 'sim_vars_rmv_eig_coarse_mismatch'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'rmv_eig_1_epsilon_50',...
            'rmv_eig_1_epsilon_100',...
            'rmv_eig_1_epsilon_200',...
            'rmv_eig_1_epsilon_300',...
            'rmv_eig_1_epsilon_400'};
        
        % Mismatch covariance matrix
        idx = length(params) + 1;
        params(idx).name = 'mismatch_config';
        params(idx).values = {...
            'mismatch_1',...
            'mismatch_2'};
        
    case 'sim_vars_rmv_eig_experiment'
        
        % Beamformer locations
        idx = sim_vars.get_param_idx(params, 'loc');
        params(idx).values = {1:501};
        
        % Beamformer configs
        idx = sim_vars.get_param_idx(params, 'beamformer_config');
        params(idx).values = {...
            'rmv_eig_1_epsilon_0-0001',...
            'rmv_eig_1_epsilon_0-001',...
            'rmv_eig_1_epsilon_0-01',...
            'rmv_eig_1_epsilon_0-1',...
            'rmv_eig_1_epsilon_1'};      

    otherwise
        error('sim_vars:get_config',...
            'unknown sim_vars configuration');
        
end

if cfg.force
    idx = length(params) + 1;
    params(idx).name = 'force';
    params(idx).values = {cfg.force};
end

end
