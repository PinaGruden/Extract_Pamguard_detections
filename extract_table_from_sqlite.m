function [results]= extract_table_from_sqlite(dbname,tablename,S)
%function extract_table_from_sqlite.m extracts a specified table from a
%sqlite3 database, coverts date and time column to datetime format and
%saves (if selected) the table to a csv file

%Inputs:
%   -dbname = name of the database (a string vector),
%   -tablename = name of the table to be extracted (a string vector),
%   -S= structure that specifies saving parameters
%       ~S.s - if set to 1 the extracted table is saved as a csv file
%       ~S.path - specifies folder where the results should be saved

%Outputs:
%   -results = extracted table with corrected date and time format 


% % Import sqlite3 database into Matlab (bloody painful) and save csv:
% % Need to use an external package - matlab-sqlite3-driver
% % See instructions for its installation in the Readme in the package folder
% % after it's installed properly (and its dependent compliers), do:
% addpath 'C:\Users\Pina\Dropbox\Pina\HAWAII\MATLAB\Code\matlab-sqlite3-driver'

if nargin<3
    S.s=0; %default is not to save csv file
end

database = sqlite3.open(dbname); %path to the database
results = sqlite3.execute(database, ['SELECT * FROM ',tablename]); %select the table you want

results = struct2table(results); %convert to a table
%change all the date time from string to datetime format (that Matlab
%understands):
results.UTC=datetime(results.utc,'InputFormat','yyyy-MM-dd HH:mm:ss.S', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
results = removevars(results, 'utc'); % or you can directly overwrite it by:
% results.utc=datetime(results.utc,... instead of creating a new column UTC
% and removing the old one

if S.s==1
   writetable(results,[S.path,tablename,'.csv']) 
end

end

