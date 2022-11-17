% Extract Detected and Annotated vocalizations from Pamguard files


% !!!! Make sure you have:  !!!!!!!
% 1) First updated Specify_paths.m and run A1_Extract_Tables_from_SQLite.m
% 2) Updated Specify_array_parameters.m for your array

clear, close all

%\\\\\\\\\\ Configre paths for tables and where to save data \\\\\\\\\\\
Specify_paths
tablesfolder = sqltables; %sqltables path gets configured in Specify_paths.m
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\\\\\\\\\\\\\\\\  Get array Info  \\\\\\\\\\\\\\\\\\
Specify_array_parameters %gives a parameters struct
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\ LOAD all tables and their data into a struture caled Tables:\\\\\
tables =dir(fullfile(tablesfolder,'*.csv'));

N=size(tables,1);
Tables(N).data =[];
Tables(N).tablename=[];
for m=1:N
    Tables(m).data=readtable([tablesfolder,'/',tables(m).name]);
    Tables(m).tablename=tables(m).name;
end
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\\\\ From each Table extract relevant Info: \\\\\\\\\\\\\\\\\\\\\
% WHISTLES
[Annotated_data_w, All_data_w] = extract_detections_PAMcsv(Tables,parameters,'whistles');
% CLICKS
[Annotated_data_c, All_data_c] = extract_detections_PAMcsv(Tables,parameters,'clicks');

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\\\\\\\\\\\\\\\\\ SAVE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
save([folder2save2_info,parameters.encounter,'_Extracted_AnnotatedWhistles.mat'],'Annotated_data_w','All_data_w','parameters','sqldatabase')
save([folder2save2_info,parameters.encounter,'_Extracted_AnnotatedClicks.mat'],'Annotated_data_c','All_data_c','parameters','sqldatabase')
     
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
