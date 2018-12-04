function [outputfiles] = compute_localization_error(data_set,beamformers,samples,varargin)
%compute_localization_error computes localization error
%   compute_localization_error %compute_localization_error 
%
%   Input
%   -----
%   data_set (SimDataSetEEG object)
%       original data set 
%   beamformers (cell array)
%       beamformer cfg file tags to process
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
addRequired(p,'samples',@(x) ~isempty(x) && length(x) >= 1);
addParameter(p,'source_idx',[],@(x) x > 1 && length(x) == 1);
addParameter(p,'int_idx',[],@(x) isempty(x) || (x > 1 && length(x) == 1));
addParameter(p,'save',true,@islogical);
parse(p,data_set,beamformers,samples,varargin{:});

%% Options

% Save options
cfg_save = [];
cfg_save.data_set = data_set;
cfg_save.file_type = 'metrics';

%% Localization error based on max power
% allocate mem
outputfiles = cell(length(beamformers),1);

for i=1:length(beamformers)
    
    cfg_save.file_tag = sprintf('%s_power_instant',beamformers{i});
    inputfile = metrics.filename(cfg_save);
    
    cfg_save.file_tag = sprintf('%s_localization_error',beamformers{i});
    outputfiles{i} = metrics.filename(cfg_save);
    
     % Skip the computation if the file exists
    if exist(outputfiles{i}, 'file') && ~p.Results.force
        print_msg_filename(outputfile{i},'Skipping');
        fprintf('\tAlready exists\sn');
        continue;
    else
        print_msg_filename(outputfiles{i},'Working on');
    end
    
    % Load data 
    din = load(inputfile);
    power_data = din.data.power(:,p.Results.samples);
    if size(power_data,2) > 1
        power_data = mean(power_data,2);
    end
    
    % Find max voxel
    [y, idx_max] = max(power_data);
    
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
    obj.hm = hmfactory.createHeadModel(head_cfg.type,head_cfg.file);
    obj.hm.load();
                
    % Get max voxel position
    % Get distance from source voxel
    % Save to file
    
%     vobj = ViewSources(datafiles{i});
%     
%     % Plot the data
%     cfgplt = [];
%     cfgplt.options.scale = 'relative';
%     if ~isempty(p.Results.samples)
%         cfgplt.options.samples = p.Results.samples;
%     end
%     vobj.plot('power3d',cfgplt);
%     
%     % Plot source markers
%     vobj.show_sources('source_idx',p.Results.source_idx,...
%         'int_idx',p.Results.int_idx);
%     
%     vobj.save();
%     
%     % Save the plot
%     if p.Results.save
%         % Set up plot save options
%         outfile{i} = vobj.save();
%     end
%     
%     close;
end

end