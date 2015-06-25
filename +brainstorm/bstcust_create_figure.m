%% ===== CREATE FIGURE =====
function hFig = bstcust_create_figure() %#ok<DEFNU>

%     % Get renderer name
%     if (bst_get('DisableOpenGL') ~= 1)
%         rendererName = 'opengl';
%     elseif (bst_get('MatlabVersion') <= 803)   % zbuffer was removed in Matlab 2014b
%         rendererName = 'zbuffer';
%     else
%         rendererName = 'painters';
%     end
rendererName = 'opengl';

% === CREATE FIGURE ===
hFig = figure('Visible',       'on', ...
    'NumberTitle',   'off', ...
    'IntegerHandle', 'off', ...
    ...'MenuBar',       'none', ...
    ...'Toolbar',       'none', ...
    'DockControls',  'on', ...
    'Units',         'pixels', ...
    'Color',         [0 0 0], ...
    'Renderer',      rendererName, ...
    'Interruptible', 'off');

% === CREATE AXES ===
hAxes = axes('Parent',   hFig, ...
    'Units',    'normalized', ...
    'Position', [.05 .05 .9 .9], ...
    'Tag',      'Axes3D', ...
    'Visible',  'on', ...
    'Interruptible', 'off');
axis vis3d
axis equal
axis off

% === LIGHTING ===
hl = [];
% Fixed lights
hl(1) = camlight(  0,  40, 'infinite');
hl(2) = camlight(180,  40, 'infinite');
hl(3) = camlight(  0, -90, 'infinite');
hl(4) = camlight( 90,   0, 'infinite');
hl(5) = camlight(-90,   0, 'infinite');
% Moving camlight
hl(6) = light('Tag', 'FrontLight', 'Color', [1 1 1], 'Style', 'infinite', 'Parent', hAxes);
camlight(hl(6), 'headlight');
% Mute the intensity of the lights
for i = 1:length(hl)
    set(hl(i), 'color', .4*[1 1 1]);
end
%     % Camera basic orientation
%     SetStandardView(hFig, 'top');
end