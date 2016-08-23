function report_add_heading(report, heading, level)

fileID = fopen(report.filename, 'a');

prefix = '';
for i=1:level
    prefix = [prefix '*'];
end
fprintf(fileID, '%s %s\n\n', prefix, heading);

fclose(fileID);

end