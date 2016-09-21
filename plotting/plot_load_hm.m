function hm = plot_load_hm(datafile)

%% Load the data
din = load(datafile);

%% Load the head model
% load beamformer data
dinbf = load(din.bf_file);

% get head model config
if isfield(dinbf.head_cfg,'actual')
    head_cfg = dinbf.head_cfg.actual;
else
    head_cfg = dinbf.head_cfg;
end

% load head model
hmfactory = HeadModel();
hm = hmfactory.createHeadModel(head_cfg.type,head_cfg.file);
hm.load();

end