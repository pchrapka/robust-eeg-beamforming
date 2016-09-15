function [output] = isnr(cfg)
%ISNR calculates the ISNR of the signal
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
%   output.isnr
%       interference to signal + noise ratio
%   output.isnrdb
%       interference to signal + noise ratio in dB


% Calculate the isnr
Ri = cov(cfg.I');
Rsn = cov(cfg.S' + cfg.N');
output.sinr = trace(cfg.W' * Ri * cfg.W)/...
    trace(cfg.W' * Rsn * cfg.W);

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.isnrdb = 10*log10(output.isnr);


end