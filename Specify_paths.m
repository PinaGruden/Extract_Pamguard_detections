function [folder, folder2save2] = Specify_paths
% Specify paths to:
% 1) Database folder (.sqlite3)
% 2) Folder where you want extracted Pamguard SQL tables in .csv format to be saved to
% 3) folder where results (tables with detection information) to be saved to
% 

% 1) \\\\\\\\\\ Path to database (.sqlite3) folder \\\\\\\\\\\\
s=what('./Test_example/Data/Pamguard_database_sqlite3/'); 
folder.sqldatabase = [s.path,'/'];
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% 2) \\\\ Path to folder for SQL tables (.csv) to be saved to \\\\
s=what('./Test_example/Data/Extracted_tables/'); 
folder.sqltables = [s.path,'/'];
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% 3) \\\\ Path to where tables containing detection info will be stored \\\\
s=what('./Test_example/Results/'); 
folder2save2 = [s.path,'/'];
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

end