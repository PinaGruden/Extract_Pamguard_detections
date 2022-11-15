
% Extract Tables from the Pamguard's sqlite database

clear, close all

addpath('./matlab-sqlite3-driver'); 

%\\\\\\\\\\\\\\\\\ Specify database \\\\\\\\\\\\\\\\\\\\\\\\\
sqldatabase='/Users/pinagruden/Dropbox/Pina/HAWAII/MATLAB/Ground_truth_fromJenn/Lasker_AC109/PAM20013b_HICEAS_Lasker_AC109_Trial-1b.sqlite3';
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\ Specify where to save the results \\\\\\\\\\
S.s=1; % to save the resulting table
S.path='/Users/pinagruden/Dropbox/Pina/HAWAII/MATLAB/Ground_truth_fromJenn/Lasker_AC109/Extracted_Tables/';
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

% First you need to run extract_table_from_sqlite.m function - that
% extracts tables from sqlite to csv. Tables you need:
%-'Sound_Acquisition.csv'
%-'Detection_Group_Localiser_Children.csv'
%-'Detection_Group_Localiser.csv'
%-'Whistle_and_Moan_Detector.csv'


extract_table_from_sqlite(sqldatabase,'Sound_Acquisition',S);
extract_table_from_sqlite(sqldatabase,'Detection_Group_Localiser_Children',S);
extract_table_from_sqlite(sqldatabase,'Detection_Group_Localiser',S);
extract_table_from_sqlite(sqldatabase,'Whistle_and_Moan_Detector',S);
