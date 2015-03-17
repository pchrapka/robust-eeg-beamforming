function [cfg] = compute_beampattern(cfg)
%COMPUTER_BEAMPATTERN computes the beampattern for a particular beamformer
%
%   Beampattern Options
%   -------------------
%   cfg.voxel_idx   
%       center voxel of beampattern
%   cfg.beam_cfgs   
%       cell array of beamformer cfg file tags to process
%   cfg.interference_idx
%       (optional) index of interfering source
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
%
%   cfg.head        
%       head model cfg (see hm_get_data);
%
%   Outputfile Options
%   ------------------
%   cfg.save
%       options for saving the output file, the file name has the following
%       form [data set name]_[beamformer name]_beampattern.mat, i.e.
%       0_1_lcmv_beampattern.mat
%   cfg.save.file_tag
%       tag attached to output file name, i.e.
%       '0_1_lcmv_beampattern_matched.mat'
%
%   Output
%   ------
%   cfg.outputfile
%       (cell array) file names of beampattern data
%
%   Data
%   ----
%   beampattern data contains the following fields
%   name
%       beamformer name
%   bf_file
%       beamformer data filename
%   beampattern
%       beampattern calculated based on configuration
%   distances
%       distance of each vertex to the center voxel of the beampattern
%   options
%       beampattern options
%   options.voxel_idx
%   options.interference_dist

%% Defaults
if ~isfield(cfg, 'force'),  cfg.force = false; end

%% Options

% Save options
cfg.save.data_set = cfg.data_set;
cfg.save.file_type = 'metrics';

%% Load the head model

data_in = hm_get_data(cfg.head);
head = data_in.head;
clear data_in;

%% Calculate distance between interfering source and source of interest
if isfield(cfg,'interference_idx')
    cfg_dist = [];
    cfg_dist.head = head;
    cfg_dist.vertex_idx = cfg.voxel_idx;
    cfg_dist.voi_idx = cfg.interference_idx;
    interference_dist = distance_from_vertex(cfg_dist);
%     y = ylim();
%     x = [dist dist];
%     line(x,y,'color','black');
end

%% Calculate beampattern for all desired beamformer configs
if isfield(cfg.save, 'file_tag')
    file_tag = ['_' cfg.save.file_tag];
else
    file_tag = [];
end
for i=1:length(cfg.beam_cfgs)
    data = [];
    
    % Get the full data file name
    cfg.data_set.tag = [cfg.beam_cfgs{i}]; % No mini tag
    data_file = db.save_setup(cfg.data_set);
    
    % Set up output filename
    cfg.save.file_tag = [cfg.beam_cfgs{i} '_beampattern' file_tag];
    cfg.outputfile{i} = metrics.filename(cfg.save);
    
    % Skip the computation if the file exists
    if exist(cfg.outputfile{i}, 'file') && ~cfg.force
        fprintf('Skipping %s\n', cfg.outputfile{i});
        fprintf('\tAlready exists\n');
        continue;
    end
    
    % Set up cfg for beampattern
    cfg_bp = [];
    cfg_bp.voxel_idx = cfg.voxel_idx;
    cfg_bp.beamformer_file = data_file;
    cfg_bp.distances = true;
    cfg_bp.head = head;
    
    % Calculate the beampattern
    [data.beampattern, data.distances] = beampattern(cfg_bp);
    
    % Copy data
    data.name = cfg.beam_cfgs{i};
    data.bf_file = data_file;
    data.options.voxel_idx = cfg.voxel_idx;
    if exist('interference_dist','var')
        data.options.interference_dist = interference_dist;
    end
    
    % Save output data
    fprintf('Saving %s\n', cfg.outputfile{i});
    save(cfg.outputfile{i}, 'data');
end

end