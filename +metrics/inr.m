function [output] = inr(cfg)
%INR calculates the INR of the signal
%   cfg.I
%       interference matrix [channels samples]
%   cfg.N
%       noise matrix [channels samples]
%   cfg.W
%       spatial filter [channels components]
%
%   Output
%   ------
%   output.inr
%       interference to noise ratio
%   output.inrdb
%       interference to noise ratio in dB


% Calculate the snr
output.inr = trace(cfg.W' * (cfg.I * cfg.I') * cfg.W)/...
    trace(cfg.W' * (cfg.N * cfg.N') * cfg.W);

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.inrdb = 10*log10(output.inr);


end