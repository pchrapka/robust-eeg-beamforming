function [output] = metric_snr_beamformer_output(obj,varargin)

p = inputParser();
addParameter(p,'location_idx',[],@(x) ~isempty(x) && length(x) == 1);
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@(x) isempty(x) || isvector(x));
addParameter(p,'data_idx',[],@(x) isempty(x) || isvector(x));
parse(p,varargin{:});

if isempty(p.Results.data_idx)
    data_idx = 1:size(obj.eegdata.avg_signal,2);
else
    data_idx = p.Results.data_idx;
end

if p.Results.average
    
    output = BeamformerDataMetrics.snr_beamformer_output(...
        obj.eegdata.avg_signal(:,data_idx),...
        obj.eegdata.avg_noise(:,data_idx),...
        obj.get_W(p.Results.location_idx));
    else
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    
    results = [];
    results(length(p.Results.trial_idx),1).snr = 0;
    results(length(p.Results.trial_idx),1).snrdb = 0;
    W = obj.get_W(p.Results.location_idx);
    for i=1:length(p.Results.trial_idx)
        idx = p.Results.trial_idx(i);
        results(i) = BeamformerDataMetrics.snr_beamformer_output(...
            obj.eegdata.signal{idx}(:,data_idx),...
            obj.eegdata.noise{idx}(:,data_idx),...
            W);
    end
    
    output = [];
    output.snr = mean([results.snr]);
    output.snrdb = mean([results.snrdb]);
end

output.location_idx = p.Results.location_idx;
output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;
output.data_idx = p.Results.data_idx;

end