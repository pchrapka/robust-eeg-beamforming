function [output] = metric_snr_input(obj,varargin)

p = inputParser();
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@ (x) isvector(x) && length(x) == 1);
parse(p,varargin{:});

if p.Results.average
    output = BeamformerDataMetrics.snr_input(...
        obj.eegdata.avg_signal,...
        obj.eegdata.avg_noise);
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    
    results = [];
    results(length(p.Results.trial_idx),1).snr = 0;
    W = obj.get_W(p.Results.location_idx);
    for i=1:length(p.Results.trial_idx)
        idx = p.Results.trial_idx(i);
        results(i) = BeamformerDataMetrics.snr_input(...
            obj.eegdata.signal{idx},...
            obj.eegdata.noise{idx});
    end
    
    output = [];
    output.snr = mean([results.snr]);
    output.snrdb = mean([results.snrdb]);
end

output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;

end