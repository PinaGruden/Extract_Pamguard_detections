% Extract Tables from the Pamguard's sqlite database
%
% !!!!!!!!!!!!!!!! Make sure you have:  !!!!!!!!!!!!!!!
% 1) Updated Specify_paths.m for your paths to your specific folders
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%
% Pina Gruden, UH Manoa, 2022

%///////////////////////////////////////////////////////////

clear, close all

addpath('./matlab-sqlite3-driver'); 
% Make sure the driver is installed properly (see instructions inside 
% './matlab-sqlite3-driver' folder

%\\\\\\\\\\\\\\\\\ Get Paths to folders \\\\\\\\\\\\\\\\\\\\\\\\\
[folder, folder2save2] = Specify_paths;
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\\\\\ Extract tables from sqlite to csv. \\\\\\\\\\\\\\\\\\\\
% Tables you need:
% - For whistles
%       ~ 'Sound_Acquisition.csv'
%       ~ 'Detection_Group_Localiser_Children.csv'
%       ~ 'Detection_Group_Localiser.csv'
%       ~ 'Whistle_and_Moan_Detector.csv'
% - For clicks
%       ~ 'Click_Detector_Clicks'
%       ~ 'Click_Detector_OfflineClicks'
%       ~ 'Click_Detector_OfflineEvents'

file = dir(fullfile(folder.sqldatabase,'*.sqlite3' ) );

%For whistles
extract_table_from_sqlite([folder.sqldatabase,file.name],'Sound_Acquisition',folder.sqltables);
extract_table_from_sqlite([folder.sqldatabase,file.name],'Detection_Group_Localiser_Children',folder.sqltables);
extract_table_from_sqlite([folder.sqldatabase,file.name],'Detection_Group_Localiser',folder.sqltables);
extract_table_from_sqlite([folder.sqldatabase,file.name],'Whistle_and_Moan_Detector',folder.sqltables);
%For clicks
extract_table_from_sqlite([folder.sqldatabase,file.name],'Click_Detector_Clicks',folder.sqltables);
extract_table_from_sqlite([folder.sqldatabase,file.name],'Click_Detector_OfflineClicks',folder.sqltables);
extract_table_from_sqlite([folder.sqldatabase,file.name],'Click_Detector_OfflineEvents',folder.sqltables);

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\