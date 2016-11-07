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

params(k).name = 'data_file';
if iscell(cfg.data_file)
    params(k).values = cfg.data_file;
else
    params(k).values = {cfg.data_file};
end
k = k+1;

% Beamformer configs
params(k).name = 'beamformer_config';
if iscell(cfg.beamformer_config{1})
    params(k).values = cfg.beamformer_config;
else
    params(k).values = {cfg.beamformer_config};
end
k = k+1;

% Fields with single options
% Copy data if there's only one option
fields_cfg = fieldnames(cfg);
for j=1:length(fields_cfg)
    field_cfg = fields_cfg{j};
    switch field_cfg
        case {'data_file','beamformer_config'}
            % do nothing
        case {'head',...
                'loc',...
                'tag',...
                'cov_type',...
                'cov_samples',...
                'data_samples',...
                'force'}
            
            params(k).name = field_cfg;
            
            data = cfg.(field_cfg);
            if iscell(data)
                if length(data) > 1
                    error('too many permutations');
                else
                    params(k).values = data;
                end
            else
                params(k).values = {data};
            end
            k = k+1;
        otherwise
            error('unknown field for beamformer_analysis');
    end
end

end
