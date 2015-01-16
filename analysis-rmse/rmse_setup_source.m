function [cfg] = rmse_setup_source(source_name)
% Set up rmse config based on source name

% How to set the sample_idx for new sources
% din = load('output/sim_data_bem_1_100t/mult_cort_src_10/-20_1.mat');
% signal = squeeze(din.data.avg_dipole_signal(1,295,:))
% find(signal > 0)

cfg.name = 'rmse';

switch source_name
    case 'mult_cort_src_10'
        cfg.sample_idx = [104 139];
    case 'mult_cort_src_17'
        cfg.sample_idx = [102 136];
    case 'mult_cort_src_sine_2'
        cfg.sample_idx = [1 1000];
    case 'mult_cort_src_sine_2_uncor'
        cfg.sample_idx = [1 1000];
    case 'mult_cort_src_complex_1_dip_pos_freq'
        cfg.sample_idx = [1 1000];
    otherwise
        error(['reb:' mfilename],...
            'unknown source name %s\n', source_name);
        
end

end