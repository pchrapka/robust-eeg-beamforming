function [output] = snr_input(S,N,varargin)
%SNR_INPUT calculates the SNR of the signal
%
%   Input
%   -----
%   S
%       signal matrix [channels samples]
%   N
%       noise matrix [channels samples]
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
addRequired(p,'S',@metrics.validate_signal_matrix);
addRequired(p,'N',@metrics.validate_signal_matrix);
addParameter(p,'ZeroMean',false,@islogical);
parse(p,S,N,varargin{:});

if p.Results.ZeroMean
    nchannels = size(S,1);
    Rs = S*S'/nchannels;
    Rn = N*N'/nchannels;
else
    Rs = cov(S');
    Rn = cov(N');
end

nchannels = size(Rs,1);
num = trace(Rs);
% den = trace(Rn)/nchannels;
warning('not dividing Rn by number of channels');
% NOTE may want to make this agree better with data generation
den = trace(Rn);

% Calculate the snr
output.snr = num/den;

% Convert snr to dB
% Only 10 because I think the SNR above is power
output.snrdb = 10*log10(output.snr);


end