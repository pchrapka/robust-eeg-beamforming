function update_aet()
%UPDATE_AET Updates the current advanced-eeg-toolbox installation
%   UPDATE_AET() updates the current advanced-eeg-toolbox installation

% Save the current directory
cur_dir = pwd;

try
    % Switch to the aet directory
    cd '../advanced-eeg-toolbox'
    
    % Reinstall aet
    aet_install
catch e
    warning('reb:update_aet',...
        'Something went wrong');
end

% Switch back

cd(cur_dir)

end