% Extract Detected and Annotated (if available) vocalizations from Pamguard files
%
% !!!!!!!!!!!!!!!! Make sure you have:  !!!!!!!!!!!!!!!
% 1) First updated Specify_paths.m and run A1_Extract_Tables_from_SQLite.m
% 2) Updated Specify_array_parameters.m for your array
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%
%
% Pina Gruden, UH Manoa, 2022

%///////////////////////////////////////////////////////////

clear, close all

addpath('./extract_detections_code'); 

%\\\\\\\\\\\\\\\\\\\\ Get Paths to folders \\\\\\\\\\\\\\\\\\
[folder, folder2save2] =Specify_paths;
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\\\\\\\\\\\\\\\\  Get array Info  \\\\\\\\\\\\\\\\\\
[parameters]=Specify_array_parameters;
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\ LOAD all tables and their data into a struture caled Tables:\\\\\
tables =dir(fullfile(folder.sqltables,'*.csv'));
% elimanate OS-X generated files
idx=  cellfun(@(x) ~strcmp(x(1),'.'), {tables.name}); %get indices of all files that are not '.'
tables=tables(idx);

N=size(tables,1);
Tables(N).data =[];
Tables(N).tablename=[];
for m=1:N
    Tables(m).data=readtable([folder.sqltables,tables(m).name]);
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
save([folder2save2,parameters.encounter,'_Extracted_AnnotatedWhistles.mat'],'Annotated_data_w','All_data_w','parameters','folder')
save([folder2save2,parameters.encounter,'_Extracted_AnnotatedClicks.mat'],'Annotated_data_c','All_data_c','parameters','folder')
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
     
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
