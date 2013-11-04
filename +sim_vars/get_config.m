function sim_vars = get_config(cfg_id, cfg_data)
%GET_CONFIG returns a sim_vars config
%   GET_CONFIG(CFG_ID) returns a sim_vars config specified by
%   CFG_ID. 
%   
%   NOTE New configs need to be added here explicity.

switch cfg_id
    case 'sim_vars_test'
        k = 1;
        
        sim_vars(k).name = 'data_file';
        sim_vars(k).values = get_data_files(cfg_data);
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
        sim_vars(k).name = 'head_model_file';
        sim_vars(k).values = {head_model_file};
        k = k+1;
        
        % Beamformer locations
        sim_vars(k).name = 'loc';
        sim_vars(k).values = {1:2};
        k = k+1;
        
        % Beamformer configs
        sim_vars(k).name = 'beamformer_config';
        sim_vars(k).values = {...
            'lcmv','lcmv_eig_2','lcmv_reg_eig'};
        k = k+1;
        
    case 'sim_vars_lcmv'
        k = 1;
        
        sim_vars(k).name = 'data_file';
        sim_vars(k).values = sim_vars.get_data_files(cfg_data);
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
        sim_vars(k).name = 'head_model_file';
        sim_vars(k).values = {head_model_file};
        k = k+1;
        
        % Beamformer locations
        % All, hopefully this works by default
        sim_vars(k).name = 'loc';
        sim_vars(k).values = {1:501};
        k = k+1;
        
        % Beamformer configs
        sim_vars(k).name = 'beamformer_config';
        sim_vars(k).values = {...
            'lcmv',...
            'lcmv_eig_1','lcmv_eig_2','lcmv_eig_3',...
            'lcmv_reg_eig'};
        k = k+1;
        
    case 'sim_vars_rmv'
        k = 1;
        
        sim_vars(k).name = 'data_file';
        sim_vars(k).values = sim_vars.get_data_files(cfg_data);
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
        sim_vars(k).name = 'head_model_file';
        sim_vars(k).values = {head_model_file};
        k = k+1;
        
        % Beamformer locations
        % All, hopefully this works by default
        sim_vars(k).name = 'loc';
        sim_vars(k).values = {1:501};
        k = k+1;
        
        % Beamformer configs
        sim_vars(k).name = 'beamformer_config';
        sim_vars(k).values = {...
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
