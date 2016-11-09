function [output] = metric_sinr_beamformer_output(obj,varargin)

p = inputParser();
addParameter(p,'location_idx',[],@(x) ~isempty(x) && length(x) == 1);
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
    output = BeamformerDataMetrics.sinr_beamformer_output(...
        obj.eegdata.avg_signal(:,data_idx),...
        obj.eegdata.avg_interference(:,data_idx),...
        obj.eegdata.avg_noise(:,data_idx),...
        obj.get_W(p.Results.location_idx));
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    
%     W = obj.get_W(p.Results.location_idx);
%     signal = [obj.eegdata.signal{p.Results.trial_idx}];
%     interference = [obj.eegdata.interference{p.Results.trial_idx}];
%     noise = [obj.eegdata.noise{p.Results.trial_idx}];
%     
%     results = BeamformerDataMetrics.sinr_beamformer_output(...
%         signal,...
%         interference,...
%         noise,...
%         W);
%     
%     output =  results;
    
    
    results = [];
    results(length(p.Results.trial_idx),1).sinr = 0;
    results(length(p.Results.trial_idx),1).sinrdb = 0;
    W = obj.get_W(p.Results.location_idx);
    for i=1:length(p.Results.trial_idx)
        idx = p.Results.trial_idx(i);
        results(i) = BeamformerDataMetrics.sinr_beamformer_output(...
            obj.eegdata.signal{idx}(:,data_idx),...
            obj.eegdata.interference{idx}(:,data_idx),...
            obj.eegdata.noise{idx}(:,data_idx),...
            W);
    end
    
    output = [];
    output.sinr = mean([results.sinr]);
    output.sinrdb = mean([results.sinrdb]);
end

output.location_idx = p.Results.location_idx;
output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;
output.data_idx = p.Results.data_idx;

end