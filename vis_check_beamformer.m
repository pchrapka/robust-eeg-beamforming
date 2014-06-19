data = load(...
    ['output/sim_data_bem_100_100t/'...
    'single_cort_src_1/0_3_lcmv_mini.mat']);
bf_out = data.source.beamformer_output;
bf_power = squeeze(sqrt(mean(bf_out.^2)));
surf(bf_power);
xlim([-10 1000]);
view(0,0);
