function sim_vars = get_config(cfg_id)
%GET_CONFIG returns a sim_vars config
%   GET_CONFIG(CFG_ID) returns a sim_vars config specified by
%   CFG_ID. 
%   
%   NOTE New configs need to be added here explicity.

switch cfg_id
    case 'sim_vars_test'
        k = 1;
        
        % Data files
        cfg_data = [];
        cfg_data.data_name = 'sim_data_test';
        cfg_data.source_name = 'mult_cort_src_3';
        cfg_data.iteration_range = 1;
        cfg_data.snr_range = [-5 0 5 10];
        
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

    otherwise
        error('sim_vars:get_config',...
            'unknown sim_vars configuration');
        
end

end

function out = get_data_files(cfg)
% Returns data file based on cfg
% cfg
%   data_name
%   source_name
%   snr_range
%   iteration_range

count = 1;
for i=1:length(cfg.snr_range)
    for j=1:length(cfg.iteration_range)
        tmpcfg = [];
        tmpcfg.sim_name = cfg.data_name;
        tmpcfg.source_name = cfg.source_name;
        tmpcfg.snr = cfg.snr_range(i);
        tmpcfg.iteration = cfg.iteration_range(j);
        out{count} = db.get_full_file_name(tmpcfg);    
        count = count + 1;
    end
end
end