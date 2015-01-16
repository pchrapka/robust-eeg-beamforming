function [output] = rmse_select(cfg)
%RMSE_SELECT selects data for RMSE computation
%   RMSE_SELECT(CFG) selects data for RMSE computation
%
%   Input
%   -----
%   cfg.bf_out
%       (optional) [components locations samples]
%   cfg.bf_in
%       (optional) [components locations samples]
%   cfg.sample_idx
%       sample index for RMSE calculation
%   cfg.location_idx
%       location index for RMSE calculation
%
%   Output
%   ------
%   output.bf_out_select
%       cfg.bf_out data selected by criteria
%   output.bf_in_select
%       cfg.bf_in data selected by criteria

% Make sure sample_idx and location_idx are initialized
if isfield(cfg, 'sample_idx') && ~isempty(cfg.sample_idx)
    if ~isvector(cfg.sample_idx)
        sample_idx = repmat(cfg.sample_idx, 1, 2);
        cfg.sample_idx = sample_idx;
    end
else
    cfg.sample_idx = [1 size(cfg.bf_out,3)];
end

if isfield(cfg, 'location_idx') && ~isempty(cfg.location_idx)
    if ~isvector(cfg.location_idx)
        location_idx = repmat(cfg.location_idx, 1, 2);
        cfg.location_idx = location_idx;
    end
else
    cfg.location_idx = [1 size(cfg.bf_out,2)];
end

% Convert the beg/end indices to a range
cfg.sample_idx = cfg.sample_idx(1):cfg.sample_idx(end);
cfg.location_idx = cfg.location_idx(1):cfg.location_idx(end);

% Select the data at the user sample and location indices
if isfield(cfg, 'bf_out')
    bf_select = squeeze(cfg.bf_out(:, cfg.location_idx, cfg.sample_idx));
    output.bf_out_select = bf_select;
end

if isfield(cfg, 'bf_in')
    input_select = squeeze(cfg.bf_in(:, cfg.location_idx, cfg.sample_idx));
    output.bf_in_select = input_select;
end

end