%% Source 1
% Source signal params for pr_peak()
sim_cfg.sources{1}.type = 'signal';
sim_cfg.sources{1}.signal_type = 'erp';
sim_cfg.sources{1}.snr = -10; % in dB
sim_cfg.sources{1}.amp = 2;
sim_cfg.sources{1}.freq = 10;
sim_cfg.sources{1}.pos = 120;
sim_cfg.sources{1}.jitter = 5;

% Source dipole params
sim_cfg.sources{1}.moment = [1;0;0]; 
% This would represent just x direction

% Source head model params
% Index of brain source voxel
sim_cfg.sources{1}.source_index = 207;

%% Source 2
% Source signal params for pr_peak()
sim_cfg.sources{2} = sim_cfg.sources{1}; % Copy the first source
sim_cfg.sources{2}.type = 'interference';
sim_cfg.sources{2}.signal_type = 'erp';
sim_cfg.sources{2}.snr = 8; % in dB
sim_cfg.sources{2}.freq = 4;
sim_cfg.sources{2}.pos = 200;
sim_cfg.sources{2}.jitter = 5;

sim_cfg.sources{2}.moment = [0.5;0.5;1]/norm([0.5;0.5;1]); 

% Source head model params
% Index of brain source voxel
sim_cfg.sources{2}.source_index = 384;

%% Noise
sim_cfg.noise_power = 1;

%% NOTE This is a simple script to visualize the sources
% The full EEG data is still scaled appropriately to get the desired SNR
% with respect to the noise power

% Pseudocode
% 1. Create source signals and project them to the EEG sensor space using
% the leadfield matrix
% 2. Create noise, scale the noise so that the variance of the noise is
% equal to the desired noise power
% 3. Scale the two sources to get the desired SNR

for i=1:length(sim_cfg.sources)
    signal{i} = peak(1000, 1, 250,...
        sim_cfg.sources{i}.freq,...
        sim_cfg.sources{i}.pos,...
        sim_cfg.sources{i}.jitter);
end

figure;
subplot(2,1,1);
plot(signal{1});
subplot(2,1,2);
plot(signal{2});

% Check temporal correlation
cor = xcorr(signal{1}(:), signal{2}(:), 0, 'coeff');
disp(['Temporal correlation = ' num2str(cor)]);

% Check spatial correlation
% load('data_maryam.mat');
% xcorr2(data.avg_signal, data.avg_interference)
