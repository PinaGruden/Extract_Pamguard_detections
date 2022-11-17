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
Specify_array_parameters 
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
% 1) Get IDs of the tracked bearings
%   (stored in Detection_Group_Localiser_Children.csv)
ind = find(strcmp({Tables.tablename}, 'Detection_Group_Localiser_Children.csv'));

ParentUID = Tables(ind).data.parentuid; %this info matches to groupID (UID from Detection_Group_Localiser table)
SelectedID = Tables(ind).data.uid; %These are the IDs of the selected bearings and this UID matches to the UID in Whistle_and_Moan_Detector table

% 2) Get group ID and Annotated IDs
%   (stored in Detection_Group_Localiser.csv)
ind = find(strcmp({Tables.tablename}, 'Detection_Group_Localiser.csv'));

groupID = Tables(ind).data.uid;
annotatedID_temp=Tables(ind).data.text_annotation;
annotatedID =cell(size(SelectedID));
for m=1:length(groupID)
    indx=find(groupID(m)==ParentUID);
    annotatedID(indx)=annotatedID_temp(m);
end

% 3) Get the start time for the recordings
%   (stored in Sound_Acquisition.csv) 
ind = find(strcmp({Tables.tablename}, 'Sound_Acquisition.csv'));
start_UTC=Tables(ind).data.UTC(1);

% 4) Get bearings for the annotated data & convert to tdoas
%   (stored in Whistle_and_Moan_Detector.csv) 
ind = find(strcmp({Tables.tablename}, 'Whistle_and_Moan_Detector.csv'));

UID_temp = Tables(ind).data.uid;
bearings_all=Tables(ind).data.bearing0; %Bearing is in radians
time_UTC_all=Tables(ind).data.UTC; %time for the corresponding bearing UTC;
%UTC column is in a datetime format
time_diff=time_UTC_all-start_UTC; %get relative time (hh:mm:ss) since beginning of encounter
time_relative_s = seconds(time_diff); %relative time in seconds since the beginning of the encounter


[lind,loc]=ismember(UID_temp,SelectedID); %which elements of UID_temp are also in SelectedID as well as their corresponding locations in SelectedID.

bearing = zeros(size(SelectedID));
bearing(loc(lind))=bearings_all(lind);

time = zeros(size(SelectedID));
time(loc(lind))=time_relative_s(lind);

time_UTC=time_UTC_all(lind);
time_UTC(loc(lind))=time_UTC;


%convert to TDOAS
bear2tdoa = @(x) cos(x).*(parameters.d/parameters.c); %bearings are in radians thus cos(.) instead of cosd(.)

tdoa = bear2tdoa(bearing);
tdoas_all=bear2tdoa(bearings_all);

% 5) Create a table of selected bearings and a table with all bearings:
Annotated_data = table(tdoa,bearing,time,time_UTC,ParentUID,annotatedID,SelectedID,'VariableNames',{'tdoa','bearing','time','time_UTC','groupID','annotatedID','origUID'});
All_data = table(tdoas_all,bearings_all,time_relative_s,time_UTC_all,'VariableNames',{'tdoa','bearing','time','time_UTC'});

%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\\\\\\\\\\\\\\\\\ PLOT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
colors = 'rgbcmyk';
figure, hold on
h= gscatter(time_UTC,tdoa,annotatedID,colors,'ods<p>',6);
for n = 1:length(h)
  set(h(n), 'MarkerFaceColor', colors(n));
end
plot(time_UTC_all,tdoas_all,'k.')
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%\\\\\\\\\\\\\\\\\\\\\\\\\ SAVE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
save([folder2save2_info,parameters.encounter,'_Extracted_AnnotatedWhistles.mat'],'Annotated_data','All_data','parameters','sqldatabase')
     
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
