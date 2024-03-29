function [outputfiles] = compute_fwhm(...
    data_set,beamformers, files_power, files_locerr, samples,source_idx,varargin)
%compute_fwhm computes FWHM
%   compute_fwhm computs FWHM
%
%   Input
%   -----
%   data_set (SimDataSetEEG object)
%       original data set 
%   beamformers (cell array)
%       beamformer cfg file tags to process
%   input_files (cell array)
%       file names of power data for each beamformer
%   samples (array)
%       array of samples for power calculation
%
%   Parameters
%   ----------
%   source_idx 
%       source voxel
%   int_idx
%       (optional) index of interfering source
%   save (logical, default = true)
%       flag for saving the plot
%   force (logical, default = false)
%       force recomputation
%
%   Output
%   ------
%   outputfiles
%       cell array of output files
%
%   See also COMPUTE_POWER

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addRequired(p,'files_power',@(x) ~isempty(x) && iscell(x));
addRequired(p,'files_locerr',@(x) ~isempty(x) && iscell(x));
addRequired(p,'samples',@(x) ~isempty(x) && length(x) >= 1);
addRequired(p,'source_idx',@(x) x > 1 && length(x) == 1);
%addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'save',true,@islogical);
addParameter(p,'force',false,@islogical);
addParameter(p,'GroupName','group',@ischar);

parse(p,data_set,beamformers,files_power,files_locerr,samples,source_idx,varargin{:});

%% Options
flag_debug = false;

% Save options
cfg_save = [];
cfg_save.data_set = data_set;
cfg_save.file_type = 'metrics';

%% Localization error based on max power
% allocate mem
outputfiles = cell(length(beamformers),1);
fwhm_radius_all = zeros(length(beamformers),1);
fwhm_radius2_all = zeros(length(beamformers),1);

if length(p.Results.samples) > 1
    idx_start = min(p.Results.samples);
    idx_end = max(p.Results.samples);
    tag_sample = sprintf('s%ds%d',...
        idx_start, idx_end);
else
    tag_sample = sprintf('s%d',...
        p.Results.samples);
end

for i=1:length(beamformers)
    
    cfg_save.file_tag = sprintf('%s_fwhm_%s', beamformers{i}, tag_sample);
    outputfiles{i} = metrics.filename(cfg_save);
    
     % Skip the computation if the file exists
    if exist(outputfiles{i}, 'file') && ~p.Results.force
        print_msg_filename(outputfiles{i},'Skipping');
        fprintf('\tAlready exists\n');
        din = load(outputfiles{i});
        fwhm_radius_all(i) = din.data.fwhm_radius;
        fwhm_radius2_all(i) = din.data.fwhmmaxmin_radius;
        continue;
    else
        print_msg_filename(outputfiles{i},'Working on');
    end
    
    % Load data 
    din = load(files_power{i});
    power_data = din.data.power(:,p.Results.samples);
    if size(power_data,2) > 1
        power_data = mean(power_data,2);
    end
    
    % Load head model
    dinbf = load(din.data.bf_file);
    % get head model config
    if isfield(dinbf.source.head_cfg,'actual')
        head_cfg = dinbf.source.head_cfg.actual;
    else
        head_cfg = dinbf.source.head_cfg;
    end
    
    % Load loc error
    din2 = load(files_locerr{i});
    power_max = din2.data.power_max;
    
    [fwhm_threshold, fwhm_radius] = fwhm_private(power_data, head_cfg,...
        power_max, din2.data.localization_index);
    [fwhm_threshold2, fwhm_radius2] = fwhm_private(power_data, head_cfg,...
        power_max, din2.data.localization_index, 'power_min', min(power_data));
    
    fwhm_radius_all(i) = fwhm_radius;
    fwhm_radius2_all(i) = fwhm_radius2;
    data = [];
    data.fwhm = fwhm_threshold;
    data.fwhm_radius = fwhm_radius;
    data.fwhmmaxmin = fwhm_threshold2;
    data.fwhmmaxmin_radius = fwhm_radius2;
    % Copy data
    data.name = beamformers{i};
    data.bf_file = din.data.bf_file;
    data.data_set = data_set;
    
    % Save output data
    print_save(outputfiles{i});
    save(outputfiles{i}, 'data');
%     save(strrep(outputfiles{i},'.mat','.txt'), 'max_dist', '-ascii');
end

cfg_save = [];
cfg_save.data_set = data_set;
cfg_save.file_type = 'metrics';
cfg_save.file_tag = sprintf('%s_fwhm_%s', p.Results.GroupName, tag_sample);
outputfile_all = metrics.filename(cfg_save);
outputfile_all = strrep(outputfile_all,'.mat','.csv');

% Skip the computation if the file exists
if exist(outputfile_all, 'file') && ~p.Results.force
    print_msg_filename(outputfile_all,'Skipping');
    fprintf('\tAlready exists\n');
    return;
else
    print_msg_filename(outputfile_all,'Working on');
end

fid = fopen(outputfile_all, 'w');
fprintf(fid, 'Beamformer,FWHM radius,FWHM radius (max-min)\n');
for i=1:length(beamformers)
    fprintf(fid, '%s,%0.6g,%0.6g\n', beamformers{i}, fwhm_radius_all(i), fwhm_radius2_all(i));
end
fclose(fid);

end

function [fwhm_threshold, fwhm_radius] = fwhm_private(...
    power_data, head_cfg, power_max, power_max_index, varargin)
p = inputParser();
addRequired(p,'power_data',@(x) ~isempty(x) && length(x) >= 1);
addRequired(p,'head_cfg', @isstruct);
addRequired(p,'power_max',@(x) isnumeric(x) && length(x) == 1);
addRequired(p,'power_max_index',@(x) isnumeric(x) && length(x) == 1);
addParameter(p,'power_min',[],@(x) isnumeric(x) && length(x) == 1);

parse(p,power_data, head_cfg, power_max, power_max_index, varargin{:});

flag_debug = false;

if isempty(p.Results.power_min)
    fwhm_threshold = power_max/2;
else
    fwhm_threshold = (power_max - p.Results.power_min)/2 + p.Results.power_min;
end
idx_bool_fwhm = power_data > fwhm_threshold;
idx_fwhm = 1:size(power_data,1);
idx_fwhm = idx_fwhm(idx_bool_fwhm);

if flag_debug
    power_data_sorted = sort(power_data,1,'descend');
    figure();
    plot(power_data_sorted,'b');
    hold on;
    plot(fwhm_threshold*ones(size(power_data_sorted)),'r');
end

% load head model
hmfactory = HeadModel();
hm = hmfactory.createHeadModel(head_cfg.type,head_cfg.file);
hm.load();

[~,loc_max] = hm.get_vertices('type', 'index', 'idx', power_max_index);

distances = zeros(length(idx_fwhm),1);
for j=1:length(idx_fwhm)
    [~,loc] = hm.get_vertices('type', 'index', 'idx', idx_fwhm(j));
    distances(j) = pdist([loc_max; loc], 'euclidean');
end

% sort distances
[dist_sorted, idx_sorted] = sort(distances,1,'ascend');
dist_diff = diff(dist_sorted);
% check if there's a dstance break in powers that passed the fwhm/2
% threshold
idx_outlier = find(dist_diff > 0.01);
if isempty(idx_outlier)
    idx_outlier = length(idx_sorted);
end

if flag_debug
    h = figure();
    hist(distances);
    close(h);
    
    h = figure();
    A = [distances(:) power_data(idx_fwhm)];
    A = sortrows(A,1);
    plot(A(:,1), A(:,2));
    hold on;
    plot(distances(idx_sorted(idx_outlier))*ones(size(A,1),1),...
        linspace(min(A(:,2)), max(A(:,2)), size(A,1)), 'r');
    xlabel('distance');
    ylabel('power');
    close(h);
end

distances_thresh = distances(idx_sorted(1:idx_outlier));

% get max distance from center
[fwhm_radius,~] = max(distances_thresh);
end