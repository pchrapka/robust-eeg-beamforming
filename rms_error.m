function [rms, rms_peak] = rms_error(bf_power, true_peak, poi)

% FIXME
% 1. Calculate the scaling factor over the support of the input signal
% Sum(bf_power)/Sum(input power) = alpha
% 2. Normalize the output power bf_power/alpha
% 3. Calculate the RMSE, i.e. take the sqrt of the sum of squared
% difference between the input and output

% Select all points except the peak
poi(true_peak) = false;

% Calculate the RMS error
rms = sqrt(sum(bf_power(poi).^2)/length(bf_power));
rms_peak = bf_power(true_peak);
end