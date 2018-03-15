function [output] = snr_beamformer_output(S,N,W,varargin)
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
%   Parameters
%   ----------
%   ZeroMean (logical, default = false)
%       flag as to whether data is zero mean
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
addRequired(p,'S',@BeamformerDataMetrics.validate_signal_matrix);
addRequired(p,'N',@BeamformerDataMetrics.validate_signal_matrix);
addRequired(p,'W',@(x) iscell(x) || ismatrix(x));
addParameter(p,'ZeroMean',false,@islogical);
parse(p,S,N,W,varargin{:});

if p.Results.ZeroMean
    nchannels = size(S,1);
    Rs = S*S'/nchannels;
    Rn = N*N'/nchannels;
else
    Rs = cov(S');
    Rn = cov(N');
end

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