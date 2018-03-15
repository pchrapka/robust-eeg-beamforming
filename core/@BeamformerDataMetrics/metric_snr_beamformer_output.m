function [output] = metric_snr_beamformer_output(obj,varargin)

p = inputParser();
addParameter(p,'location_idx',[],@(x) ~isempty(x) && length(x) == 1);
addParameter(p,'average',true,@islogical);
addParameter(p,'trial_idx',[],@(x) isempty(x) || isvector(x));
addParameter(p,'data_idx',[],@(x) isempty(x) || isvector(x));
parse(p,varargin{:});

do_zero_mean = false;
if isempty(p.Results.data_idx)
    data_idx = 1:size(obj.eegdata.avg_signal,2);
else
    data_idx = p.Results.data_idx;
    do_zero_mean = true;
end

W = obj.get_W(p.Results.location_idx);

if p.Results.average
    
    signal = obj.eegdata.avg_signal;
    noise = obj.eegdata.avg_noise;
    
    if do_zero_mean
        signal = BeamformerDataMetrics.zero_mean(signal);
        noise = BeamformerDataMetrics.zero_mean(noise);
    end
    
    signal = signal(:,data_idx);
    noise = noise(:,data_idx);
    
    output = BeamformerDataMetrics.snr_beamformer_output(...
        signal, noise, W, 'ZeroMean', do_zero_mean);
else
    if isempty(p.Results.trial_idx)
        error('trial_idx is required');
    end
    
    results = [];
    results(length(p.Results.trial_idx),1).snr = 0;
    results(length(p.Results.trial_idx),1).snrdb = 0;
    results(length(p.Results.trial_idx),1).niterations = [];
    
    for i=1:length(p.Results.trial_idx)
        idx = p.Results.trial_idx(i);
        signal = obj.eegdata.signal{idx};
        noise = obj.eegdata.noise{idx};
        
        if do_zero_mean
            signal = BeamformerDataMetrics.zero_mean(signal);
            noise = BeamformerDataMetrics.zero_mean(noise);
        end
        
        signal = signal(:,data_idx);
        noise = noise(:,data_idx);
        
        results(i) = BeamformerDataMetrics.snr_beamformer_output(...
            signal, noise,W, 'ZeroMean', do_zero_mean);
    end
    
    output = [];
    output.snr = mean([results.snr]);
    if ~isscalar(output.snr)
        error('something went wrong here');
    end
    output.snrdb = mean([results.snrdb]);
end

output.location_idx = p.Results.location_idx;
output.average = p.Results.average;
output.trial_idx = p.Results.trial_idx;
output.data_idx = p.Results.data_idx;

end