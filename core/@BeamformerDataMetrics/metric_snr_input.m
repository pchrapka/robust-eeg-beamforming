function [output] = metric_snr_input(obj,varargin)

p = inputParser();
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@isvector);
addParameter(p,'data_idx',[],@isvector);
parse(p,varargin{:});

if isempty(p.Results.data_idx)
    data_idx = 1:size(obj.eegdata.avg_signal,2);
else
    data_idx = p.Results.data_idx;
end

if p.Results.average
    output = BeamformerDataMetrics.snr_input(...
        obj.eegdata.avg_signal(:,data_idx),...
        obj.eegdata.avg_noise(:,data_idx));
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    
    results = [];
    results(length(p.Results.trial_idx),1).snr = 0;
    results(length(p.Results.trial_idx),1).snrdb = 0;
    for i=1:length(p.Results.trial_idx)
        idx = p.Results.trial_idx(i);
        results(i) = BeamformerDataMetrics.snr_input(...
            obj.eegdata.signal{idx}(:,data_idx),...
            obj.eegdata.noise{idx}(:,data_idx));
    end
    
    output = [];
    output.snr = mean([results.snr]);
    output.snrdb = mean([results.snrdb]);
end

output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;
output.data_idx = p.Results.data_idx;

end