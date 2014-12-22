function [output] = rmse_select(cfg)
%RMSE_SELECT selects data for RMSE computation
%   RMSE_SELECT(CFG) selects data for RMSE computation
%
%   Input
%   -----
%   cfg.bf_out
%       [components locations samples]
%   cfg.bf_in
%       [components locations samples]
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
if ~isfield(cfg, 'sample_idx')
    cfg.sample_idx = 0;
end
if ~isfield(cfg, 'location_idx')
    cfg.location_idx = 0;
end

% Select the data at the user sample index
if cfg.sample_idx > 0 && cfg.location_idx > 0
    bf_select = squeeze(cfg.bf_out(:, cfg.location_idx, cfg.sample_idx));
    input_select = squeeze(cfg.bf_in(:, cfg.location_idx, cfg.sample_idx));
elseif cfg.sample_idx > 0
    bf_select = squeeze(cfg.bf_out(:, :, cfg.sample_idx));
    input_select = squeeze(cfg.bf_in(:, :, cfg.sample_idx));
elseif cfg.location_idx > 0
    bf_select = squeeze(cfg.bf_out(:, cfg.location_idx, :));
    input_select = squeeze(cfg.bf_in(:, cfg.location_idx, :));
else
    error('metrics:rmse',...
        'must specify either sample_idx or location_idx');
end

output.bf_out_select = bf_select;
output.bf_in_select = input_select;

end