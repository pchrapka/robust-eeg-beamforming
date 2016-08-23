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
    cfg_par.ncores = 10;
    aet_parallel_init(cfg_par);
end

%% Set up different metrics to calculate
% Mult source results with 1 iteration

source_names = {...
    'mult_cort_src_10',...
    'mult_cort_src_17',...
    'mult_cort_src_sine_2',...
    'mult_cort_src_sine_2_uncor',...
    'mult_cort_src_complex_1_dip_pos_freq',...
    };
    

snrs = -20:10:0;
location_idx = 1:501;
% Loop through source names
for j=1:length(source_names)
    results = [];
    
    % Loop through snrs
    for i=1:length(snrs)
        snr = snrs(i);
        
        cfg = [];
        
        % Set up metrics
        cfg.source_name = source_names{j};
        cfg.snr = snr;
        k = 1;
        for m=1:length(location_idx)
            cfg.metrics(k).name = 'snr';
            cfg.metrics(k).location_idx = location_idx(m);
            k = k + 1;
            
            cfg.metrics(k).name = 'inr';
            cfg.metrics(k).location_idx = location_idx(m);
            k = k + 1;
        end
        for m=1:length(location_idx)
            cfg.metrics(k).name = 'sinr';
            cfg.metrics(k).location_idx = location_idx(m);
            cfg.metrics(k).flip = false;
            k = k + 1;
        end
        cfg.metrics(k).name = 'sinr';
        cfg.metrics(k).location_idx = 400;
        cfg.metrics(k).flip = true;
        k = k + 1;
        cfg.metrics(k).name = 'rmse';
        cfg.metrics(k).location_idx = 295;
        k = k + 1;
        cfg.metrics(k).name = 'rmse';
        cfg.metrics(k).location_idx = 400;
        k = k + 1;
        
%         % Mismatched locations, for matched head model scenario
%         % RMVB should be robust if you are looking at a mismatched grid
%         % location even if you know the head model
%         % NOTE Analysis makes most sense for matched head model
%         cfg.metrics(k).name = 'sinr';
%         cfg.metrics(k).location_idx = 313;
%         cfg.metrics(k).flip = false;
%         k = k + 1;
%         cfg.metrics(k).name = 'sinr';
%         cfg.metrics(k).location_idx = 338;
%         cfg.metrics(k).flip = false;
%         k = k + 1;
%         cfg.metrics(k).name = 'sinr';
%         cfg.metrics(k).location_idx = 372;
%         cfg.metrics(k).flip = false;
%         k = k + 1;
%         cfg.metrics(k).name = 'sinr';
%         cfg.metrics(k).location_idx = 341;
%         cfg.metrics(k).flip = false;
%         k = k + 1;
%         cfg.metrics(k).name = 'sinr';
%         cfg.metrics(k).location_idx = 365;
%         cfg.metrics(k).flip = false;
%         k = k + 1;
        
        % Calculate the metrics
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