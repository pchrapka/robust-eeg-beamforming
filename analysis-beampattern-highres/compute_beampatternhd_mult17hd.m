function cfg = compute_beampatternhd_mult17hd(matched, snr)

%% ==== FIRST SOURCE ==== %%
voxel_idx = 5440;
interference_idx = 13841;

%% Set up the config
cfg = [];
cfg.force = true;
% Sample index for beampattern calculation
cfg.voxel_idx = voxel_idx;
if ~isempty(interference_idx)
    cfg.interference_idx = interference_idx;
end

% Set up simulation info
cfg.data_set = SimDataSetEEG(...
    'sim_data_bemhd_1_100t',...
    'mult_cort_src_17hd',...
    snr,...
    'iter',1);

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

%% Compute the beampattern
cfg = compute_beampattern(cfg);

end