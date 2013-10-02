%% analysis_param_sweep.m

clc;
clear all;
close all;

% Create the directory if it doesn't exist
out_dir = 'output';
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

aet_init

%% sim_vars_1
% Gain vs distance from scr1
cd('..');
sim_data_1
src_param_mult_cortical_source
cd('analysis');

cfg.file_in{1} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv.mat'];
cfg.file_in{2} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv_eig.mat'];
cfg.file_in{3} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv_reg.mat'];
cfg.file_in{4} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_rmv.mat'];
cfg.file_out = 'sim_vars_1_gain_vs_distance_from_src1';
cfg.sim_cfg = sim_cfg;
cfg.loc = sim_cfg.sources{1}.source_index;
analysis_param_sweep_plot_gain(cfg);

% Gain vs distance from scr2
cd('..');
sim_data_1
src_param_mult_cortical_source
cd('analysis');

cfg.file_in{1} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv.mat'];
cfg.file_in{2} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv_eig.mat'];
cfg.file_in{3} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv_reg.mat'];
cfg.file_in{4} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_rmv.mat'];
cfg.file_out = 'sim_vars_1_gain_vs_distance_from_src2';
cfg.sim_cfg = sim_cfg;
cfg.loc = sim_cfg.sources{2}.source_index;
analysis_param_sweep_plot_gain(cfg);

% Gain using weights from exact leadfield vs distance from scr1
% NOTE I'm not exactly sure this makes sense
cd('..');
sim_data_1
src_param_mult_cortical_source
cd('analysis');

cfg.file_in{1} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv.mat'];
cfg.file_in{2} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv_eig.mat'];
cfg.file_in{3} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv_reg.mat'];
cfg.file_in{4} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_rmv.mat'];
cfg.file_out = 'sim_vars_1_exact_gain_vs_distance';
cfg.sim_cfg = sim_cfg;
cfg.loc = sim_cfg.sources{1}.source_index;
analysis_param_sweep_plot_gain_exact(cfg);

% Gain using weights from mismatched leadfield vs distance from scr1
% NOTE I'm not exactly sure this makes sense
cd('..');
sim_data_1
src_param_mult_cortical_source
cd('analysis');

cfg.file_in{1} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv.mat'];
cfg.file_in{2} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv_eig.mat'];
cfg.file_in{3} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_lcmv_reg.mat'];
cfg.file_in{4} = ['..' filesep 'output' filesep ...
    'out_sim_vars_1_rmv.mat'];
cfg.file_out = 'sim_vars_1_mismatched_gain_vs_distance';
cfg.sim_cfg = sim_cfg;
cfg.loc = 218;
analysis_param_sweep_plot_gain_mismatch(cfg);