function plot_beampattern_multhd_config_paper(sim_file,source_name,varargin)


p = inputParser();
addRequired(p,'sim_file',@ischar);
addRequired(p,'source_name',@ischar);
addParameter(p,'matched','both',@(x) any(validatestring(x,{'matched','mismatched','both'})));
addParameter(p,'snr',0,@isnumeric);
parse(p,sim_file,source_name,varargin{:});

%% Set up beamformer configs
params = [];
k = 1;

%% ==== MATCHED LEADFIELD ====
% Set up beamformer data sets to process
params(k).beam_cfgs = {...
    'rmv_epsilon_20',...
    'lcmv',...
    'lcmv_eig_cov_0',...
    'lcmv_eig_cov_1',...
    'lcmv_reg_eig'...
    };
params(k).matched = true;
k = k+1;

%% ==== MISMATCHED LEADFIELD ====
% Set up beamformer data sets to process
params(k).beam_cfgs = {...
    'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    'rmv_epsilon_175_3sphere',...
    'rmv_epsilon_200_3sphere',...
    'rmv_aniso_3sphere',...
    'rmv_aniso_eig_pre_cov_0_3sphere',...
    'rmv_aniso_eig_pre_cov_1_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_cov_0_3sphere',...
    'lcmv_eig_cov_1_3sphere',...
    'lcmv_reg_eig_3sphere',...
    };
params(k).matched = false;
k = k+1;

for i=1:length(params)
    
    source_idx = 5440;
    int_idx = 13841;
    
    % Set up simulation info
    data_set = SimDataSetEEG(...
        sim_file,...
        source_name,...
        p.Results.snr,...
        'iter',1);
    
    %% Compute beampatterns
    
    % Compute the beampattern
    outputfiles = compute_beampattern(...
        data_set,...
        params(i).beam_cfgs,...
        source_idx,...
        'int_idx',int_idx);
    
    %% Plot data
    
    scales = {...
        'relative',...
        'relative-dist',...
        ...'mad',...
        'globalabsolute'...
        'globalabsolute-dist'...
        };
    
%     for j=1:length(scales)
%         args = get_view_beampattern_args('default','beampattern',scales{j});
%         view_beampattern(outputfiles,'source_idx',source_idx,args{:});
%     end
    
    for j=1:length(scales)
        args = get_view_beampattern_args('default','beampattern3d',scales{j});
        view_beampattern(outputfiles,'source_idx',source_idx,'int_idx',int_idx,args{:});
    end
    
    params(i).outputfiles = outputfiles;
    
end

end

