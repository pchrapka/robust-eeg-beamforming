%% beampattern_mult_paper

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ==== FIRST SOURCE ==== %%
voxel_idx = 295;
interference_idx = 400;
snr = 0;

data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t',...
    'mult_cort_src_17',...
    snr,...
    'iter',1);

%% ==== MATCHED LEADFIELD ====
%% Set up the config
cfg = [];
% Sample index for beampattern calculation
cfg.voxel_idx = voxel_idx;
cfg.interference_idx = interference_idx;

% Set up beamformer data sets to process
cfg.beam_cfgs = {...
    'rmv_epsilon_20',...
    ...'rmv_epsilon_50',...
    ...'rmv_eig_post_0_epsilon_20',...
    ...'rmv_eig_post_0_epsilon_50',...
    'lcmv',...
    'lcmv_eig_1',...
    'lcmv_reg_eig'...
    }; 

% Set up simulation info
cfg.data_set = data_set;

%% Compute the beampattern
cfg = compute_beampattern(cfg);

%% Plot the beampattern

vobj = ViewSources(cfg.outputfile);
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
vobj.plot('beampattern',cfgplt);

cfgplt = [];
vobj.plot('beampattern3d',cfgplt);

%% ==== MISMATCHED LEADFIELD ====
%% Set up the config
cfg = [];
% Sample index for beampattern calculation
cfg.voxel_idx = voxel_idx;
cfg.interference_idx = interference_idx;

% Set up beamformer data sets to process
cfg.beam_cfgs = {...
    ...'rmv_epsilon_50_3sphere',...
    ...'rmv_epsilon_100_3sphere',...
    'rmv_epsilon_150_3sphere',...
    ...'rmv_epsilon_200_3sphere',...
    'rmv_aniso_3sphere',...
    ...'rmv_eig_post_0_epsilon_50_3sphere',...
    ...'rmv_eig_post_0_epsilon_100_3sphere',...
    ...'rmv_eig_post_0_epsilon_150_3sphere',...
    ...'rmv_eig_post_0_epsilon_200_3sphere',...
    ...'rmv_aniso_eig_0_3sphere',...
    'lcmv_3sphere',...
    'lcmv_eig_1_3sphere',...
    'lcmv_reg_eig_3sphere'};

% Set up simulation info
cfg.data_set = data_set;

%% Compute the beampattern
cfg = compute_beampattern(cfg);

%% Plot the beampattern
vobj = ViewSources(cfg.outputfile);
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
vobj.plot('beampattern',cfgplt);

cfgplt = [];
vobj.plot('beampattern3d',cfgplt);
% title(['Mult src index ' num2str(voxel_idx) ' mismatched']);