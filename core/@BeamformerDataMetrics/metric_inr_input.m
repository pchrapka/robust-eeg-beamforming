function [output] = metric_inr_input(obj,varargin)

p = inputParser();
parse(p,varargin{:});

result = BeamformerDataMetrics.snr_input(...
    obj.eegdata.avg_interference,...
    obj.eegdata.avg_noise);

output.inr = result.snr;
output.inrdb = result.snrdb;

end