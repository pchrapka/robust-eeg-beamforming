function [name, line_stye] = get_beamformer_plot_style(name)

% Set line style based on bf name
if ~isempty(strfind(name, 'rmv'))
    line_stye = '--';
elseif ~isempty(strfind(name, 'lcmv_eig'))
    line_stye = ':';
else
    line_stye = '-';
end
% Fix the legend label
name = util.fix_label(name);

end