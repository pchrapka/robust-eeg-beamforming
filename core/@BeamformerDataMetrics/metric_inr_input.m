function [output] = metric_inr_input(obj,varargin)

p = inputParser();
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@ (x) isvector(x));
addParameter(p,'trial_idx',[],@(x) isempty(x) || isvector(x));
addParameter(p,'data_idx',[],@(x) isempty(x) || isvector(x));
parse(p,varargin{:});

if isempty(p.Results.data_idx)
    data_idx = 1:size(obj.eegdata.avg_signal,2);
else
    data_idx = p.Results.data_idx;
end

if p.Results.average
    signal = obj.eegdata.avg_interference;
    noise = obj.eegdata.avg_noise;
    
    if do_zero_mean
        signal = BeamformerDataMetrics.zero_mean(signal);
        noise = BeamformerDataMetrics.zero_mean(noise);
    end
    
    signal = signal(:,data_idx);
    noise = noise(:,data_idx);
    
    output = BeamformerDataMetrics.snr_input(...
        signal, noise, 'ZeroMean', do_zero_mean);
    
    output.inr = result.snr;
    output.inrdb = result.snrdb;
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    
    results = [];
    results(length(p.Results.trial_idx),1).snr = 0;
    results(length(p.Results.trial_idx),1).snrdb = 0;
    for i=1:length(p.Results.trial_idx)
        idx = p.Results.trial_idx(i);
        signal = obj.eegdata.interference{idx};
        noise = obj.eegdata.noise{idx};
        
        if do_zero_mean
            signal = BeamformerDataMetrics.zero_mean(signal);
            noise = BeamformerDataMetrics.zero_mean(noise);
        end
        
        signal = signal(:,data_idx);
        noise = noise(:,data_idx);
        
        results(i) = BeamformerDataMetrics.snr_input(...
            signal,noise,'ZeroMean',do_zero_mean);
    end
    
    result = [];
    result.snr = mean([results.snr]);
    result.snrdb = mean([results.snrdb]);
end

output.inr = result.snr;
output.inrdb = result.snrdb;

output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;
output.data_idx = p.Results.data_idx;

end