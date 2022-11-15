
%EXTRACT SELECTED BEARING DATA FROM DATABASE TABLES
 clear, close all

filepath = 'C:\Users\Pina\Dropbox\Pina\HAWAII\MATLAB\Ground_truth_fromJenn\Lasker_AC191\Trial-1b\Extracted_tables_fromdatabase_PAM20013b_HICEAS_Lasker_AC191_Trial-1b\';
tables =dir(fullfile(filepath,'*.csv'));

N=size(tables,1);
Tables(N).data =[];
Tables(N).tablename=[];
for k=1:N
    Tables(k).data=readtable([filepath,'\',tables(k).name]);
    Tables(k).tablename=tables(k).name;
end


%Get Detection_Group_Localiser_Children table where IDs of the tracked
%bearings are stored
ind = find(strcmp({Tables.tablename}, 'Detection_Group_Localiser_Children.csv')); 

ParentUID = Tables(ind).data.parentUID; %this info matches to groupID (UID from Detection_Group_Localiser table)
SelectedID = Tables(ind).data.UID; %These are the IDs of the selected bearings and this UID matches to the UID in Whistle_and_Moan_Detector table

%Get Detection_Group_Localiser table where group ID and Annotated IDs are
%stored
ind = find(strcmp({Tables.tablename}, 'Detection_Group_Localiser.csv')); 

groupID = Tables(ind).data.UID;
annotatedID_temp=Tables(ind).data.Text_Annotation;
annotatedID =cell(size(SelectedID));
for k=1:length(groupID)
indx=find(groupID(k)==ParentUID);
annotatedID(indx)=annotatedID_temp(k);
end

%Get Whistle_and_Moan_Detector table where bearings for the annotated data
%are stored:
ind = find(strcmp({Tables.tablename}, 'Whistle_and_Moan_Detector.csv')); 

UID_temp = Tables(ind).data.UID;
bearings_temp=Tables(ind).data.bearing0; %Bearing is in radians
time_temp=Tables(ind).data.StartSeconds; %time for the corresponding bearing

[lind,loc]=ismember(UID_temp,SelectedID); %which elements of UID_temp are also in SelectedID as well as their corresponding locations in SelectedID.

bearing = zeros(size(SelectedID));
bearing(loc(lind))=bearings_temp(lind); 
%convert to TDOAS
c=1500;
d=31.1; %For Lasker AC 191 hyph1&6
d2=0.96; %For Lasker AC 191 hyph4&5
TDOA_16 = cos(bearing).*d/c;
TDOA_45 = cos(bearing).*d2/c;

time = zeros(size(SelectedID));
time(loc(lind))=time_temp(lind);

%Create table of selected bearings
Annotated_TDOAS = table(TDOA_16,TDOA_45, bearing,time,ParentUID,annotatedID,SelectedID,'VariableNames',{'TDOA_16','TDOA_45','Bearing','Time','GroupID','annotatedID','origUID'});
clear time TDOA_16 TDOA_45 bearing time_temp bearings_temp UID_temp annotatedID ind lind loc annotatedID_temp indx groupID ParentUID SelectedID tables k N

%Plot
figure,
gscatter(Annotated_TDOAS.Time,Annotated_TDOAS.TDOA_45,Annotated_TDOAS.annotatedID,'krbgm','odsx*.',6)
