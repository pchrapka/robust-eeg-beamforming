%% simulation_ex1_snr.m -- Example 1: Exactly known leadfield matrix
% Performs an analysis of the robust beamformer for an exactly known
% leadfield matrix with varying levels of SNR. It is also compared with the
% LCMV beamformer

function simulation_ex1_snr()

%% Load the simulation parameters
data_params_ex1

%% Load the head model
disp('Loading the head model');
head_model_data = ['..' filesep 'head-models' filesep sim_cfg.head_model_file];
load(head_model_data);

%% Varying simulation parameters
% Set range for SNR
sim_cfg.snr_range = -25:1:5; % in dB

%% Set up beamformer parameters
% Only need the beamformer for the source location
loc = sim_cfg.source_params{1}.source_index;
epsilon = 10;
k = 1;

% RMV_COMP
cfg(k).verbosity = 0;
cfg(k).type = 'rmv_comp';
cfg(k).name = 'rmv componentwise';
cfg(k).loc = loc;
cfg(k).epsilon = ones(3,1)*sqrt(epsilon^2/3);

% Set up the output struct
out(k).name = cfg(k).name;
out(k).y = zeros(length(sim_cfg.snr_range),sim_cfg.sim_params.n_runs);
out(k).ylabel = 'Output SINR (dB)';
out(k).x = zeros(length(sim_cfg.snr_range),sim_cfg.sim_params.n_runs);
out(k).xlabel = 'SNR (dB)';
k = k + 1;

% LCMV
cfg(k).verbosity = 0;
cfg(k).type = 'lcmv';
cfg(k).name = 'lcmv';
% Only need the beamformer for the source location
cfg(k).loc = loc;

% Set up the output struct
out(k).name = cfg(k).name;
out(k).y = zeros(length(sim_cfg.snr_range),sim_cfg.sim_params.n_runs);
out(k).ylabel = 'Output SINR (dB)';
out(k).x = zeros(length(sim_cfg.snr_range),sim_cfg.sim_params.n_runs);
out(k).xlabel = 'SNR (dB)';
k = k + 1;

%% Run simulation

for i=1:length(sim_cfg.snr_range)
    disp(['SNR: ' num2str(sim_cfg.snr_range(i))]);
    
    for j=1:sim_cfg.sim_params.n_runs
        % Create the file name
        % Load the data
        load();
        
        % Calculate the covariance
        R = cov(data.avg_trial');
        
        for k=1:length(cfg)
            % Run the beamformer
            cfg(k).R = R;
            cfg(k).head_model = head;
            beam_out = aet_analysis_beamform(cfg(k));
            
            % Calculate the output of the beamformer with different data
            W_tran = transpose(beam_out.W);
            signal = W_tran*data.avg_signal;
            interference = W_tran*data.avg_interference;
            noise = W_tran*data.avg_noise;
           
            % Save the data SNR
            out(k).x(i,j) = sim_cfg.snr_range(i);
            % Calculate the SINR
            out(k).y(i,j) = calc_sinr(signal, interference, noise);
        end
    end
end

%% Save the output data
sim_cfg.data_type = 'ex1_snr';
aet_save(sim_cfg, out);

% Required output
% SINR vs SNR - need to repeat simulation over different values of SNR
% SINR vs epsilon, SNR = -10dB, depending on results of first experiment
end