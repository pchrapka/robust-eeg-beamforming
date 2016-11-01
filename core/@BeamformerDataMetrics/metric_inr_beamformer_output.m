function [output] = metric_inr_beamformer_output(obj,varargin)

p = inputParser();
addParameter(p,'location_idx',[],@(x) ~isempty(x) && length(x) == 1);
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@ (x) isvector(x) && length(x) == 1);
parse(p,varargin{:});

if p.Results.average
    results = BeamformerDataMetrics.snr_beamformer_output(...
        obj.eegdata.avg_interference,...
        obj.eegdata.avg_noise,...
        obj.get_W(p.Results.location_idx));
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    results = BeamformerDataMetrics.snr_beamformer_output(...
        obj.eegdata.interference{p.Results.trial_idx},...
        obj.eegdata.noise{p.Results.trial_idx},...
        obj.get_W(p.Results.location_idx));
end

output.inr = results.snr;
output.inrdb = results.snrdb;
output.location_idx = p.Results.location_idx;
output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;

end