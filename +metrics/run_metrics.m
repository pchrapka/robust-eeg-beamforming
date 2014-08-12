function [output] = run_metrics(cfg)
%
%
%   SNR
%   ---
%   cfg.snr
%       config for metrics.snr with the following fields
%   S
%       signal matrix [channels samples]
%   N
%       noise matrix [channels samples]
%   W
%       spatial filter [channels components]
%
%   Ouput
%   -----
%   returns a struct with the name of the metric


switch cfg.name
    case 'snr'
        % Save some fields
        metric_name = cfg.name;
        % Run the metric
        func = str2func(['metrics.' metric_name]);
        output = func(cfg.(metric_name));
    otherwise
        error('metrics:run_metrics',...
            'unrecognized metric');
end

end