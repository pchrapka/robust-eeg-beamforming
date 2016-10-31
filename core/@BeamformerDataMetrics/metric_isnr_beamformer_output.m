function [output] = metric_isnr_beamformer_output(obj,varargin)

p = inputParser();
addParameter(p,'location_idx',[],@(x) ~isempty(x) && length(x) == 1);
parse(p,varargin{:});

result = BeamformerDataMetrics.sinr_beamformer_output(...
    obj.eegdata.avg_interference,...
    obj.eegdata.avg_signal,...
    obj.eegdata.avg_noise,...
    obj.get_W(p.Results.location_idx));

output.location_idx = p.Results.location_idx;
output.isnr = result.sinr;
output.isnrdb = result.sinrdb;

end