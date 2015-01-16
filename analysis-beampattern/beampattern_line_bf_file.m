function beampattern_line_bf_file(cfg)
%BEAMPATTERN_LINE_BF_FILE creates a line plot of the beampattern of a
%beamformer
%   cfg.voxel_idx   center voxel of beampattern
%   cfg.beam_cfgs   cell array of beamformer cfg file tags to process
%   cfg.sim_name    simulation config name
%   cfg.source_name source config name
%   cfg.snr         snr
%   cfg.iteration   simulation iteration
%   cfg.head        head model cfg (see hm_get_data);
%   cfg.interference_idx
%                   (optional) index of interfering source

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
figure; 
hold on;
for i=1:n_data
    % Combine the data
    data = [distances(:,i) beampattern_data(:,i)];
    % Sort data based on distance
    data = sortrows(data,1);
    plot(data(:,1),data(:,2),...
        'color',cc(i,:));
end
legend(mag_dist_data.name);

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

end