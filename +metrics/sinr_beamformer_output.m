function [output] = sinr_beamformer_output(S,I,N,W)
%SINR_BEAMFORMER_OUTPUT calculates the SINR of the beamformer output signal
%   S
%       signal matrix [channels samples]
%   I
%       interference matrix [channels samples]
%   N
%       noise matrix [channels samples]
%   W
%       spatial filter [channels components]
%
%   Output
%   ------
%   output.sinr
%       signal to interference + noise ratio
%   output.sinrdb
%       signal to interference + noise ratio in dB

p = inputParser();
addRequired(p,'S',@metrics.validate_signal_matrix);
addRequired(p,'I',@metrics.validate_signal_matrix);
addRequired(p,'N',@metrics.validate_signal_matrix);
addRequired(p,'W',@ismatrix);
parse(p,S,I,N,W);

% Calculate the sinr
Rs = cov(S');
Ri = cov(I');
Rn = cov(N');

nchannels = size(Rs,1);
num = trace(W' * Rs * W);
den = trace(W' * Ri * W) + trace(W' * Rn * W)/nchannels;

% Calculate the sinr
output.sinr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.sinrdb = 10*log10(output.sinr);


end