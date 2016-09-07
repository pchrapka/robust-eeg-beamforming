function params = get_beamformer_analysis_config(cfg)
%GET_CONFIG returns a config of simulation variables
%   GET_CONFIG(CFG) returns a config of simulation variables specified
%   by CFG.
%   
%   Input
%   cfg.beamformer_config (parameter cell array/cell array of parameter cell arrays)
%       list of beamformer parameter configs
%
%       Example:
%       cfg.beamformer_config = {...
%           {'BeamformerLCMV'},...
%           {'BeamformerRMV','epsilon',0.01},...
%       };
%   cfg.data_file (cell array of strings)
%       list of data files to use
%   cfg.head (IHeadModel object/cell array of IHeadModel objects)
%       head model, see HeadModel
%   cfg.loc (vector/cell array of vectors)
%       locations to scan specified as indices in the head model
%       struct
%   cfg.tag (string)
%       additional tag for the output file
%   cfg.force (logical)
%       adds a flag that forces the analysis to be redone, overwriting the
%       existing output files

k = 1;
if isfield(cfg, 'data')
    error('sim_vars:get_config',...
        'use data_file instead');
end

if isfield(cfg,'data_file')
    params(k).name = 'data_file';
    if iscell(cfg.data_file)
        params(k).values = cfg.data_file;
    else
        params(k).values = {cfg.data_file};
    end
    k = k+1;
end

% Head model
if isfield(cfg,'head')
    params(k).name = 'head';
    if iscell(cfg.head)
        params(k).values = cfg.head;
    else
        params(k).values = {cfg.head};
    end
    k = k+1;
end

% Beamformer locations
if isfield(cfg,'loc')
    params(k).name = 'loc';
    if iscell(cfg.loc)
        params(k).values = cfg.loc;
    else
        params(k).values = {cfg.loc};
    end
    k = k+1;
end

if isfield(cfg, 'tag')
    params(k).name = 'tag';
    params(k).values = {cfg.tag};
    k = k+1;
end

% Beamformer configs
params(k).name = 'beamformer_config';
if iscell(cfg.beamformer_config{1})
    params(k).values = cfg.beamformer_config;
else
    params(k).values = {cfg.beamformer_config};
end

if isfield(cfg,'force')
    if cfg.force
        idx = length(params) + 1;
        params(idx).name = 'force';
        params(idx).values = {cfg.force};
    end
end

if isfield(cfg, 'time_idx')
    idx = length(params) + 1;
    params(idx).name = 'time_idx';
    params(idx).values = {cfg.time_idx};
end

end
