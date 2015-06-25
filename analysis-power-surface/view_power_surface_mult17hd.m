function cfg = view_power_surface_mult17hd(matched, snr)
%VIEW_POWER_SURFACE_MULTH17HD beamformer output power view for mult17hd
%   VIEW_POWER_SURFACE_MULTH17HD sets up a view with the beamformer output
%   power for mult17hd

% FIXME remove if no problems
% %% ==== FIRST SOURCE ==== %%
% voxel_idx = 5440;
% interference_idx = 13841;

%% Set up the config
cfg = [];
cfg.force = true;
% FIXME remove if no problems
% % Sample index for beampattern calculation
% cfg.voxel_idx = voxel_idx;
% if ~isempty(interference_idx)
%     cfg.interference_idx = interference_idx;
% end

% Set up simulation info
cfg.data_set.sim_name = 'sim_data_bemhd_1_100t';
cfg.data_set.source_name = 'mult_cort_src_17hd';
cfg.data_set.snr = snr;
cfg.data_set.iteration = '1';
if matched
    cfg.head.type = 'brainstorm';
    cfg.head.file = 'head_Default1_bem_15028V.mat';
else
    cfg.head.type = 'brainstorm';
    cfg.head.file = 'head_Default1_3sphere_15028V.mat';
end

%% Set up beamformer configs
if matched
    %% ==== MATCHED LEADFIELD ====
    % Set up beamformer data sets to process
    cfg.beam_cfgs = {...
        'rmv_epsilon_10',...
        'rmv_epsilon_20',...
        'rmv_epsilon_30',...
        'rmv_epsilon_40',...
        'rmv_epsilon_50',...
        'lcmv',...
        'lcmv_eig_1',...
        'lcmv_reg_eig'...
        };
else
    %% ==== MISMATCHED LEADFIELD ====
    % Set up beamformer data sets to process
    cfg.beam_cfgs = {...
        'rmv_epsilon_50_3sphere',...
        'rmv_epsilon_100_3sphere',...
        'rmv_epsilon_150_3sphere',...
        'rmv_epsilon_200_3sphere',...
        'rmv_aniso_3sphere',...
        'lcmv_3sphere',...
        'lcmv_eig_1_3sphere',...
        'lcmv_reg_eig_3sphere'};
end

%% Plot the data
cfg = view_power_surface_relative(cfg);

end