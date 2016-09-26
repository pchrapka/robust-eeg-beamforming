function [outpufile] = compute_beampattern(data_set,beamformers,source_idx,varargin)
%COMPUTER_BEAMPATTERN computes the beampattern for a particular beamformer
%
%   Input
%   -----
%   data_set (SimDataSetEEG object)
%       original data set 
%   beamformers (cell array)
%       beamformer cfg file tags to process
%   source_idx 
%       center voxel of beampattern
%
%   Parameters
%   ----------
%   int_idx
%       (optional) index of interfering source
%   mode
%
%   Output
%   ------
%   outputfile (cell array)
%       file names of beamformer output power data, the file name has the
%       following form [data set name]_[beamformer name]_beampattern.mat, i.e.
%       0_1_lcmv_beampattern.mat
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

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addRequired(p,'source_idx',@(x) x > 1 && length(x) == 1);
% addParameter(p,'mode','instant',@(x) any(validatestring(x,{'instant','average'})));
addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'force',false,@islogical);

parse(p,data_set,beamformers,source_idx,varargin{:});

%% Save options
cfg_save = [];
cfg_save.data_set = p.Results.data_set;
cfg_save.file_type = 'metrics';

%% Calculate beampattern for all desired beamformer configs

hm = [];
outputfile = cell(length(beamformers),1);

for i=1:length(beamformers)
    data = [];
    
    % Get the full data file name
    bf_file = db.save_setup('data_set',data_set,'tag',beamformers{i});
    
    % Load the head model
    hm_new = load_hm_from_beamformer_file(bf_file, 'hm_cached', hm.file);
    if ~isempty(hm_new)
        hm = hm_new;
    end
    
    % Set up output filename
    cfg_save.file_tag = sprintf('%s_beampattern',beamformers{i});
    outputfile{i} = metrics.filename(cfg_save);
    
    % Skip the computation if the file exists
    if exist(outputfile{i}, 'file') && ~p.Results.force
        print_msg_filename(outputfile{i},'Skipping');
        fprintf('\tAlready exists\n');
        continue;
    end
    
    % Set up cfg for beampattern
    cfg_bp = [];
    cfg_bp.voxel_idx = p.Results.source_idx;
    cfg_bp.beamformer_file = bf_file;
    cfg_bp.distances = true;
    cfg_bp.head = hm;
    
    % Calculate the beampattern
    [data.beampattern, data.distances] = beampattern(cfg_bp);
    
    % Calculate distance between interfering source and source of interest
    if ~isempty(p.Results.int_idx)
        cfg_dist = [];
        cfg_dist.head = hm;
        cfg_dist.vertex_idx = p.Results.source_idx;
        cfg_dist.voi_idx = p.Results.int_idx;
        interference_dist = distance_from_vertex(cfg_dist);
        %     y = ylim();
        %     x = [dist dist];
        %     line(x,y,'color','black');
    end
    
    % Copy data
    data.data_set = data_set;
    data.name = beamformers{i};
    data.bf_file = bf_file;
    data.options.voxel_idx = p.Results.source_idx;
    if exist('interference_dist','var')
        data.options.interference_idx = p.Results.int_idx;
        data.options.interference_dist = interference_dist;
    end
    
    % Save output data
    print_save(outputfile{i});
    save(outputfile{i}, 'data');
end

end