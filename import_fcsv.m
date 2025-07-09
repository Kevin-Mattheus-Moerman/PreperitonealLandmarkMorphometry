function V=import_fcsv(fileName)

% function V=import_fcsv(fileName)
% ------------------------------------------------------------------------
% This function imports the fcsv file specified by the fileName and reads
% the coordinates of the landmarks into a vertex array V. 
% 
% 
% Kevin Mattheus Moerman, 2019/04/26 
% ------------------------------------------------------------------------

%%

% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 14);

% Specify range and delimiter
opts.DataLines = [4, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "x", "y", "z", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14"];
opts.SelectedVariableNames = ["x", "y", "z"];
opts.VariableTypes = ["string", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [1, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data table
dataTable = readtable(fileName, opts);

% Convert to output type
V = table2array(dataTable);

