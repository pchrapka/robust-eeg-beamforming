function beampattern_line_bf_file(cfg)
%BEAMPATTERN_LINE_BF_FILE creates a line plot of the beampattern of a
%beamformer
%   cfg.voxel_idx   
%       center voxel of beampattern
%   cfg.beam_cfgs   
%       cell array of beamformer cfg file tags to process
%
%   Data Set
%   --------
%   cfg.data_set with the following fields
%   sim_name    simulation config name
%   source_name source config name
%   snr         snr
%   iteration   simulation iteration
%
%     Example:
%     cfg.data_set.sim_name = 'sim_data_bem_1_100t';
%     cfg.data_set.source_name = 'mult_cort_src_10';
%     cfg.data_set.snr = 0;
%     cfg.data_set.iteration = '1';
% % %   cfg.sim_name    simulation config name
% % %   cfg.source_name source config name
% % %   cfg.snr         snr
% % %   cfg.iteration   simulation iteration
%   cfg.head        
%       head model cfg (see hm_get_data);
%   cfg.interference_idx
%       (optional) index of interfering source
%
%   cfg.save
%       options for saving the output file, the file name has the following
%       form [data set name]_beampattern.mat, i.e. 0_1_beampattern.mat
%   cfg.save.file_tag
%       tag attached to output file name, i.e. '0_1_beampattern_matched.mat'

cfg.normalize = true;
cfg.db = true;


%% Set up simulation info
cfg_data = [];
cfg_data.sim_name = cfg.datasim_name;
cfg_data.source_name = cfg.source_name;
cfg_data.snr = cfg.snr;
cfg_data.iteration = cfg.iteration;

%% Load the head model

data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

%% Calculate beampattern for all desired beamformer configs
data = [];
for i=1:length(cfg.beam_cfgs)
    % Get the full data file name
    cfg.data_set.tag = [cfg.beam_cfgs{i}]; % No mini tag
    data_file = db.save_setup(cfg.data_set);
    
    % Set up cfg for beampattern
    cfg_bp = [];
    cfg_bp.voxel_idx = cfg.voxel_idx;
    cfg_bp.beamformer_file = data_file;
    cfg_bp.distances = true;
    cfg_bp.head = head;
    
    % Calculate the beampattern
    data.name{i} = cfg.beam_cfgs{i};
    [data.beampattern(:,i), data.distances(:,i)] = beampattern(cfg_bp);
end

%% Save the data
% FIXME Should i do this by beamformer?
cfg.save.data_set = cfg.data_set;
cfg.save.file_type = 'metrics';
if isfield(cfg.save, 'file_tag')
    % Prefix save tag with beampattern
    cfg.save.file_tag = ['beampattern_' cfg.save.file_tag];
else
    cfg.save.file_tag = 'beampattern';
end
cfg.outputfile = metrics.filename(cfg.save);
% Save output data
fprintf('Saving %s\n', cfg.outputfile);
save(cfg.outputfile, 'data');

% %% Plot the beampattern
% n_data = length(mag_dist_data.name);
% cc=jet(n_data);
% 
% n_plots = size(beampattern_data,2);
% n_cols = 2;
% n_rows = ceil(n_plots/n_cols);
% figure; 
% for i=1:n_plots
%     subplot(n_rows, n_cols, i);
%     % Combine the data
%     data = [distances(:,i) beampattern_data(:,i)];
%     % Sort data based on distance
%     data = sortrows(data,1);
%     if cfg.db
%         data(:,2) = db(data(:,2));
%     end
%     if cfg.normalize
%         data(:,2) = data(:,2)/data(1,2);
%     end
%     plot(data(:,1),data(:,2),...
%         'color',cc(i,:));
%     xlim([0 data(end,1)]);
%     ylabel(mag_dist_data.name{i});
% end
% % legend(h, mag_dist_data.name);
% 
% if isfield(cfg,'interference_idx')
%     cfg_dist = [];
%     cfg_dist.head = head;
%     cfg_dist.vertex_idx = cfg.voxel_idx;
%     cfg_dist.voi_idx = cfg.interference_idx;
%     dist = distance_from_vertex(cfg_dist);
%     y = ylim();
%     x = [dist dist];
%     line(x,y);
% end

% %% Plot the 3D beampattern
% % Load the tesselated data
% bstdir = brainstorm.bstcust_getdir('db');
% tess = load(fullfile(bstdir,...
%     'Protocol-Phil-BEM','anat',head.SurfaceFile));
% for i=1:n_plots
%     brainstorm.bstcust_plot_surface3d_data(tess, beampattern_data(:,i));
% end

end