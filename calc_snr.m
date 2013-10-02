function [ snr ] = calc_snr(signal, noise)
%CALC_SNR Calculates the signal to interference and noise ratio
%   CALC_SNR(SIGNAL, NOISE) returns the SNR for SIGNAL and NOISE, which are
%   of size [CHANNELS SAMPLES].

% Calculate the covariances
signal_cov = cov(signal');
noise_cov = cov(noise');

% Calculate the snr
snr = 10*log10(trace(signal_cov)/trace(noise_cov));

end