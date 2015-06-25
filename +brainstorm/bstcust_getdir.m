function [bstdir] = bstcust_getdir(type)
%BSTCUST_GETDIR returns the Brainstorm directory
%   BSTCUST_GETDIR(TYPE) returns the Brainstorm directory
%   type
%       'exe'
%       'db'

switch type
    case 'exe'
        bstfolder = 'brainstorm3';
    case 'db'
        bstfolder = 'brainstorm_db';
    otherwise
        error(['reb:' mfilename],...
            'unknown type %s', type);
end

% Check pc or linux
if ispc
    bstdir = ['C:\Users\Phil\Documents\MATLAB\' bstfolder];
elseif isunix
    % Check the system name
    [~,comp_name] = system('hostname');
    if ~isempty(strfind(comp_name,'Valentina'))
        bstdir = ['/home/phil/Documents/MATLAB/' bstfolder];
    else
        bstdir = ['/home/chrapkpk/Documents/MATLAB/' bstfolder];
    end
else
    error(['reb:' mfilename],...
        'unknown os');
end

end