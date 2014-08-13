%% metric_analysis_iter1_mult_paper_all

%% Update AET, just in case
util.update_aet();

%% Initialize the Advanced EEG Toolbox
aet_init

% Set parallel for blade not my laptop
if ispc
    parallel = false;
else
    parallel = true;
end
if parallel
    cfg_par = [];
    aet_parallel_init(cfg_par);
end

%% Set up different metrics to calculate
% Mult source results with 1 iteration

source_names = {...
    'mult_cort_src_10',...
    'mult_cort_src_17',...
    'mult_cort_src_sine_2',...
    'mult_cort_src_complex_1_dip_pos_freq',...
    };
    

snrs = -20:10:0;
% Loop through source names
for j=1:length(source_names)
    results = [];
    
    % Loop through snrs
    for i=1:length(snrs)
        snr = snrs(i);
        
        cfg = [];
        cfg.source_name = source_names{j};
        cfg.snr = snr;
        k = 1;
        cfg.metrics(k).name = 'snr';
        cfg.metrics(k).location_idx = 295;
        k = k + 1;
        cfg.metrics(k).name = 'snr';
        cfg.metrics(k).location_idx = 400;
        k = k + 1;
        cfg.metrics(k).name = 'sinr';
        cfg.metrics(k).location_idx = 295;
        cfg.metrics(k).flip = false;
        k = k + 1;
        cfg.metrics(k).name = 'sinr';
        cfg.metrics(k).location_idx = 400;
        cfg.metrics(k).flip = true;
        out = metric_analysis_iter1_mult_paper(cfg);
        
        % Accumulate the results
        results = [results out];
        
    end
    
    cfg = [];
    cfg.source_name = source_names{j};
    metric_analysis_iter1_summary(cfg, results);
end

%% Close parallel execution
if parallel
    aet_parallel_close(cfg_par);
end