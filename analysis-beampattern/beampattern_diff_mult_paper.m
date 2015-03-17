%% beampattern_diff_mult_paper

% fileb = 'output/sim_data_bem_1_100t/mult_cort_src_17/metrics/0_1_rmv_epsilon_20_beampattern.mat'
% filea = 'output/sim_data_bem_1_100t/mult_cort_src_17/metrics/0_1_rmv_epsilon_50_beampattern.mat'
% 'output/sim_data_bem_1_100t/mult_cort_src_17/metrics/0_1_lcmv_beampattern.mat'
% 'output/sim_data_bem_1_100t/mult_cort_src_17/metrics/0_1_lcmv_eig_1_beampattern.mat'
% 'output/sim_data_bem_1_100t/mult_cort_src_17/metrics/0_1_lcmv_reg_eig_beampattern.mat'

hd = true;
if hd
    data_set = fullfile('sim_data_bemhd_1_100t','mult_cort_src_17hd');
    cfg.head.type = 'brainstorm';
    cfg.head.file = 'head_Default1_bem_15028V.mat';
else
    data_set = fullfile('sim_data_bem_1_100t','mult_cort_src_17');
    cfg.head.type = 'brainstorm';
    cfg.head.file = 'head_Default1_bem_500V.mat';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matched
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% RMVB epsilon 50 vs RMVB epsilon 20
% % FIXME rmv_espilon_50 doesn't exist
% filea = 'output/sim_data_bem_1_100t/mult_cort_src_17/metrics/0_1_rmv_epsilon_50_beampattern.mat';
% fileb = 'output/sim_data_bem_1_100t/mult_cort_src_17/metrics/0_1_rmv_epsilon_20_beampattern.mat';
% 
% cfgplt = [];
% cfgplt.filea = filea;
% cfgplot.fileb = fileb;
% cfgplt.head = cfg.head;
% plot_beampattern3d_diff(cfgplt);

%% RMVB epsilon 20 vs LCMV
filea = ['output/' data_set '/metrics/0_1_rmv_epsilon_20_beampattern.mat'];
fileb = ['output/' data_set '/metrics/0_1_lcmv_beampattern.mat'];

% Plot separately
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.files = {filea, fileb};
cfgplt.head = cfg.head;
plot_beampattern(cfgplt);

% Plot difference
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.filea = filea;
cfgplt.fileb = fileb;
cfgplt.head = cfg.head;
plot_beampattern_diff(cfgplt);

% Plot separately
cfgplt = [];
cfgplt.files = {filea, fileb};
cfgplt.head = cfg.head;
plot_beampattern3d(cfgplt);

% Plot difference
cfgplt = [];
cfgplt.filea = filea;
cfgplt.fileb = fileb;
cfgplt.head = cfg.head;
plot_beampattern3d_diff(cfgplt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mismatched
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% RMVB epsilon 150 vs LCMV
filea = ['output/' data_set '/metrics/0_1_rmv_epsilon_150_3sphere_beampattern.mat'];
fileb = ['output/' data_set '/metrics/0_1_lcmv_3sphere_beampattern.mat'];

% Plot separately
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.files = {filea, fileb};
cfgplt.head = cfg.head;
plot_beampattern(cfgplt);

% Plot difference
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.filea = filea;
cfgplt.fileb = fileb;
cfgplt.head = cfg.head;
plot_beampattern_diff(cfgplt);

% Plot separately
cfgplt = [];
cfgplt.files = {filea, fileb};
cfgplt.head = cfg.head;
plot_beampattern3d(cfgplt);

% Plot difference
cfgplt = [];
cfgplt.filea = filea;
cfgplt.fileb = fileb;
cfgplt.head = cfg.head;
plot_beampattern3d_diff(cfgplt);