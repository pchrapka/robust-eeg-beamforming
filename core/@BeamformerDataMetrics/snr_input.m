function [output] = snr_input(S,N)
%SNR_INPUT calculates the SNR of the signal
%
%   Input
%   -----
%   S
%       signal matrix [channels samples]
%   N
%       noise matrix [channels samples]
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
parse(p,S,N);

Rs = cov(S');
Rn = cov(N');

nchannels = size(Rs,1);
num = trace(Rs);
den = trace(Rn)/nchannels;

% Calculate the snr
output.snr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.snrdb = 10*log10(output.snr);


end