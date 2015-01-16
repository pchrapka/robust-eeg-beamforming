% Load the data
din = load('output/sim_data_bem_1_100t/mult_cort_src_10/0_1.mat');
% din = load('output/sim_data_bem_1_100t/mult_cort_src_17/0_1.mat');
% din = load('output/sim_data_bem_1_100t/mult_cort_src_complex_1_dip_pos_freq/0_1.mat');
% din = load('output/sim_data_bem_1_100t/mult_cort_src_sine_2/0_1.mat');
% din = load('output/sim_data_bem_1_100t/mult_cort_src_sine_2_uncor/0_1.mat');
% din = load('output/sim_data_bem_1_100t/mult_cort_src_sine_2_uncor/-10_1.mat');
% din = load('output/sim_data_bem_1_100t/mult_cort_src_sine_2_uncor/-20_1.mat');

% Extract the signal
signal = din.data.avg_dipole_signal;
% should be DIMS x LOCS x SAMPLES

% Calculate the norm of the signal
signal_norm = squeeze(sum(signal.^2,1));

% Find the non-zero locations
[locs, samples] = find(signal_norm > 0);

% Get the unique locations
locs_unique = unique(locs);

% Extract the actual sources
sources = signal_norm(locs_unique,:);

figure;
n_sources = length(locs_unique);
for i=1:n_sources
    subplot(n_sources,1,i);
    plot(sources(i,:));
end

maxlags = 0;
source_cor = xcorr(sources(1,:), sources(2,:), maxlags, 'coeff');
fprintf('source correlation: %f\n', source_cor);
