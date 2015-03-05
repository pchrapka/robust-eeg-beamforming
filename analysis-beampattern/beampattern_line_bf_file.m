function beampattern_line_bf_file(cfg)
%BEAMPATTERN_LINE_BF_FILE creates a line plot of the beampattern of a
%beamformer
%   cfg.voxel_idx   
%       center voxel of beampattern
%   cfg.beam_cfgs   
%       cell array of beamformer cfg file tags to process
%   cfg.sim_name    simulation config name
%   cfg.source_name source config name
%   cfg.snr         snr
%   cfg.iteration   simulation iteration
%   cfg.head        
%       head model cfg (see hm_get_data);
%   cfg.interference_idx
%       (optional) index of interfering source

cfg.normalize = true;
cfg.db = true;


%% Set up simulation info
cfg_data = [];
cfg_data.sim_name = cfg.sim_name;
cfg_data.source_name = cfg.source_name;
cfg_data.snr = cfg.snr;
cfg_data.iteration = cfg.iteration;

%% Load the head model

data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

%% Calculate dispersion for all desired beamformer configs
for i=1:length(cfg.beam_cfgs)
    % Get the full data file name
    cfg_data.tag = [cfg.beam_cfgs{i}]; % No mini tag
    data_file = db.save_setup(cfg_data);
    
    % Set up cfg for beampattern
    cfg_bp = [];
    cfg_bp.voxel_idx = cfg.voxel_idx;
    cfg_bp.beamformer_file = data_file;
    cfg_bp.distances = true;
    cfg_bp.head = head;
    
    % Calculate the beampattern
    mag_dist_data.name{i} = cfg.beam_cfgs{i};
    [beampattern_data(:,i), distances(:,i)] = beampattern(cfg_bp);
end

%% Plot the beampattern
n_data = length(mag_dist_data.name);
cc=jet(n_data);

n_plots = size(beampattern_data,2);
n_cols = 2;
n_rows = ceil(n_plots/n_cols);
figure; 
for i=1:n_plots
    subplot(n_rows, n_cols, i);
    % Combine the data
    data = [distances(:,i) beampattern_data(:,i)];
    % Sort data based on distance
    data = sortrows(data,1);
    if cfg.db
        data(:,2) = db(data(:,2));
    end
    if cfg.normalize
        data(:,2) = data(:,2)/data(1,2);
    end
    plot(data(:,1),data(:,2),...
        'color',cc(i,:));
    xlim([0 data(end,1)]);
    ylabel(mag_dist_data.name{i});
end
% legend(h, mag_dist_data.name);

if isfield(cfg,'interference_idx')
    cfg_dist = [];
    cfg_dist.head = head;
    cfg_dist.vertex_idx = cfg.voxel_idx;
    cfg_dist.voi_idx = cfg.interference_idx;
    dist = distance_from_vertex(cfg_dist);
    y = ylim();
    x = [dist dist];
    line(x,y);
end

%% Plot the 3D beampattern
% Load the tesselated data
bstdir = brainstorm.bstcust_getdir('db');
tess = load(fullfile(bstdir,...
    'Protocol-Phil-BEM','anat',head.SurfaceFile));
for i=1:n_plots
    brainstorm.bstcust_plot_surface3d_data(tess, beampattern_data(:,i));
end

end