function [folder, folder2save2] = Specify_paths
% Specify_paths.m specifies paths for "Extract_Pamguard_detections" package
%
% Specify paths to:
% 1) Database folder (.sqlite3)
% 2) Folder where you want extracted Pamguard SQL tables in .csv format to be saved to
% 3) folder where results (tables with detection information) to be saved to
% 
% OUTPUT:
% - folder - a structure specifying paths to where data is
% - folder2save2 - a structure specifying path to where results are saved to.
%
%Pina Gruden, 2023, UH Manoa


% 1) \\\\\\\\\\ Path to database (.sqlite3) folder \\\\\\\\\\\\
myfolder = './Test_example/Data/Pamguard_database_sqlite3/'; % This is where your SQLite database is located
if not(isfolder(myfolder)) % If the folder doesnt exist - throw error since you need data.
error(['The folder ', myfolder, ' does not exists. There is no data ' ...
    'for tracking! Check your path and try again!'])
end
s=what(myfolder);
folder.sqldatabase = [s.path,'/'];
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% 2) \\\\ Path to folder for SQL tables (.csv) to be saved to \\\\
myfolder='./Test_example/Data/Extracted_tables/'; 
if not(isfolder(myfolder)) % If the folder doesnt exist
    mkdir(myfolder) %make a folder    
    disp(['WARNING: The specified folder ', myfolder, ' does not exists. Created a new folder.'])
end
s=what(myfolder); 
folder.sqltables = [s.path,'/'];
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% 3) \\\\ Path to where tables containing detection info will be stored \\\\
myfolder='./Test_example/Results/'; % This is where you want your final results to be saved to
if not(isfolder(myfolder)) % If the folder doesnt exist
    mkdir(myfolder) %make a folder    
    disp(['WARNING: The specified folder ', myfolder, ' does not exists. Created a new folder.'])
end
s=what(myfolder); 
folder2save2 = [s.path,'/'];
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

end