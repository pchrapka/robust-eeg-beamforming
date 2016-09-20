

%% Get the data
% Set up config to get the data file
snr = 0;

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

source_name = 'single_cort_src_1';
cfg_data.source_config = 'src_param_single_cortical_source_1';
% source_name = 'mult_cort_src_17';
% cfg_data.source_config = 'src_param_mult_cortical_source_17';

data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t',...
    source_name,...
    snr,...
    'iter',1);

cfg_data.data_set = data_set;

% Set data parameters
cfg_data.sample_idx = 120;
cfg_data.location_idx = 295;

%% Calculate the errors
cfg_out = util.dipole.dipole_error_bf_files(cfg_data);
disp(mfilename('fullpath'))
disp(pwd)

%% Create a csv file

% Set up the config using the cfg_out
cfg_out.data_set = data_set;
cfg_out.tag = '';

util.dipole.dipole_error_summarize_csv(cfg_out);