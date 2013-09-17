function [ out ] = set_up_output(cfg)
%SET_UP_OUTPUT Set up output struct
%   SET_UP_OUTPUT(CFG) returns the output struct according to the CFG
%
%   Input
%   cfg.beam_cfg    beamformer configuration returned by set_up_beamformers
%       y_size      vector indicating size of y data, [M, N]
%       x_size      vector indicating size of x data, [M, N]
%
%   See also SET_UP_BEAMFORMERS

% Get number of configs
n = length(cfg.beam_cfg);

out(n).name = '';

for i=1:n
    out(i).name = cfg.beam_cfg(i).name;
    out(i).y = zeros(cfg.y_size);
    out(i).ylabel = 'Output SINR (dB)';
    out(i).x = zeros(cfg.x_size);
    out(i).xlabel = 'SNR (dB)'; 
end

end