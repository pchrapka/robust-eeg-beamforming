%% experiment_theory_snr

% source power levels, taken from SNR 0 dB average signal and noise
% var_signal = 0.0203; % not working
% var_noise = 0.0189;
% NOTE source power levels are before multiplication of leadfield
% source_name = 'src_param_single_cortical_source_sine_2';
source_name = 'src_param_single_cortical_source_sine_2_noise_white';

% snr = 0;
% snr = 5;
% snr = 10;
snr = 20;
verbosity = 0;
vertex = 295;

switch source_name
    case 'src_param_single_cortical_source_sine_2_noise_white'
        switch snr
            case 20
                var_signal = 2.87172e-06;
                var_noise = 0.00998912;
            otherwise
                error('check data for good variance levels');
        end
    case 'src_param_single_cortical_source_sine_2'
        switch snr
            case 20
                %new
                var_signal = 5.56764e-06;
                var_noise = 0.0189822;
            case 10
                %var_signal = 0.000143219;
                %var_noise = 0.0190328;
                %new
                var_signal = 5.51052e-07;
                var_noise = 0.0187427;
            case 0
                %var_signal = 1.42451e-05;
                %var_noise = 0.0189432;
                %new version
                var_signal = 5.56672e-08;
                var_noise = 0.0189264;
            otherwise
                var_signal = 0.0005;
                var_noise = 1;
        end
    otherwise
        error('add variance levels for new source');
end

fprintf('theory\n');
fprintf('-----------------\n');
theory_snr_type1(...
    'sim_data_bem_1_100t_1000s',...
    source_name,...
    vertex,...
    'VarSignal',var_signal,...
    'VarNoise',var_noise,...
    'verbosity',verbosity,...
    'CovType','theory');

fprintf('theory-signal\n');
fprintf('-----------------\n');
theory_snr_type1(...
    'sim_data_bem_1_100t_1000s',...
    source_name,...
    vertex,...
    'VarSignal',var_signal,...
    'VarNoise',var_noise,...
    'verbosity',verbosity,...
    'CovType','theory-signal');

fprintf('data\n');
fprintf('-----------------\n');
theory_snr_type1(...
    'sim_data_bem_1_100t_1000s',...
    source_name,...
    vertex,...
    'snr',snr,...
    'verbosity',verbosity,...
    'CovType','data');
