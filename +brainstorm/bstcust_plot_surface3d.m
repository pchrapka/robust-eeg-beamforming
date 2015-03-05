function varargout = bstcust_plot_surface3d( hFig, faces, verts, surface_color, transparency)
%bstcust_plot_surface3d Convenient function to consistently plot surfaces.
% USAGE : [hFig,hs] = bstcust_plot_surface3d(hFig, faces, verts, cdata, dataCMap, transparency)
% Parameters :
%     - hFig         : figure handle to use
%     - faces        : the triangle listing (array)
%     - verts        : the corresponding vertices (array)
%     - surface_color : color data used to display the surface itself (FaceVertexCData for each vertex, or a unique color for all vertices)
%     - transparency : surface transparency ([0,1])
% Returns :
%     - hFig : figure handle used
%     - hs   : handle to the surface
%
% Source: Low level function copied from Brainstorm

    % Check inputs
    if (nargin ~= 5)
        error('Invalid call to bstcust_plot_surface3d');
    end
    % If vertices are assumed transposed (if the assumption is wrong, will crash below anyway)
    if (size(verts,2) > 3)
        verts = verts';
    end
    % If vertices are assumed transposed (if the assumption is wrong, will crash below anyway)
    if (size(faces,2) > 3)
        faces = faces';  
    end
    % Surface color
    if (length(surface_color) == 3)
        FaceVertexCData = [];
        FaceColor = surface_color;
        EdgeColor = 'none';
    elseif (length(surface_color) == length(verts))
        FaceVertexCData = surface_color;
        FaceColor = 'interp';
        EdgeColor = 'interp';
    else
        error('Invalid surface color.');
    end
    % Set figure as current
    set(0, 'CurrentFigure', hFig);
    
    % Create patch
    hs = patch(...
        'Faces',            faces, ...
        'Vertices',         verts,...
        'FaceVertexCData',  FaceVertexCData, ...
        'FaceColor',        FaceColor, ...
        'FaceAlpha',        1 - transparency, ...
        'AlphaDataMapping', 'none', ...
        'EdgeColor',        EdgeColor, ...
        'BackfaceLighting', 'lit', ...
        'AmbientStrength',  0.5, ...
        'DiffuseStrength',  0.5, ...
        'SpecularStrength', 0.2, ...
        'SpecularExponent', 1, ...
        'SpecularColorReflectance', 0.5, ...
        'FaceLighting',     'gouraud', ...
        'EdgeLighting',     'gouraud', ...
        'Tag',              'AnatSurface');
    
    % Set output variables
    if(nargout>0),
        varargout{1} = hFig;
        varargout{2} = hs;
    end
end