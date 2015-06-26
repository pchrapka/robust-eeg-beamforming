function cfg = compute_power_surface_lowres(source_name, matched, snr)
%COMPUTE_POWER_SURFACE_LOWRES computes beamformer output power for
%low-resolution results
%   COMPUTE_POWER_SURFACE_LOWRES computes beamformer output power for
%   low-resolution results

%% ==== FIRST SOURCE ==== %%
voxel_idx = 295;
interference_idx = [];
if ~isempty(strfind(source_name,'mult'))
    interference_idx = 400;
end

%% Set up the config
cfg = [];
cfg.force = false;
% Sample index for beampattern calculation
cfg.voxel_idx = voxel_idx;
if ~isempty(interference_idx)
    cfg.interference_idx = interference_idx;
end

% Set up simulation info
cfg.data_set.sim_name = 'sim_data_bem_1_100t';
cfg.data_set.source_name = source_name;
cfg.data_set.snr = snr;
cfg.data_set.iteration = '1';
if matched
    cfg.head.type = 'brainstorm';
    cfg.head.file = 'head_Default1_bem_500V.mat';
else
    cfg.head.type = 'brainstorm';
    cfg.head.file = 'head_Default1_3sphere_500V.mat';
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

%% Compute the beamformer output power
cfg = compute_power(cfg);

end