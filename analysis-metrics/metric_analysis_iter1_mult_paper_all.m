%% metrics_analysis_iter1_mult_paper_all

%% Update AET, just in case
util.update_aet();

%% Initialize the Advanced EEG Toolbox
aet_init

cfg_par = [];
aet_parallel_init(cfg_par);

%% Set up different metrics to calculate
% Mult source results with 1 iteration

%% mult_cort_src_10

snrs = -20:10:0;
for i=1:length(snrs)
    snr = snrs(i);
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_10';
    cfg.snr = snr;
    k = 1;
    cfg.metrics(k).name = 'snr';
    cfg.metrics(k).location_idx = 295;
    k = k + 1;
    cfg.metrics(k).name = 'snr';
    cfg.metrics(k).location_idx = 400;
    metric_analysis_iter1_mult_paper(cfg);
    
%     cfg = [];
%     cfg.source_name = 'mult_cort_src_10';
%     cfg.snr = snr;
%     rms_analysis_iter1_summary(cfg);
end


%% mult_cort_src_17

snrs = -20:10:0;
for i=1:length(snrs)
    snr = snrs(i);
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_17';
    cfg.snr = snr;
    k = 1;
    cfg.metrics(k).name = 'snr';
    cfg.metrics(k).location_idx = 295;
    k = k + 1;
    cfg.metrics(k).name = 'snr';
    cfg.metrics(k).location_idx = 400;
    metric_analysis_iter1_mult_paper(cfg);
    
%     cfg = [];
%     cfg.source_name = 'mult_cort_src_17';
%     cfg.snr = snr;
%     rms_analysis_iter1_summary(cfg);
end

%% mult_cort_src_sine_2

snrs = -20:10:0;
for i=1:length(snrs)
    snr = snrs(i);
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_sine_2';
    cfg.snr = snr;
    k = 1;
    cfg.metrics(k).name = 'snr';
    cfg.metrics(k).location_idx = 295;
    k = k + 1;
    cfg.metrics(k).name = 'snr';
    cfg.metrics(k).location_idx = 400;
    metric_analysis_iter1_mult_paper(cfg);
    
%     cfg = [];
%     cfg.source_name = 'mult_cort_src_sine_2';
%     cfg.snr = snr;
%     rms_analysis_iter1_summary(cfg);
end


%% mult_cort_src_complex_1_dip_pos_freq

snrs = -20:10:0;
for i=1:length(snrs)
    snr = snrs(i);
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_complex_1_dip_pos_freq';
    cfg.snr = snr;
    k = 1;
    cfg.metrics(k).name = 'snr';
    cfg.metrics(k).location_idx = 295;
    k = k + 1;
    cfg.metrics(k).name = 'snr';
    cfg.metrics(k).location_idx = 400;
    metric_analysis_iter1_mult_paper(cfg);
    
    
%     cfg = [];
%     cfg.source_name = 'mult_cort_src_complex_1_dip_pos_freq';
%     cfg.snr = snr;
%     rms_analysis_iter1_summary(cfg);
end

%% Close parallel execution
aet_parallel_close(cfg_par);