%% experiment_theory_snr

% source power levels, taken from SNR 0 dB average signal and noise
% var_signal = 0.0203; % not working
% var_noise = 0.0189;
% NOTE source power levels are before multiplication of leadfield

% snr = 0;
% snr = 5;
snr = 10;
vertex = 295;

switch snr
    case 10
        var_signal = 0.000143219;
        var_noise = 0.0190328;
    otherwise
        var_signal = 0.0005;
        var_noise = 1;
end

fprintf('theory\n');
fprintf('-----------------\n');
theory_snr_type1(...
    'sim_data_bem_1_100t',...
    'src_param_single_cortical_source_sine_2',...
    vertex,...
    'VarSignal',var_signal,...
    'VarNoise',var_noise,...
    'verbosity',0,...
    'CovType','theory');

fprintf('data\n');
fprintf('-----------------\n');
theory_snr_type1(...
    'sim_data_bem_1_100t',...
    'src_param_single_cortical_source_sine_2',...
    vertex,...
    'snr',snr,...
    'CovType','data');