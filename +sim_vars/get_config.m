function params = get_config(cfg_id, cfg_data, force)
%GET_CONFIG returns a config of simulation variables
%   GET_CONFIG(CFG_ID) returns a config of simulation variables specified
%   by CFG_ID.
%   
%   cfg_id      id for simulation parameters config
%   cfg_data    cfg describing data files to use during the simulation
%               see sim_vars.get_data_files
%   force       adds a flag that forces the analysis to be redone,
%               overwriting the existing output files
%   
%   NOTE New configs need to be added here explicity.

switch cfg_id
    case 'sim_vars_test'
        k = 1;
        
        params(k).name = 'data_file';
        params(k).values = sim_vars.get_data_files(cfg_data);
        k = k+1;
        
        % Head model
        head_cfg.type = 'brainstorm';
        head_cfg.file = 'head_Default1_500V.mat';
        params(k).name = 'head_cfg';
        params(k).values = {head_cfg};
        k = k+1;
        
        % Beamformer locations
        params(k).name = 'loc';
        params(k).values = {1:2};
        k = k+1;
        
        % Beamformer configs
        params(k).name = 'beamformer_config';
        params(k).values = {...
            'lcmv','lcmv_eig_2','lcmv_reg_eig'};
        k = k+1;
        
    case 'sim_vars_lcmv'
        k = 1;
        
        params(k).name = 'data_file';
        params(k).values = sim_vars.get_data_files(cfg_data);
        k = k+1;
        
        % Head model
        head_cfg.type = 'brainstorm';
        head_cfg.file = 'head_Default1_500V.mat';
        params(k).name = 'head_cfg';
        params(k).values = {head_cfg};
        k = k+1;
        
        % Beamformer locations
        % All, hopefully this works by default
        params(k).name = 'loc';
        params(k).values = {1:501};
        k = k+1;
        
        % Beamformer configs
        params(k).name = 'beamformer_config';
        params(k).values = {...
            'lcmv',...
            'lcmv_eig_1','lcmv_eig_2','lcmv_eig_3',...
            'lcmv_reg_eig'};
        k = k+1;
        
    case 'sim_vars_rmv'
        k = 1;
        
        params(k).name = 'data_file';
        params(k).values = sim_vars.get_data_files(cfg_data);
        k = k+1;
        
        % Head model
        head_cfg.type = 'brainstorm';
        head_cfg.file = 'head_Default1_500V.mat';
        params(k).name = 'head_cfg';
        params(k).values = {head_cfg};
        k = k+1;
        
        % Beamformer locations
        % All, hopefully this works by default
        params(k).name = 'loc';
        params(k).values = {1:501};
        k = k+1;
        
        % Beamformer configs
        params(k).name = 'beamformer_config';
        params(k).values = {...
            'rmv_epsilon_50',...
            'rmv_epsilon_100',...
            'rmv_epsilon_150',...
            'rmv_epsilon_200',...
            'rmv_epsilon_250',...
            'rmv_epsilon_300',...
            'rmv_epsilon_350',...
            'rmv_epsilon_400'};
        k = k+1;        
        
    case 'sim_vars_rmv_coarse'
        k = 1;
        
        params(k).name = 'data_file';
        params(k).values = sim_vars.get_data_files(cfg_data);
        k = k+1;
        
        % Head model
        head_cfg.type = 'brainstorm';
        head_cfg.file = 'head_Default1_500V.mat';
        params(k).name = 'head_cfg';
        params(k).values = {head_cfg};
        k = k+1;
        
        % Beamformer locations
        % All, hopefully this works by default
        params(k).name = 'loc';
        params(k).values = {1:501};
        k = k+1;
        
        % Beamformer configs
        params(k).name = 'beamformer_config';
        params(k).values = {...
            'rmv_epsilon_50',...
            'rmv_epsilon_100',...
            'rmv_epsilon_200',...
            'rmv_epsilon_300',...
            'rmv_epsilon_400'};
        k = k+1; 
        
    case 'sim_vars_rmv_eig_coarse'
        k = 1;
        
        params(k).name = 'data_file';
        params(k).values = sim_vars.get_data_files(cfg_data);
        k = k+1;
        
        % Head model
        head_cfg.type = 'brainstorm';
        head_cfg.file = 'head_Default1_500V.mat';
        params(k).name = 'head_cfg';
        params(k).values = {head_cfg};
        k = k+1;
        
        % Beamformer locations
        % All, hopefully this works by default
        params(k).name = 'loc';
        params(k).values = {1:501};
        k = k+1;
        
        % Beamformer configs
        params(k).name = 'beamformer_config';
        params(k).values = {...
            'rmv_eig_1_epsilon_5',...
            'rmv_eig_1_epsilon_10',...
            'rmv_eig_1_epsilon_20',...
            'rmv_eig_1_epsilon_30',...
            'rmv_eig_1_epsilon_40'};
        k = k+1;         

    otherwise
        error('sim_vars:get_config',...
            'unknown sim_vars configuration');
        
end

if force
    params(k).name = 'force';
    params(k).values = {force};
    k = k+1;
end

end
