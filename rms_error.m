function [rmse, rms_input] = rms_error(bf_power, input_power)
%RMS_ERROR calculates the RMS error between the beamformer output power and
%the input power
%   RMS_ERROR(BF_POWER, INPUT_POWER) returns the RMS error between the
%   beamformer output power and the input power. It ignores scaling
%   differences by normalizing the beamformer output power by the input
%   power. The normalizing constant is calculated only over the support of
%   the input power.
%   
%   See also RMS_SINGLE_BF, RMS_DISTR_BF, RMS_MULT_BF

% Make sure they're both column vectors
bf_power = bf_power(:);
input_power = input_power(:);

% Select the non zero entries of input_power
non_zero = input_power > 0;

% Calculate the normalizing factor
alpha = sum(bf_power(non_zero))/sum(input_power(non_zero));

% Normalize the output power
bf_power_norm = bf_power/alpha;

% Calculate the RMSE
error = bf_power_norm - input_power;
rmse = sqrt(sum(error.^2)/length(error));

% Calculate the RMS of the input
rms_input = sqrt(sum(input_power.^2)/length(input_power));

end