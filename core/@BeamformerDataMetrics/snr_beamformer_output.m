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
%       spatial filter [channels components]
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
%   output.snrdb
%       signal to noise ratio in dB

p = inputParser();
addRequired(p,'S',@BeamformerDataMetrics.validate_signal_matrix);
addRequired(p,'N',@BeamformerDataMetrics.validate_signal_matrix);
addRequired(p,'W',@ismatrix);
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

num = trace(W' * Rs * W);
den = trace(W' * Rn * W);

% Calculate the snr
output.snr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.snrdb = 10*log10(output.snr);


end