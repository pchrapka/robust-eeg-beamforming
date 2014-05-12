function [rmse, rms_input] = rms_error(bf_power, input_power)

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