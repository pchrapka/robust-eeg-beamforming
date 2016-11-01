function check_eeg_svd(data,varargin)

p = inputParser();
addRequired(p,'data',@(x) isstruct(x) || ischar(x));
addParameter(p,'neig',5,@(x) isvector(x) && length(x) == 1);
addParameter(p,'reg',false,@islogical);
addParameter(p,'samples',[],@isvector);
addParameter(p,'projection',false,@islogical);
addParameter(p,'nint',[],@(x) isvector(x) && length(x) == 1);
addParameter(p,'SignalComponents',{'none'},@(x) any(validatestring(x,{'signal','interference','none'})));
parse(p,data,varargin{:});

if ischar(data)
    % data file name
    
    % load data
    din = load(data);
    
    data = din.data;
end

if isfield(data,'Rtime')
    R = data.Rtime;
end

if isfield(data,'Rtrial')
    if isempty(p.Results.samples)
        error('sample parameter is required');
    else
        R = data.Rtrial(p.Results.samples,:,:);
        R = mean(R,1); % [1 channels channels]
        R = squeeze(R);
    end
end

if p.Results.reg
    % set up lambda
    cfg = [];
    cfg.R = R;
    cfg.type = 'eig';
    cfg.multiplier = 0.005;
    lambda = aet_analysis_beamform_get_lambda(cfg);
    
    % add to covariance
    R = R + lambda*eye(size(R));
end

if p.Results.projection
    fprintf('Projection\n');
    fprintf('----------\n');
    
    if isempty(p.Results.nint)
        error('nint parameter is required');
    else
        cfg = [];
        cfg.R = R;
        cfg.n_interfering_sources = p.Results.nint;
        P = aet_analysis_eig_projection(cfg);
        
        PR = P*R;
        
        print_stats(PR,p.Results.neig);
    end
else
    fprintf('Original Covariance\n');
    fprintf('----------\n');
    
    print_stats(R,p.Results.neig);
end

for i=1:length(p.Results.SignalComponents)
    sigcomp = p.Results.SignalComponents{i};
    if ~isequal(sigcomp,'none')
        Rsigcomp = aet_analysis_cov(data.(sigcomp));
        
        fprintf('Covariance of %s\n',sigcomp);
        fprintf('---------------------\n');
        
        print_stats(Rsigcomp,p.Results.neig);
    end

end
end

function print_stats(R,neig)
fprintf('eigenvalues:\n');
print_eig(R,neig);

fprintf('condition number:\n');
disp(cond(R));

fprintf('condition number inverse:\n');
disp(cond(pinv(R)));

% https://en.wikipedia.org/wiki/Moore%E2%80%93Penrose_pseudoinverse
fprintf('condition number 2 :\n');
disp(norm(R)*norm(pinv(R)));
% not convinced on this one

fprintf('rank:\n');
disp(rank(R));
end

function print_eig(R,neig)
[~,D] = eig(R);
d = diag(D);
d = sortrows(d,-1); % sort from largest to smallest
d(neig+1:end) = []; % get rid of extras
d = reshape(d,1,length(d));
disp(d);
end
    

