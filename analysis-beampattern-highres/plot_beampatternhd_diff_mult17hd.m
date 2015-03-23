function plot_beampatternhd_diff_mult17hd(cfg)
%
%   cfg.beamcfga
%       filename of beampattern data A
%   cfg.beamcfgb
%       filename of beampattern data B

data_set = fullfile('sim_data_bemhd_1_100t','mult_cort_src_17hd');
cfg.head.type = 'brainstorm';
cfg.head.file = 'head_Default1_bem_15028V.mat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matched
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% RMVB epsilon 20 vs LCMV
filea = ['output/' data_set '/metrics/0_1_' cfg.beamcfga '_beampattern.mat'];
fileb = ['output/' data_set '/metrics/0_1_' cfg.beamcfgb '_beampattern.mat'];
files = {filea, fileb};

scale = 'globalabsolute';

% Plot separately
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.head = cfg.head;
cfgplt.scale = scale;
if isequal(scale, 'globalabsolute') || isequal(scale, 'globalrelative')
    cfgplt.data_limit = get_beampattern_data_limit(files, scale);
end
for i=1:length(files)
    cfgplt.file = files{i};
    plot_beampattern(cfgplt);
end

% Plot difference
cfgplt = [];
cfgplt.db = false;
cfgplt.normalize = false;
cfgplt.filea = filea;
cfgplt.fileb = fileb;
cfgplt.head = cfg.head;
cfgplt.scale = scale;
if isequal(scale, 'globalabsolute') || isequal(scale, 'globalrelative')
    cfgplt.data_limit = get_beampattern_data_limit(files, scale);
end
plot_beampattern_diff(cfgplt);

% Plot separately
cfgplt = [];
cfgplt.head = cfg.head;
cfgplt.options.scale = scale;
if isequal(scale, 'globalabsolute') || isequal(scale, 'globalrelative')
    cfgplt.options.data_limit = get_beampattern_data_limit(files, scale);
end
for i=1:length(files)
    cfgplt.file = files{i};
    plot_beampattern3d(cfgplt);
end

scale = 'relative';

% Plot difference
cfgplt = [];
cfgplt.filea = filea;
cfgplt.fileb = fileb;
cfgplt.head = cfg.head;
cfgplt.options.scale = scale;
if isequal(scale, 'globalabsolute') || isequal(scale, 'globalrelative')
    cfgplt.options.data_limit = get_beampattern_data_limit(files, scale);
end
plot_beampattern3d_diff(cfgplt);

end