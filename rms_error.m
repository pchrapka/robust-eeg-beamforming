function [rms, rms_peak] = rms_error(bf_power, true_peak, poi)
% Select all points except the peak
poi(true_peak) = false;

% Calculate the RMS error
rms = sqrt(sum(bf_power(poi).^2)/length(bf_power));
rms_peak = bf_power(true_peak);
end