function [rmse, rms_input] = rms_error(bf_mag, input_mag)
%RMS_ERROR calculates the RMS error between the beamformer output magnitude
%and the input magnitude
%   RMS_ERROR(BF_MAG, INPUT_POWER) returns the RMS error between the
%   beamformer output magnitude and the input magnitude. It ignores scaling
%   differences by normalizing the beamformer output power by the input
%   power. The normalizing constant is calculated only over the support of
%   the input power.
%   
%   See also RMS_SINGLE_BF, RMS_DISTR_BF, RMS_MULT_BF

% Make sure they're both column vectors
bf_mag = bf_mag(:);
input_mag = input_mag(:);

% Calculate the normalizing factor by least squares
% i.e. minimize the 2-norm between both signals
alpha = (input_mag'*bf_mag)/(bf_mag'*bf_mag);

% Normalize the output power
bf_mag_norm = bf_mag*alpha;

% Calculate the RMSE
error_signal = bf_mag_norm - input_mag;
rmse = sqrt(sum(error_signal.^2)/length(error_signal));

% Calculate the RMS of the input
rms_input = sqrt(sum(input_mag.^2)/length(input_mag));

end