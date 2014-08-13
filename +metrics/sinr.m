function [output] = sinr(cfg)
%SINR calculates the SINR of the signal
%   cfg.S
%       signal matrix [channels samples]
%   cfg.I
%       interference matrix [channels samples]
%   cfg.N
%       noise matrix [channels samples]
%   cfg.W
%       spatial filter [channels components]
%
%   Output
%   ------
%   output.sinr
%       signal to interference + noise ratio
%   output.sinrdb
%       signal to interference + noise ratio in dB


% Calculate the sinr
IN = cfg.I + cfg.N;
output.sinr = trace(cfg.W' * (cfg.S * cfg.S') * cfg.W)/...
    trace(cfg.W' * (IN * IN') * cfg.W);

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.sinrdb = 10*log10(output.sinr);


end