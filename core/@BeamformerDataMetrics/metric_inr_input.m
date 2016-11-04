function [output] = metric_inr_input(obj,varargin)

p = inputParser();
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@ (x) isvector(x));
parse(p,varargin{:});

if p.Results.average
    result = BeamformerDataMetrics.snr_input(...
        obj.eegdata.avg_interference,...
        obj.eegdata.avg_noise);
    
    output.inr = result.snr;
    output.inrdb = result.snrdb;
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    
    results = [];
    results(length(p.Results.trial_idx),1).snr = 0;
    for i=1:length(p.Results.trial_idx)
        idx = p.Results.trial_idx(i);
        results(i) = BeamformerDataMetrics.snr_input(...
            obj.eegdata.interference{idx},...
            obj.eegdata.noise{idx});
    end
    
    result = [];
    result.snr = mean([results.snr]);
    result.snrdb = mean([results.snrdb]);
end

output.inr = result.snr;
output.inrdb = result.snrdb;

output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;

end