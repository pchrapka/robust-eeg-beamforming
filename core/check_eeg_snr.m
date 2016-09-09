function check_eeg_snr(data)

p = inputParser();
addRequired(p,'data',@(x) isstruct(x) || ischar(x));
parse(p,data);

if ischar(data)
    % data file name
    
    % load data
    din = load(data);
    
    data = din.data;
end

% compute snr
if isfield(data,'avg_signal')
    snr = aet_analysis_snr(data.avg_signal, data.avg_noise);
    fprintf('snr: %0.2f db from average\n',snr);
end

if isfield(data,'signal')
    for i=1:length(data.signal)
        snr = aet_analysis_snr(data.signal{i},data.noise{i});
        fprintf('snr: %0.2f db for trial %d\n',snr,i);
    end
end

end