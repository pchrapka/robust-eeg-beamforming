%% experiment_avg_vs_cov

f = 10;
fs = 200;
step = 1/fs;
T = 1/f;
t = 0:step:T;
a = -1*cos(2*pi*f*t);

plot(t,a);

%%
aet_analysis_power(a)

nsamples = length(a);
a_zero = a - mean(a);
a_power = trace(a_zero*a_zero'/nsamples)
a_power = trace(a*a'/nsamples)
a_power = mean(a_zero.^2)
a_power = mean(a.^2)

b = sqrt(length(b)/length(a))*[a zeros(1,400)];
aet_analysis_power(b)

nsamples = length(b);
b_zero = b - mean(b);
b_power = trace(b_zero*b_zero'/nsamples)
b_power = trace(b*b'/nsamples)
b_power = mean(b_zero.^2)
b_power = mean(b.^2)

%% compare covariance eigenvalues
% data set 1: ensemble average data with SNR 10 dB
% data set 2: single trial data with SNR 10 dB

cfg = [];
cfg.sim_data = 'sim_data_bem_1_100t_5000s_keeptrials_snrpertrial';
cfg.sim_src_parameters = 'src_param_mult_cortical_source_17_lag40';
cfg.snr_range = 10;
cfg.parallel = false;
simulation_data(cfg);

dataset = {};

fprintf('\nmult17lag40 ensemble 5000s\n');
sim_file = 'sim_data_bem_1_100t_5000s';
source_file = 'mult_cort_src_17_lag40';
dataset{1} = SimDataSetEEG(sim_file,source_file,10,'iter',1);
check_eeg_svd(dataset{1}.get_full_filename(),'neig',10);

fprintf('\nmult17lag40 single 5000s\n');
sim_file = 'sim_data_bem_1_100t_5000s_keeptrials_snrpertrial';
source_file = 'mult_cort_src_17_lag40';
dataset{2} = SimDataSetEEG(sim_file,source_file,10,'iter',1);
check_eeg_svd(dataset{2}.get_full_filename(),'neig',10,'samples',1:5000,'R_type','Rtrial');

fprintf('\nmult17lag40 single 200s\n');
sim_file = 'sim_data_bem_1_1000t_200s_keeptrials_snrpertrial';
source_file = 'mult_cort_src_17_lag40';
dataset{3} = SimDataSetEEG(sim_file,source_file,10,'iter',1);
check_eeg_svd(dataset{3}.get_full_filename(),'neig',10,'samples',1:200);

fprintf('\nmult18lag40 single 200s\n');
sim_file = 'sim_data_bem_1_1000t_200s_keeptrials_snrpertrial';
source_file = 'mult_cort_src_18_lag40';
dataset{4} = SimDataSetEEG(sim_file,source_file,10,'iter',1);
check_eeg_svd(dataset{4}.get_full_filename(),'neig',10,'samples',1:200);