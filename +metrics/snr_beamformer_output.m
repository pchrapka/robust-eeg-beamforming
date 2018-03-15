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
%       spatial filter [channels components] or cell array of spatial
%       filters
%
%   Output
%   ------
%   output.snr
%       signal to noise ratio
%   output.snr_avg
%       average snr
%   output.snrdb
%       signal to noise ratio in dB
%   output.snrdb_avg
%       average snrdb
%   output.niterations
%       number of analysis iterations

p = inputParser();
addRequired(p,'S',@metrics.validate_signal_matrix);
addRequired(p,'N',@metrics.validate_signal_matrix);
addRequired(p,'W',@(x) iscell(x) || ismatrix(x));
parse(p,S,N,W);

Rs = cov(S');
Rn = cov(N');

nchannels = size(Rs,1);

if iscell(W)
    W_orig = W;
else
    W_orig = {W};
end
niterations = length(W_orig);

for i=1:niterations
    W = W_orig{i};
    num = trace(W' * Rs * W);
    den = trace(W' * Rn * W);
    
    % Calculate the snr
    output.snr(i) = num/den;
    
    % Convert snr to dB
    % Only 10 because I think the SNR above is power
    output.snrdb(i) = 10*log10(output.snr(i));
end
output.niterations = niterations;
output.snr_avg = mean(output.snr);
output.snrdb_avg = mean(output.snrdb);


end