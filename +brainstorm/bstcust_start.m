function bstcust_start()
%BSTCUST_START starts Brainstorm
%   BSTCUST_START starts Brainstorm in its directory and returns to the
%   current directory. It also checks if Brainstorm is already running.

try
    % Try running a Brainstorm function
    bst_get('Version');
    disp('Brainstorm is already running');
catch e
    % If there is an exception thrown, then it's probably not running

    % Save the current dir
    cur_dir = pwd;
    % Switch to get Brainstorm directory
    cd(brainstorm.bstcust_getdir('exe'));
    
    % Start brainstorm
    brainstorm
    
    % Go back to the current dir
    cd(cur_dir);    
end

end