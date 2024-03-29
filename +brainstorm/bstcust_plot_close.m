function bstcust_plot_close()
% Closes all current brainstorm figures

data = load(fullfile('output','bst_current_figs.mat'));
h_fig = data.h_fig;
n_figs = length(h_fig);
for i=1:n_figs
    % Close the first fig
    if h_fig(1) ~= 0 % Skip invalid handles
        try
            close(h_fig(1));
        catch e        
        end
    end
    % Eliminate the first element
    h_fig(1) = [];
end

% Save the current figure handles to a file
save(fullfile('output','bst_current_figs.mat'),'h_fig');

end