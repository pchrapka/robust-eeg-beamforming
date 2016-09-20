function [cfg] = compute_power(cfg)
%COMPUTE_POWER computes the output power for beamformers
%
%   Beamformer Options
%   -------------------
%   cfg.beam_cfgs   
%       cell array of beamformer cfg file tags to process
%   cfg.voxel_idx   
%       center voxel of beampattern
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
%       form [data set name]_[beamformer name]_power.mat, i.e.
%       0_1_lcmv_power.mat
%   cfg.save.file_tag
%       tag attached to output file name, i.e.
%       '0_1_lcmv_power_matched.mat'
%
%   Output
%   ------
%   cfg.outputfile
%       (cell array) file names of beamformer output power data
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
%   options
%       power options
%   options.voxel_idx
%   options.interference_dist

%% Defaults
if ~isfield(cfg, 'force'),  cfg.force = false; end

%% Options

% Save options
cfg.save.data_set = cfg.data_set;
cfg.save.file_type = 'metrics';

%% Calculate power for all desired beamformer configs
if isfield(cfg.save, 'file_tag')
    file_tag = ['_' cfg.save.file_tag];
else
    file_tag = '';
end
for i=1:length(cfg.beam_cfgs)
    data = [];
    
    % Get the full data file name
    tag = cfg.beam_cfgs{i};
    data_file = db.save_setup('data_set',cfg.data_set,'tag',tag);
    
    % Set up output filename
    cfg.save.file_tag = [cfg.beam_cfgs{i} '_power' file_tag];
    cfg.outputfile{i} = metrics.filename(cfg.save);
    
    % Skip the computation if the file exists
    if exist(cfg.outputfile{i}, 'file') && ~cfg.force
        fprintf('Skipping %s\n', cfg.outputfile{i});
        fprintf('\tAlready exists\n');
        continue;
    end
    
    % Load data file
    din = load(data_file);
    
    % Calculate the power at each location
    cfg_pow = [];
    cfg_pow.data = din.source.beamformer_output;
    output = metrics.power(cfg_pow);
    data.power = output.power;
    
    % Copy data
    data.name = cfg.beam_cfgs{i};
    data.bf_file = data_file;
    data.options.voxel_idx = cfg.voxel_idx;
    if isfield(cfg,'interference_idx')
        data.options.interference_idx = cfg.interference_idx;
    end
    
    % Save output data
    fprintf('Saving %s\n', cfg.outputfile{i});
    save(cfg.outputfile{i}, 'data');
end

end