function [output] = rmse(cfg)
%RMSE calculates the RMS error between the beamformer output and the
%input
%   RMSE(BF_OUT, INPUT) returns the RMS error between the
%   beamformer output and the input. It ignores scaling differences by
%   normalizing the beamformer output power by the input power. The
%   normalizing constant is calculated only over the support of the input
%   power.
%   
%   cfg.bf_out
%       [location/time components] where components can be a single
%       component
%   cfg.input
%       [location/time components] where components can be a single
%       component
%   cfg.normalize
%       string with normalization method: lspow, ls, none. default = none
%       lspow
%           normalizes based on least square error of power
%       ls
%           normalizes based on least square error of signal
%           NOTE Not quite right
%       fnorm
%           normalizes based on frobenius norm of signal
%   cfg.alpha
%       (optional) custom normalization factor for bf_out, default = none
%
%   Output
%   ------
%   output.rmse_x
%   output.rmse_y
%   output.rmse_z
%       the root mean squared error of the normalized output for each
%       component
%   output.rmsedb_x
%   output.rmsedb_y
%   output.rmsedb_z
%       rmse in dB
%   output.rmse_alpha
%       normalizing constant
%
%   output.rms_input_x  (deprecated)
%   output.rms_input_y
%   output.rms_input_z
%       power of the input for each component

% Set defaults
if ~isfield(cfg, 'normalize'), cfg.normalize = 'none'; end


if isvector(cfg.bf_out) && isvector(cfg.input)
    % Make sure they're both column vectors
    bf_out = cfg.bf_out(:);
    input = cfg.input(:);
else
    bf_out = cfg.bf_out;
    input = cfg.input;
end

% Check if we're doing a custom normalization
if isfield(cfg, 'alpha')
    % Apply a custom normalization factor
    alpha = cfg.alpha;
    % Normalize the output power
    bf_out_norm = bf_out*alpha;
    
else
    
    % Check if we should normalize the beamformer output
    switch cfg.normalize
        
        case 'lspow'
            % Calculate the power of the signals
            % The only reason for this step is so that we perform the least squares
            % fit over the power of the signal instead of the amplitude itself, to
            % avoid the normalization factor from flipping the sign
            bf_pow = sqrt(sum(bf_out.^2,2));
            input_pow = sqrt(sum(input.^2,2));
            
            % % Calculate the support of the input
            % select = input_pow > 0;
            % if sum(select) == 0
            %     % Display an error if the signal is 0
            %     warning('metrics:rmse',...
            %         ['the input signal is 0, cannot determine a reference '...
            %         'for normalization']);
            % end
            
            % Calculate the normalizing factor by least squares
            % i.e. minimize the 2-norm between both signals
            alpha = (input_pow'*bf_pow)...
                /(bf_pow'*bf_pow);
            
            % Normalize the output power
            bf_out_norm = bf_out*alpha;
            
        case 'pow'
            % Take norm of components
            bf_norm = sqrt(sum(bf_out.^2,2)); 
            input_norm = sqrt(sum(input.^2,2));
            
            % Calculate power
            bf_pow = sqrt(sum(bf_norm.^2));
            input_pow = sqrt(sum(input_norm.^2));
            
            % Calculate the ratio between them
            alpha = input_pow/bf_pow;
            
            % Normalize the output power
            bf_out_norm = bf_out*alpha;            
            
        case 'ls'
            % Calculate the normalizing factor by least squares
            % i.e. minimize the 2-norm between both signals
            alpha = pinv(bf_out'*bf_out)*bf_out'*input;
            
            % NOTE This doesn't really work as I wanted it to
            
            % Normalize the output power
            bf_out_norm = bf_out*alpha;
            
        case 'fnorm'
            
            % Calculate the normalizing factor by f norm
            alpha = norm(input, 'fro')/norm(bf_out, 'fro');
            
            % Normalize the output power
            bf_out_norm = bf_out*alpha;
            
        case 'none'
            bf_out_norm = bf_out;
        otherwise
            error(['reb:' mfilename],...
                'unknown normalization option %s\n', cfg.normalize);
    end
end

% Calculate the RMSE
error_signal = bf_out_norm - input;
rmse = sqrt(sum(error_signal.^2)/length(error_signal));
rmsedb = 20*log10(rmse);

if length(rmse) == 3
    output.rmse_x = rmse(1);
    output.rmse_y = rmse(2);
    output.rmse_z = rmse(3);
else
    warning('metrics:rmse',...
        ['not sure how to output the rmse, size: '...
        num2str(size(rmse,1)) ',' num2str(size(rmse,2))]);
end

if length(rmsedb) == 3
    output.rmsedb_x = rmsedb(1);
    output.rmsedb_y = rmsedb(2);
    output.rmsedb_z = rmsedb(3);
else
    warning('metrics:rmse',...
        ['not sure how to output the rmsedb, size: '...
        num2str(size(rmsedb,1)) ',' num2str(size(rmsedb,2))]);
end

% % Calculate the RMS of the input
% rms_input = sqrt(sum(input.^2)/length(input));
% 
% if length(rms_input) == 3
%     output.rms_input_x = rms_input(1);
%     output.rms_input_y = rms_input(1);
%     output.rms_input_z = rms_input(1);
% else
%     warning('metrics:rmse',...
%         ['not sure how to output the rms_input, size: '...
%         num2str(size(rms_input,1)) ',' num2str(size(rms_input,2))]);
% end

output.rmse_alpha = alpha;

end