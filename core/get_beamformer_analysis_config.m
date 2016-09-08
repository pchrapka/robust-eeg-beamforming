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

% Beamformer configs
params(k).name = 'beamformer_config';
if iscell(cfg.beamformer_config{1})
    params(k).values = cfg.beamformer_config;
else
    params(k).values = {cfg.beamformer_config};
end

% fields with single options
% NOTE limitation in naming convention
fields_single = {...
    'head',...
    'loc',...
    'tag',...
    'time_idx',...
    'cov_type',...
    'sample_idx',...
    'force',...
    };

for i=1:length(fields_single)
    field = fields_single{i};
    if isfield(cfg,field)
        params(k).name = field;
        
        data = cfg.(field);
        if iscell(data)
            if length(data) > 1
                error('too many permutations');
            else
                params(k).value = data;
            end
        else
            params(k).value = {data};
        end
        k = k+1;
    end
end

end
