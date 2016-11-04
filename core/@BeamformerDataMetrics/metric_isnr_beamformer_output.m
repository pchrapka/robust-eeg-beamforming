function [output] = metric_isnr_beamformer_output(obj,varargin)

p = inputParser();
addParameter(p,'location_idx',[],@(x) ~isempty(x) && length(x) == 1);
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@ (x) isvector(x) && length(x) == 1);
parse(p,varargin{:});

if p.Results.average
    result = BeamformerDataMetrics.sinr_beamformer_output(...
        obj.eegdata.avg_signal,...
        obj.eegdata.avg_interference,...
        obj.eegdata.avg_noise,...
        obj.get_W(p.Results.location_idx));
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    
    results = [];
    results(length(p.Results.trial_idx),1).sinr = 0;
    W = obj.get_W(p.Results.location_idx);
    for i=1:length(p.Results.trial_idx)
        idx = p.Results.trial_idx(i);
        results(i) = BeamformerDataMetrics.sinr_beamformer_output(...
            obj.eegdata.interference{idx},...
            obj.eegdata.signal{idx},...
            obj.eegdata.noise{idx},...
            W);
    end
    
    result = [];
    result.sinr = mean([results.sinr]);
    result.sinrdb = mean([results.sinrdb]);
end

output.isnr = result.sinr;
output.isnrdb = result.sinrdb;

output.location_idx = p.Results.location_idx;
output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;

end