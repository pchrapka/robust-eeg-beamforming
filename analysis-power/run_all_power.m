force = false;
% Calculate power of data
mismatch = false;
experiment_power(mismatch, force);
mismatch = true;
experiment_power(mismatch, force);

% Import power data to Brainstorm and plot power on surface
close all
mismatch = false;
import_power(mismatch);
mismatch = true;
import_power(mismatch);

% Save images with power plotted on cortical surface
mismatch = false;
save_power(mismatch);
mismatch = true;
save_power(mismatch);

% Plot power surface
% plot_power