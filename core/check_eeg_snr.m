function check_eeg_snr(data,varargin)

p = inputParser();
addRequired(p,'data',@(x) isstruct(x) || ischar(x));
addParameter(p,'ntrials',[],@(x) length(x) == 1);
addParameter(p,'average',false,@islogical);
addParameter(p,'coveig',false,@islogical);
parse(p,data,varargin{:});

if ischar(data)
    % data file name
    
    % load data
    din = load(data);
    
    data = din.data;
end

if isempty(p.Results.ntrials)
    if isfield(data,'signal')
        ntrials = length(data.signal);
    else
        ntrials = 1;
    end
else
    ntrials = p.Results.ntrials;
end

% check if we should display snr on average
if p.Results.average
    % check if avg_signal field is missing
    if ~isfield(data,'avg_signal')
        data.avg_signal = zeros(size(data.signal{1}));
        data.avg_noise = zeros(size(data.noise{1}));
        
        ntrials2 = length(data.signal);
        for i=1:ntrials2
            data.avg_signal = data.avg_signal + data.signal{i};
            data.avg_noise = data.avg_noise + data.noise{i};
        end
        data.avg_signal = data.avg_signal/ntrials2;
        data.avg_noise = data.avg_noise/ntrials2;
    end
end

% compute snr
if isfield(data,'avg_signal')
    output = metrics.snr_input(data.avg_signal, data.avg_noise);
    snr = output.snrdb;
    fprintf('snr: %0.4f db from average\n',snr);
end

if isfield(data,'signal')
    for i=1:ntrials
        output = metrics.snr_input(data.signal{i},data.noise{i});
        snr = output.snrdb;
        fprintf('snr: %0.4f db for trial %d\n',snr,i);
    end
end

if p.Results.coveig
    if isfield(data,'Rtime')
        [~,D] = eig(data.Rtime);
        fprintf('covariance eigenvalues:\n');
        d = diag(D);
        d = reshape(d,1,length(d));
        disp(d); 
    end
    if isfield(data,'Rtrial')
        error('coveig not implemented');
    end
end

end