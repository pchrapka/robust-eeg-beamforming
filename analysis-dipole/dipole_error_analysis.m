
aet_init();

%% Get the data
% Set up config to get the data file
snr = '0';

cfg_data = [];
cfg_data.beam_cfgs = {...
    ...Matched
    'rmv_epsilon_20',...
    'lcmv',...
    'lcmv_eig_0',...
    'lcmv_reg_eig',...
    ...Mismatched
    'lcmv_3sphere',...
    'lcmv_eig_0_3sphere',...
    'lcmv_reg_eig_3sphere',...
    'rmv_epsilon_150_3sphere',...
    'rmv_aniso_3sphere'};
cfg_data.sim_name = 'sim_data_bem_1_100t';
cfg_data.source_name = 'single_cort_src_1';
cfg_data.source_config = 'src_param_single_cortical_source_1';
cfg_data.snr = snr;
cfg_data.iteration = 1;

% Set data parameters
cfg_data.sample_idx = 120;
cfg_data.location_idx = 295;

%% Calculate the errors
cfg_out = util.dipole.dipole_error_bf_files(cfg_data);
disp(mfilename('fullpath'))
disp(pwd)

%% Create a csv file

% Set up the config using the cfg_out
cfg_out.sim_name = cfg_data.sim_name;
cfg_out.source_name = cfg_data.source_name;
cfg_out.snr = cfg_data.snr;
cfg_out.iteration = cfg_data.iteration;
cfg_out.tag = 'dipole_error_summary';

util.dipole.dipole_error_summarize_csv(cfg_out);