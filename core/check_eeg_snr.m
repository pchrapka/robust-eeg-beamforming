function check_eeg_snr(data,varargin)

p = inputParser();
addRequired(p,'data',@(x) isstruct(x) || ischar(x));
addParameter(p,'ntrials',[],@(x) length(x) == 1);
parse(p,data,varargin{:});

if ischar(data)
    % data file name
    
    % load data
    din = load(data);
    
    data = din.data;
end

if isempty(p.Results.ntrials)
    ntrials = length(data.signal);
else
    ntrials = p.Results.ntrials;
end

% compute snr
if isfield(data,'avg_signal')
    snr = aet_analysis_snr(data.avg_signal, data.avg_noise);
    fprintf('snr: %0.2f db from average\n',snr);
end

if isfield(data,'signal')
    for i=1:ntrials
        snr = aet_analysis_snr(data.signal{i},data.noise{i});
        fprintf('snr: %0.2f db for trial %d\n',snr,i);
    end
end

end