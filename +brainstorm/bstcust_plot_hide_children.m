function bstcust_plot_hide_children(handle)
%BSTCUST_PLOT_HIDE_CHILDREN hides all children of HANDLE

fig = get(handle);
for i=1:length(fig.Children)
    child = get(fig.Children(i));
    if ~isequal(child.Tag,'AxesGraph')
        set(fig.Children(i),'visible','off');
    end
end

end