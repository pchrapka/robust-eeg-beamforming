function [output] = metric_inr_input(obj,varargin)

p = inputParser();
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@ (x) isvector(x) && length(x) == 1);
parse(p,varargin{:});

if p.Results.average
    result = BeamformerDataMetrics.snr_input(...
        obj.eegdata.avg_interference,...
        obj.eegdata.avg_noise);
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    result = BeamformerDataMetrics.snr_input(...
        obj.eegdata.interference{p.Results.trial_idx},...
        obj.eegdata.noise{p.Results.trial_idx});
end

output.inr = result.snr;
output.inrdb = result.snrdb;

output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;

end