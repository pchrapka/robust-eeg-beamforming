function H = beamformer_prep_leadfield(hm,scan_locs)

H = cell(length(scan_locs),1);

for i=1:length(scan_locs)
    idx = scan_locs(i);
    
    % get the leafield matrix from the head model
    H{i} = hm.get_leadfield(idx);
end

end