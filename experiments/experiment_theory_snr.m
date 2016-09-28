%% experiment_theory_snr

% source power levels, taken from SNR 0 dB average signal and noise
% var_signal = 0.0203; % not working
% var_noise = 0.0189;
% NOTE source power levels are before multiplication of leadfield

var_signal = 0.005;
var_noise = 1;

% snr = 0;
% snr = 5;
snr = 10;
vertex = 205;

theory_snr_type1(...
    'sim_data_bem_1_100t',...
    'src_param_single_cortical_source_sine_2',...
    snr,...
    vertex);