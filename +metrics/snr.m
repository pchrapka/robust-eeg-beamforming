function [output] = snr(cfg)
%SINR calculates the SNR of the signal
%   cfg.S
%       signal matrix [channels samples]
%   cfg.N
%       noise matrix [channels samples]
%   cfg.W
%       spatial filter [channels components]


output = trace(cfg.W' * cfg.S * cfg.S' * cfg.W)/...
    trace(cfg.W' * cfg.N * cfg.N' * cfg.W);


end