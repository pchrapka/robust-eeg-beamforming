function [ sinr ] = calc_sinr(signal, interference, noise)
%CALC_SINR Calculates the signal to interference and noise ratio
%   CALC_SINR(SIGNAL, INTERFERENCE, NOISE)

% Calculate the covariances
signal_cov = cov(signal');
noise_int_cov = cov((noise + interference)');

% Calculate the snr
sinr = 10*log10(trace(signal_cov)/trace(noise_int_cov));

end

