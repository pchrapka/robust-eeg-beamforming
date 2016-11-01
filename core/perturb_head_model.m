%% peturb head model

hm_names = {'head_Default1_bem_500V.mat','head_Default1_bem_15028V.mat'};

percent_err = 0.1;
for i=1:length(hm_names)
    hmfactory = HeadModel();
    hm = hmfactory.createHeadModel('brainstorm',hm_names{i});
    hm.load();
    
    % find average lead field size
    lf_norm = zeros(hm.get_numvertices(),1);
    parfor j=1:hm.get_numvertices()
        lf_norm(j) = norm(hm.get_leadfield(j),'fro');
    end
    lf_mean = mean(lf_norm);
    
    % perturb each gain matrix
    hm_new = hm.data;
    sigma = lf_mean*percent_err/3;
    fprintf('sigma: %g\n',sigma);
    for j=1:hm.get_numvertices()
        old_gain = hm.get_leadfield(j);
        perturb = rand(size(old_gain))*sigma;
        
        idx = (j-1)*3+1;
        hm_new.Gain(:,idx:(idx+3-1)) = old_gain + perturb;
    end
    
    % save the new model
    [pathstr,name,ext] = fileparts(hm.datafilename);
    outfile = fullfile(pathstr,sprintf('%s_perturb%0.2f%s',name,percent_err,ext));
    fprintf('saving to %s\n',outfile);
    head = hm_new;
    save(outfile,'head');
end