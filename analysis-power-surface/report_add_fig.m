function report_add_fig(report, figure)

fileID = fopen(report.filename, 'a');

fprintf(fileID, figure);

fclose(fileID);

end