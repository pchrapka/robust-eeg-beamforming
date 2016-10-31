function [output] = metric_snr_input(obj,varargin)

p = inputParser();
parse(p,varargin{:});

output = BeamformerDataMetrics.snr_input(...
    obj.eegdata.avg_signal,...
    obj.eegdata.avg_noise);

end