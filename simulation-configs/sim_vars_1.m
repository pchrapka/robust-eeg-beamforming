%% sim_vars
% Simulation variations
sim_vars_name = mfilename; % Get current file name

k = 1;

%% Data files
data_param_file = 'sim_data_1';
source_param_file = 'mult_cort_src';
run_range = 1:1:10;
snr_range = -5;%-25:5:25;
sim_vars(k).name = 'in';
count = 1;
for i=1:length(snr_range)
    for j=1:length(run_range)
        sim_vars(k).values{count} = [...
            'output' filesep...
            data_param_file '_'...
            source_param_file '_'...
            num2str(snr_range(i)) '_'...
            num2str(run_range(j))...
            '.mat'];
        count = count + 1;
    end
end
k = k+1;

%% Simulation parameters
% Beamformer locations
% Beamformer types
% Beamformer parameters

% Beamformer locations
sim_vars(k).name = 'loc';
sim_vars(k).values = num2cell(1:501);
k = k+1;

% % Beamformer types
% sim_vars(k).name = 'types';
% sim_vars(k).values = {'rmv','lcmv','lcmv_eig','lcmv_reg'};
% k = k+1;

% Beamformer parameters
sim_vars(k).name = 'epsilon';
sim_vars(k).values = {80,300};
k = k+1;