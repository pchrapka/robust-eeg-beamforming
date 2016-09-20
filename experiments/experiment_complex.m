close all;

%% Set up config to get the data file
snr = 0;

% source_name = 'single_cort_src_complex_1';
% source_name = 'mult_cort_src_complex_1';
% source_name = 'mult_cort_src_complex_2_pos_exact';
source_name = 'distr_cort_src_complex_1';
% source_name = 'distr_cort_src_2';

data_set = SimDataSetEEG(...
    'sim_data_bem_1_100t',...
    source_name,...
    snr,...
    'iter',1);

% Get the file name
file_name = data_set.get_full_filename();
% Add extension
file_name = strcat(file_name,'.mat');

%% Load the data
data_in = load(file_name);
signal = data_in.data.avg_dipole_signal;

figure;
surf(squeeze(signal(1,:,:)));
figure;
non_zero = sum(sum(abs(signal)),3) > 0;
fprintf('non-zero vertices: %d\n', sum(non_zero));
plot(non_zero);
title('non-zero vertices');
figure;
max_val = max(max(signal),[],3);
plot(max_val);
title('max value');


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
        title(strrep(source_name,'_',' '));
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

figure;
dipole_signal = squeeze(data_in.data.avg_dipole_signal(1,:,:));
plot(dipole_signal');
title('avg dipole signal');