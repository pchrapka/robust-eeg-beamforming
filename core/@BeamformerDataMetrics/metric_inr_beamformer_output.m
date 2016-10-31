function [output] = metric_inr_beamformer_output(obj,varargin)

p = inputParser();
addParameter(p,'location_idx',[],@(x) ~isempty(x) && length(x) == 1);
parse(p,varargin{:});

results = BeamformerDataMetrics.snr_beamformer_output(...
    obj.eegdata.avg_interference,...
    obj.eegdata.avg_noise,...
    obj.get_W(p.Results.location_idx));

output.inr = results.snr;
output.inrdb = results.snrdb;
output.location_idx = p.Results.location_idx;

end