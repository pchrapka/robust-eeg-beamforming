function [output] = beamformer_output_snr(S,N,W)
%BEAMFORMER_OUTPUT_SNR calculates the SNR of the beamformer output signal
%
%   Input
%   -----
%   S
%       signal matrix [channels samples]
%   N
%       noise matrix [channels samples]
%   W
%       spatial filter [channels components]
%
%   Output
%   ------
%   output.snr
%       signal to noise ratio
%   output.snrdb
%       signal to noise ratio in dB

p = inputParser();
addRequired(p,'S',@metrics.validate_signal_matrix);
addRequired(p,'N',@metrics.validate_signal_matrix);
addRequired(p,'W',@ismatrix);
parse(p,S,N,W);

Rs = cov(S');
Rn = cov(N');

nchannels = size(Rs,1);
num = trace(W' * Rs * W);
den = trace(W' * Rn * W)/nchannels;

% Calculate the snr
output.snr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.snrdb = 10*log10(output.snr);


end