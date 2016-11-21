function A = beamformer_prep_uncertainty(heads,beamformer,scan_locs)

A = cell(length(scan_locs),1);
for i=1:length(scan_locs)
    idx = scan_locs(i);
    % Generate the uncertainty matrix
    A{i} = beamformer.create_uncertainty(...
        heads.actual,...
        heads.current, idx);
end

end