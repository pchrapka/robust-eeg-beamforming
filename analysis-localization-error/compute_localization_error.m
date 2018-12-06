function [outputfiles] = compute_localization_error(...
    data_set,beamformers, input_files, samples,source_idx,varargin)
%compute_localization_error computes localization error
%   compute_localization_error %compute_localization_error 
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
addRequired(p,'input_files',@(x) ~isempty(x) && iscell(x));
addRequired(p,'samples',@(x) ~isempty(x) && length(x) >= 1);
addRequired(p,'source_idx',@(x) x > 1 && length(x) == 1);
%addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'save',true,@islogical);
addParameter(p,'force',false,@islogical);
addParameter(p,'GroupName','group',@ischar);

parse(p,data_set,beamformers,input_files,samples,source_idx,varargin{:});

%% Options

% Save options
cfg_save = [];
cfg_save.data_set = data_set;
cfg_save.file_type = 'metrics';

%% Localization error based on max power
% allocate mem
outputfiles = cell(length(beamformers),1);
power_max = zeros(length(beamformers),1);
loc_err = power_max;
idx_max = power_max;

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
    
    cfg_save.file_tag = sprintf('%s_localization_error_%s', beamformers{i}, tag_sample);
    outputfiles{i} = metrics.filename(cfg_save);
    
     % Skip the computation if the file exists
    if exist(outputfiles{i}, 'file') && ~p.Results.force
        print_msg_filename(outputfiles{i},'Skipping');
        fprintf('\tAlready exists\n');
        din = load(outputfiles{i});
        power_max(i) = din.data.power_max;
        loc_err(i) = din.data.localization_error;
        idx_max(i) = din.data.localization_index;
        continue;
    else
        print_msg_filename(outputfiles{i},'Working on');
    end
    
    % Load data 
    din = load(input_files{i});
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
    
    % load head model
    hmfactory = HeadModel();
    hm = hmfactory.createHeadModel(head_cfg.type,head_cfg.file);
    hm.load();
    
    [idx_rad, ~] = hm.get_vertices('type', 'radius',...
        'center_idx', source_idx, 'radius', 4/100);
    % Find max voxel
    [power_max(i), idx_max_temp] = max(power_data(idx_rad));
    idx_max(i) = idx_rad(idx_max_temp);
                
    % Get voxel positions
    [~,loc_max] = hm.get_vertices('type', 'index', 'idx', idx_max(i));
    [~,loc_source] = hm.get_vertices('type','index', 'idx', source_idx);
    % Get distance from source voxel
    loc_err(i) = pdist([loc_max; loc_source], 'euclidean');
    % Save to file
    
    data = [];
    data.power_max = power_max(i);
    data.localization_error = loc_err(i);
    data.localization_index = idx_max(i);
    % Copy data
    data.name = beamformers{i};
    data.bf_file = din.data.bf_file;
    data.data_set = data_set;
    
    % Save output data
    print_save(outputfiles{i});
    save(outputfiles{i}, 'data');
%     save(strrep(outputfiles{i},'.mat','.txt'), 'loc_err', '-ascii');
end

cfg_save = [];
cfg_save.data_set = data_set;
cfg_save.file_type = 'metrics';
cfg_save.file_tag = sprintf('%s_localization_error_%s', p.Results.GroupName, tag_sample);
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
fprintf(fid, 'Beamformer,Max Power,Localization Error,Localization Index\n');
for i=1:length(beamformers)
    fprintf(fid, '%s,%0.6g,%0.6g,%d\n', beamformers{i}, power_max(i), loc_err(i), idx_max(i));
end
fclose(fid);

end