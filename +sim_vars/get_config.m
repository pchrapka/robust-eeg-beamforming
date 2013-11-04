function params = get_config(cfg_id, cfg_data)
%GET_CONFIG returns a config of simulation variables
%   GET_CONFIG(CFG_ID) returns a config of simulation variables specified
%   by CFG_ID.
%   
%   NOTE New configs need to be added here explicity.

switch cfg_id
    case 'sim_vars_test'
        k = 1;
        
        params(k).name = 'data_file';
        params(k).values = sim_vars.get_data_files(cfg_data);
        k = k+1;
        
        % Head model
        % Get the directory that contains this function
        if verLessThan('matlab', '7.14')
            [cur_dir,~,~,~] = fileparts(mfilename('fullpath'));
        else
            [cur_dir,~,~] = fileparts(mfilename('fullpath'));
        end
        head_model_file = fullfile(...
            cur_dir,'..','..','head-models',...
            'brainstorm','head_Default1_500V.mat');
        params(k).name = 'head_model_file';
        params(k).values = {head_model_file};
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
        % Get the directory that contains this function
        if verLessThan('matlab', '7.14')
            [cur_dir,~,~,~] = fileparts(mfilename('fullpath'));
        else
            [cur_dir,~,~] = fileparts(mfilename('fullpath'));
        end
        head_model_file = fullfile(...
            cur_dir,'..','..','head-models',...
            'brainstorm','head_Default1_500V.mat');
        params(k).name = 'head_model_file';
        params(k).values = {head_model_file};
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
        % Get the directory that contains this function
        if verLessThan('matlab', '7.14')
            [cur_dir,~,~,~] = fileparts(mfilename('fullpath'));
        else
            [cur_dir,~,~] = fileparts(mfilename('fullpath'));
        end
        head_model_file = fullfile(...
            cur_dir,'..','..','head-models',...
            'brainstorm','head_Default1_500V.mat');
        params(k).name = 'head_model_file';
        params(k).values = {head_model_file};
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

    otherwise
        error('sim_vars:get_config',...
            'unknown sim_vars configuration');
        
end

end
