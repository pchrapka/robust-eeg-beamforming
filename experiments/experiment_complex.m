close all;

%% Set up config to get the data file
snr = '0';

cfg = [];
cfg.sim_name = 'sim_data_bem_1_100t';
% cfg.source_name = 'single_cort_src_complex_1';
cfg.source_name = 'mult_cort_src_complex_1';
cfg.snr = snr;
cfg.iteration = 1;

% Get the file name
file_name = db.get_full_file_name(cfg);
% Add extension
file_name = strcat(file_name,'.mat');

%% Load the data
data_in = load(file_name);
signal = data_in.data.avg_dipole_signal;

%% Plot input signal components
% Choose a source index to plot
loc_idx = 295;
component_labels = {'x','y','z'};
figure;
n_comp = size(signal,1);
for j=1:n_comp
    % Plot each component separately
    subplot(n_comp,1,j);
    data = squeeze(signal(j,loc_idx,:));
    plot(data);
    if j==1
        % Add the title to the first plot
        title(strrep(cfg.source_name,'_',' '));
    end
    % Add component labels
    ylabel([component_labels{j} ' comp']);
end

%% Plot EEG
figure;
plot(data_in.data.avg_trials');
title('avg trials');

figure;
plot(data_in.data.avg_signal');
title('avg signal');

figure;
plot(data_in.data.avg_noise');
title('avg noise');