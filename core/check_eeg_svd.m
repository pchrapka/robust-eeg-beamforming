function check_eeg_svd(data,varargin)

p = inputParser();
addRequired(p,'data',@(x) isstruct(x) || ischar(x));
addParameter(p,'eig',true,@islogical);
addParameter(p,'neig',5,@(x) isvector(x) && length(x) == 1);
addParameter(p,'sample',[],@(x) isvector(x) && length(x) == 1);
addParameter(p,'projection',false,@islogical);
addParameter(p,'nint',[],@(x) isvector(x) && length(x) == 1);
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
    if isempty(p.Results.sample)
        error('sample parameter is required');
    else
        R = squeeze(data.Rtrial(p.Results.sample,:,:));
    end
end

if p.Results.eig
    [~,D] = eig(R);
    
    fprintf('covariance eigenvalues:\n');
    d = diag(D);
    d = sortrows(d,-1); % sort from largest to smallest
    d(p.Results.neig+1:end) = []; % get rid of extras
    d = reshape(d,1,length(d));
    disp(d);
end

fprintf('condition number:\n');
disp(cond(R));

fprintf('\n');

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
        
        fprintf('condition number:\n');
        disp(cond(PR));
    end
end

end
    

