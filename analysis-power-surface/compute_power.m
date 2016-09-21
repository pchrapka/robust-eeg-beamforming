function [outputfile] = compute_power(data_set,beamformers,varargin)
%COMPUTE_POWER computes the output power for beamformers
%
%   Input
%   -----
%   data_set (SimDataSetEEG object)
%       original data set 
%   beamformers (cell array)
%       beamformer cfg file tags to process
%
%   Parameters
%   ----------
%   source_idx 
%       center voxel of beampattern
%   int_idx
%       (optional) index of interfering source
%   cfg.mode
%
%   Output
%   ------
%   outputfile (cell array)
%       file names of beamformer output power data, the file name has the
%       following form [data set name]_[beamformer name]_power.mat, i.e.
%       0_1_lcmv_power.mat
%
%   Data
%   ----
%   beamformer output power data contains the following fields
%   name
%       beamformer name
%   bf_file
%       beamformer data filename
%   power
%       power calculated based on configuration

p = inputParser();
addRequired(p,'data_set',@(x) isa(x,'SimDataSetEEG'));
addRequired(p,'beamformers',@(x) ~isempty(x) && iscell(x));
addParameter(p,'mode','instant',@(x) any(validatestring(x,{'instant','average'})));
addParameter(p,'force',false,@islogical);

parse(p,data_set,beamformers,varargin{:});

%% Options

% Save options
cfg_save = [];
cfg_save.data_set = data_set;
cfg_save.file_type = 'metrics';

switch p.Results.mode
    case 'instant'
        mode = 'components';
    case 'average'
        mode = 'components_samples';
end

%% Calculate power for all desired beamformer configs

% allocate mem
outputfile = cell(length(beamformers),1);

% loop over beamformer configs
for i=1:length(beamformers)
    data = [];
    
    % Get the full data file name
    tag = beamformers{i};
    data_file = db.save_setup('data_set',data_set,'tag',tag);
    
    % Set up output filename
    cfg_save.file_tag = sprintf('%s_power_%s',beamformers{i},p.Results.mode);
    outputfile{i} = metrics.filename(cfg_save);
    
    % Skip the computation if the file exists
    if exist(outputfile{i}, 'file') && ~p.Results.force
        fprintf('Skipping %s\n', cfg.outputfile{i});
        fprintf('\tAlready exists\n');
        continue;
    end
    
    % Load data file
    din = load(data_file);
    
    % Calculate the power at each location
    output = metrics.power_source(din.source.beamformer_output,'mode',mode);
    data.power = output.power;
    
    % Copy data
    data.name = beamformers{i};
    data.bf_file = data_file;
    
    % Save output data
    fprintf('Saving %s\n', outputfile{i});
    save(outputfile{i}, 'data');
end

end