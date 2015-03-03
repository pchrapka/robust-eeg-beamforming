% test_select_points

points = 1:20;
value = 5;
margin = 2;

selection = select_points(points, value, margin);

disp(points(selection));