%% metric_analysis_common_paper_all

%% init parallel

% set up parallel execution
lumberjack.parfor_setup();


%% Set up metrics to calculate

% Load the head model
hmfactory = HeadModel();
hm = hmfactory.createHeadModel('brainstorm','head_Default1_bem_500V.mat');
hm.load();
head = hm.data;
% FIXME don't copy data

location_idx = 1:501;

cfg = [];
% Set up metrics
cfg.source_name = 'common';
cfg.snr = 0;
k = 1;
for m=1:length(location_idx)
    cfg.metrics(k).name = 'vdist';
    cfg.metrics(k).head = head;
    cfg.metrics(k).voi_idx = 295;
    cfg.metrics(k).location_idx = location_idx(m);
    k = k + 1;
    
    cfg.metrics(k).name = 'vdist';
    cfg.metrics(k).head = head;
    cfg.metrics(k).voi_idx = 400;
    cfg.metrics(k).location_idx = location_idx(m);
    k = k + 1;
end

% Calculate the metrics
results = metric_analysis_common_paper(cfg);

cfg = [];
cfg.source_name = 'common';
metric_analysis_common_summary(cfg, results);

% %% Close parallel execution
% if parallel
%     aet_parallel_close(cfg_par);
% end