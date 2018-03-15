function [output] = sinr_beamformer_output(S,I,N,W)
%SINR_BEAMFORMER_OUTPUT calculates the SINR of the beamformer output signal
%   S
%       signal matrix [channels samples]
%   I
%       interference matrix [channels samples]
%   N
%       noise matrix [channels samples]
%   W
%       spatial filter [channels components] or cell array of spatial
%       filters
%
%   Output
%   ------
%   output.sinr
%       signal to interference + noise ratio
%   output.sinr_avg
%       average sinr
%   output.sinrdb
%       signal to interference + noise ratio in dB
%   output.sinrdb_avg
%       average sinrdb
%   output.niterations
%       number of analysis iterations

p = inputParser();
addRequired(p,'S',@metrics.validate_signal_matrix);
addRequired(p,'I',@metrics.validate_signal_matrix);
addRequired(p,'N',@metrics.validate_signal_matrix);
addRequired(p,'W',@(x) iscell(x) || ismatrix(x));
parse(p,S,I,N,W);

% Calculate the sinr
Rs = cov(S');
Rin = cov(I' + N');

if iscell(W)
    W_orig = W;
else
    W_orig = {W};
end
niterations = length(W_orig);
    
for i=1:niterations
    W = W_orig{i};
    
    num = trace(W' * Rs * W);
    den = trace(W' * Rin * W);
    
    % Calculate the sinr
    output.sinr(i) = num/den;
    
    % Convert snr to dB
    % Only 10 because I think the SNR above is power
    output.sinrdb(i) = 10*log10(output.sinr(i));
end
output.niterations = niterations;
output.sinr_avg = mean(output.sinr);
output.sinrdb_avg = mean(output.sinrdb);


end