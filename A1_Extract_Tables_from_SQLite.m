
% Extract Tables from the Pamguard's sqlite database

% !!!! Make sure you have:  !!!!!!!
% 1) Updated Specify_paths.m for your paths to your specific folders


clear, close all

addpath('./matlab-sqlite3-driver'); 

%\\\\\\\\\\\\\\\\\ Specify database \\\\\\\\\\\\\\\\\\\\\\\\\
Specify_paths
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\ Specify where to save the results \\\\\\\\\\
S.s=1; % to save the resulting table
S.path=sqltables; %sqltables path gets configured in Specify_paths.m
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% First you need to run extract_table_from_sqlite.m function - that
% extracts tables from sqlite to csv. Tables you need:
%-'Sound_Acquisition.csv'
%-'Detection_Group_Localiser_Children.csv'
%-'Detection_Group_Localiser.csv'
%-'Whistle_and_Moan_Detector.csv'

%For whistles
extract_table_from_sqlite(sqldatabase,'Sound_Acquisition',S);
extract_table_from_sqlite(sqldatabase,'Detection_Group_Localiser_Children',S);
extract_table_from_sqlite(sqldatabase,'Detection_Group_Localiser',S);
extract_table_from_sqlite(sqldatabase,'Whistle_and_Moan_Detector',S);
%For clicks
extract_table_from_sqlite(sqldatabase,'Click_Detector_Clicks',S);
extract_table_from_sqlite(sqldatabase,'Click_Detector_OfflineClicks',S);
extract_table_from_sqlite(sqldatabase,'Click_Detector_OfflineEvents',S);