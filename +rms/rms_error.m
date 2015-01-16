function [rmse, rms_input, alpha] = rms_error(bf_out, input)
%RMS_ERROR calculates the RMS error between the beamformer output and the
%input
%   RMS_ERROR(BF_OUT, INPUT) returns the RMS error between the
%   beamformer output and the input. It ignores scaling differences by
%   normalizing the beamformer output power by the input power. The
%   normalizing constant is calculated only over the support of the input
%   power.
%   BF_OUT and INPUT are of size [location/time components] where
%   components can be a single component.
%
%   RMSE is the root mean squared error of the normalized output for each
%   component. RMS_INPUT is the power of the input for each component.
%   
%   See also RMS_SINGLE_BF, RMS_DISTR_BF, RMS_MULT_BF

if isvector(bf_out) && isvector(input)
    % Make sure they're both column vectors
    bf_out = bf_out(:);
    input = input(:);
end

% Calculate the power of the signals
% The only reason for this step is so that we perform the least squares
% fit over the power of the signal instead of the amplitude itself, to
% avoid the normalization factor from flipping the sign
bf_pow = sqrt(sum(bf_out.^2,2));
input_pow = sqrt(sum(input.^2,2));

% Calculate the support of the input
select = input_pow > 0;
if sum(select) == 0
    % Display an error if the signal is 0
    warning('rms:rms_error',...
        ['the input signal is 0, cannot determine a reference '...
        'for normalization']);
end

% Calculate the normalizing factor by least squares
% i.e. minimize the 2-norm between both signals
alpha = (input_pow(select)'*bf_pow(select))...
    /(bf_pow(select)'*bf_pow(select));

% Normalize the output power
bf_out_norm = bf_out*alpha;

% Calculate the RMSE
error_signal = bf_out_norm - input;
rmse = sqrt(sum(error_signal.^2)/length(error_signal));

% Calculate the RMS of the input
rms_input = sqrt(sum(input.^2)/length(input));



end