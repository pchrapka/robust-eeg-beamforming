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
%   cfg.data_set 
%       SimDataSetEEG object
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


%% Calculate beampattern for all desired beamformer configs
if isfield(cfg.save, 'file_tag')
    file_tag = ['_' cfg.save.file_tag];
else
    file_tag = '';
end

hm = [];

for i=1:length(cfg.beam_cfgs)
    data = [];
    
    % Get the full data file name
    tag = [cfg.beam_cfgs{i}]; % No mini tag
    bf_file = db.save_setup('data_set',cfg.data_set,'tag',tag);
    
    % Load the head model
    hm_new = load_hm_from_beamformer_file(bf_file, 'hm_cached', hm.file);
    if ~isempty(hm_new)
        hm = hm_new;
    end
    
    % Set up output filename
    cfg.save.file_tag = sprintf('%s_beampattern%s',cfg.beam_cfgs{i},file_tag);
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
    cfg_bp.beamformer_file = bf_file;
    cfg_bp.distances = true;
    cfg_bp.head = hm;
    
    % Calculate the beampattern
    [data.beampattern, data.distances] = beampattern(cfg_bp);
    
    % Calculate distance between interfering source and source of interest
    if isfield(cfg,'interference_idx')
        cfg_dist = [];
        cfg_dist.head = hm;
        cfg_dist.vertex_idx = cfg.voxel_idx;
        cfg_dist.voi_idx = cfg.interference_idx;
        interference_dist = distance_from_vertex(cfg_dist);
        %     y = ylim();
        %     x = [dist dist];
        %     line(x,y,'color','black');
    end
    
    % Copy data
    data.data_set = cfg.data_set;
    data.name = cfg.beam_cfgs{i};
    data.bf_file = bf_file;
    data.options.voxel_idx = cfg.voxel_idx;
    if exist('interference_dist','var')
        data.options.interference_idx = cfg.interference_idx;
        data.options.interference_dist = interference_dist;
    end
    
    % Save output data
    print_save(cfg.outputfile{i});
    save(cfg.outputfile{i}, 'data');
end

end