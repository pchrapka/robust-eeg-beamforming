function [sel] = select_points(points, value, margin)
%SELECT_POINTS selects points near a particular point, not inclusive

above = points > (value - margin);
below = points < (value + margin);

sel = above & below;

end