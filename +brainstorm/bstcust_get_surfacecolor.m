function surface_color = bstcust_get_surfacecolor(tess, data)

% Default colors
DEFAULT_CMAP_SIZE = 64;
surface_cmap = jet(DEFAULT_CMAP_SIZE);

anatomy_color = [...
    0.45 0.45 0.45;...
    0.6  0.6  0.6];

% Data options
data_limit = [min(data) max(data)];
data_alpha = 0;

% EdgeColor = 'none';

% Get data colors
surface_color = BlendAnatomyData(tess.SulciMap, anatomy_color,...
    data, data_limit, data_alpha, surface_cmap);

end

%% ===== BLEND ANATOMY DATA =====
% Compute the RGB color values for each vertex of an enveloppe.
% INPUT:
%    - SulciMap     : [nVertices] vector with 0 or 1 values (0=gyri, 1=sulci)
%    - Data         : [nVertices] vector 
%    - DataLimit    : [absMaxVal] or [minVal, maxVal], or []
%    - DataAlpha    : Transparency value for the data (if alpha=0, we only see the anatomy color)
%    - AnatomyColor : [2x3] colors for anatomy (sulci / gyri)
%    - sColormap    : Colormap for the data
% OUTPUT:
%    - mixedRGB     : [nVertices x 3] RGB color value for each vertex
function mixedRGB = BlendAnatomyData(SulciMap, AnatomyColor, Data, DataLimit, DataAlpha, sColormap)
    % Create a background: light 1st color for gyri, 2nd color for sulci
    anatRGB = AnatomyColor(2-SulciMap, :);
    % === OVERLAY: DATA MAP ===
    if ~isempty(Data) && (length(DataLimit) == 2) && (DataLimit(2) ~= DataLimit(1)) && ~any(isnan(DataLimit)) && ~any(isinf(DataLimit))
        iDataCmap = round( ((size(sColormap.CMap,1)-1)/(DataLimit(2)-DataLimit(1))) * (Data - DataLimit(1))) + 1;
        iDataCmap(iDataCmap <= 0) = 1;
        iDataCmap(iDataCmap > size(sColormap.CMap,1)) = size(sColormap.CMap,1);
        dataRGB = sColormap.CMap(iDataCmap, :);
    else
        dataRGB = [];
    end
    % === MIX ANATOMY/DATA RGB ===
    mixedRGB = anatRGB;
    if ~isempty(dataRGB)
        toBlend = find(Data ~= 0); % Find vertex indices holding non-zero activation (after thresholding)
        mixedRGB(toBlend,:) = DataAlpha * anatRGB(toBlend,:) + (1-DataAlpha) * dataRGB(toBlend,:);
    end
end