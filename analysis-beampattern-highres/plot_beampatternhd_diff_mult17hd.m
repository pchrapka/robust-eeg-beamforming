function plot_beampatternhd_diff_mult17hd(cfg)
%
%   cfg.beamcfga
%       filename of beampattern data A
%   cfg.beamcfgb
%       filename of beampattern data B

data_set = SimDataSetEEG(...
    'sim_data_bemhd_1_100t','mult_cort_src_17hd',0,'iter',1);

cfgsave = [];
cfgsave.data_set = data_set;
cfgsave.file_type = 'metrics';
cfgsave.file_tag = sprintf('%s_beampattern',cfg.beamcfga);
filea = metrics.filename(cfgsave);

cfgsave.file_tag = sprintf('%s_beampattern',cfg.beamcfgb);
fileb = metrics.filename(cfgsave);

files = {filea, fileb};

%% beampattern
scale = 'globalabsolute';

% Plot separately
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.scale = scale;
if isequal(scale, 'globalabsolute') || isequal(scale, 'globalrelative')
    cfgplt.data_limit = get_beampattern_data_limit(files, scale);
end
for i=1:length(files)
    vobj = ViewSources(files{i});
    vobj.plot('beampattern',cfgplt);
end

%% beampattern_diff
% Plot difference
cfgplt = [];
cfgplt.diff_file = files{2};
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.scale = scale;
if isequal(scale, 'globalabsolute') || isequal(scale, 'globalrelative')
    cfgplt.data_limit = get_beampattern_data_limit(files, scale);
end
vobj = ViewSources(files{1});
vobj.plot('beampattern_diff',cfgplt);

%% beampattern3d
% Plot separately
cfgplt = [];
cfgplt.options.scale = scale;
if isequal(scale, 'globalabsolute') || isequal(scale, 'globalrelative')
    cfgplt.options.data_limit = get_beampattern_data_limit(files, scale);
end
for i=1:length(files)
    vobj = ViewSources(files{i});
    vobj.plot('beampattern3d',cfgplt);
end

%% beampattern3d_diff
scale = 'relative';

% Plot difference
cfgplt = [];
cfgplt.diff_file = files{2};
cfgplt.options.scale = scale;
if isequal(scale, 'globalabsolute') || isequal(scale, 'globalrelative')
    cfgplt.options.data_limit = get_beampattern_data_limit(files, scale);
end
vobj = ViewSources(files{1});
vobj.plot('beampattern3d_diff',cfgplt);

end