%% experiment_check_pinv

din = load('output/sim_data_test/mult_cort_src_3/0_1');
R = din.data.Rtime;


tmpcfg = [];
tmpcfg.R = R;
tmpcfg.n_interfering_sources = 3;
P = aet_analysis_eig_projection(tmpcfg);

check_pinv(P*R,3+1)