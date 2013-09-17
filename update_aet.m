function update_aet()
%UPDATE_AET Updates the current advanced-eeg-toolbox installation
%   UPDATE_AET() updates the current advanced-eeg-toolbox installation

% Save the current directory
cur_dir = pwd;

% Switch to the aet directory
cd '../advanced-eeg-toolbox'

% Reinstall aet
aet_install

% Switch back

cd(cur_dir)

end