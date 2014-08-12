%% rms_analysis_iter1_mult_paper_all

%% Update AET, just in case
util.update_aet();

%% Initialize the Advanced EEG Toolbox
aet_init

cfg_par = [];
aet_parallel_init(cfg_par);

%% Set up different rms analysis 
% Mult source results with 1 iteration

%% mult_cort_src_10

snrs = -20:10:0;
for i=1:length(snrs)
    snr = snrs(i);
    cfg = [];
    cfg.source_name = 'mult_cort_src_10';
    cfg.snr = snr;
    cfg.location_idx = 295;
    rms_analysis_iter1_mult_paper(cfg);
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_10';
    cfg.snr = snr;
    cfg.location_idx = 400;
    rms_analysis_iter1_mult_paper(cfg);
    
    % Setup sample interval
    % sample_idxs = 105:135; %250*0.428:250*0.532;
    parfor sample_idx=105:135
        cfg = [];
        cfg.source_name = 'mult_cort_src_10';
        cfg.snr = snr;
        cfg.sample_idx = sample_idx;
        rms_analysis_iter1_mult_paper(cfg);
    end
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_10';
    cfg.snr = snr;
    rms_analysis_iter1_summary(cfg);
end


%% mult_cort_src_17

snrs = -20:10:0;
for i=1:length(snrs)
    snr = snrs(i);
    cfg = [];
    cfg.source_name = 'mult_cort_src_17';
    cfg.snr = snr;
    cfg.location_idx = 295;
    rms_analysis_iter1_mult_paper(cfg);
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_17';
    cfg.snr = snr;
    cfg.location_idx = 400;
    rms_analysis_iter1_mult_paper(cfg);
    
    % Setup sample interval
    % sample_idxs = 105:135; %250*0.428:250*0.532;
    parfor sample_idx=105:135
        cfg = [];
        cfg.source_name = 'mult_cort_src_17';
        cfg.snr = snr;
        cfg.sample_idx = sample_idx;
        rms_analysis_iter1_mult_paper(cfg);
    end
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_17';
    cfg.snr = snr;
    rms_analysis_iter1_summary(cfg);
end

%% mult_cort_src_sine_2

snrs = -20:10:0;
for i=1:length(snrs)
    snr = snrs(i);
    cfg = [];
    cfg.source_name = 'mult_cort_src_sine_2';
    cfg.snr = snr;
    cfg.location_idx = 295;
    rms_analysis_iter1_mult_paper(cfg);
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_sine_2';
    cfg.snr = snr;
    cfg.location_idx = 400;
    rms_analysis_iter1_mult_paper(cfg);
    
    % Setup sample interval
    % sample_idxs = 105:135; %250*0.428:250*0.532;
    parfor sample_idx=105:135
        cfg = [];
        cfg.source_name = 'mult_cort_src_sine_2';
        cfg.snr = snr;
        cfg.sample_idx = sample_idx;
        rms_analysis_iter1_mult_paper(cfg);
    end
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_sine_2';
    cfg.snr = snr;
    rms_analysis_iter1_summary(cfg);
end


%% mult_cort_src_complex_1_dip_pos_freq

snrs = -20:10:0;
for i=1:length(snrs)
    snr = snrs(i);
    cfg = [];
    cfg.source_name = 'mult_cort_src_complex_1_dip_pos_freq';
    cfg.snr = snr;
    cfg.location_idx = 295;
    rms_analysis_iter1_mult_paper(cfg);
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_complex_1_dip_pos_freq';
    cfg.snr = snr;
    cfg.location_idx = 400;
    rms_analysis_iter1_mult_paper(cfg);
    
    % Setup sample interval
    % sample_idxs = 105:135; %250*0.428:250*0.532;
    parfor sample_idx=105:135
        cfg = [];
        cfg.source_name = 'mult_cort_src_complex_1_dip_pos_freq';
        cfg.snr = snr;
        cfg.sample_idx = sample_idx;
        rms_analysis_iter1_mult_paper(cfg);
    end
    
    cfg = [];
    cfg.source_name = 'mult_cort_src_complex_1_dip_pos_freq';
    cfg.snr = snr;
    rms_analysis_iter1_summary(cfg);
end

%% Close parallel execution
aet_parallel_close(cfg_par);