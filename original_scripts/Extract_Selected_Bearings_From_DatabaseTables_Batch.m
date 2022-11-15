
%EXTRACT SELECTED BEARING DATA FROM DATABASE TABLES

% First you need to run extract_table_from_sqlite.m function - that
% extracts tables from sqlite to csv. Tables you need:
%-'Sound_Acquisition.csv'
%-'Detection_Group_Localiser_Children.csv'
%-'Detection_Group_Localiser.csv'
%-'Whistle_and_Moan_Detector.csv'



 clear, close all

 %Read in sensor separation table:
 Array_table=readtable('C:\Users\Pina\Dropbox\Pina\HAWAII\MATLAB\NOAA_Array_Info_Per_Encounter.csv');
 
 % Iterate through fiolders and subfolders
 list = dir('C:\Users\Pina\Dropbox\Pina\HAWAII\MATLAB\Ground_truth_fromJenn\');
 %remove . and .. entries (from Mac)
 ind=[];
 for ii=1:size(list,1)
     if list(ii).name(1) == '.'
         ind=[ind,ii];         
     end
 end
 list(ind) = []; clear ind

 sbfldrs = list([list.isdir]==1); %these are the subfolders
 
 for k=1:size(sbfldrs,1)
     if strcmp(sbfldrs(k).name, 'Pamguard_Matlab')||strcmp(sbfldrs(k).name, 'PamguardMatlab_20200113')
         continue; % skip folders that are not relevant
     end
     
     %get the  subfolders containing extracted tables from sqlite
     list2=dir([sbfldrs(k).folder,'\',sbfldrs(k).name]);
     Index = find(contains({list2.name},'Extracted')&[list2.isdir]==1);
     
     filepath = [sbfldrs(k).folder,'\',sbfldrs(k).name,'\',list2(Index).name];
     tables =dir(fullfile(filepath,'*.csv'));
     
     N=size(tables,1);
     Tables(N).data =[];
     Tables(N).tablename=[];
     for m=1:N
         Tables(m).data=readtable([filepath,'\',tables(m).name]);
         Tables(m).tablename=tables(m).name;
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
     for m=1:length(groupID)
         indx=find(groupID(m)==ParentUID);
         annotatedID(indx)=annotatedID_temp(m);
     end
     
     %Get Sound_Acquisition table where the start time for the recordings
     %are stored
     ind = find(strcmp({Tables.tablename}, 'Sound_Acquisition.csv'));
     start_UTC=Tables(ind).data.UTC(1);
     
     %Get Whistle_and_Moan_Detector table where bearings for the annotated data
     %are stored:
     ind = find(strcmp({Tables.tablename}, 'Whistle_and_Moan_Detector.csv'));
     
     UID_temp = Tables(ind).data.UID;
     bearings_temp=Tables(ind).data.bearing0; %Bearing is in radians
     time_UTC=Tables(ind).data.UTC; %time for the corresponding bearing UTC;
     %UTC column is in a datetime format
     time_diff=time_UTC-start_UTC; %get relative time (hh:mm:ss) since beginning of encounter
     time_relative_s = seconds(time_diff); %relative time in seconds since the beginning of the encounter
     
          
     [lind,loc]=ismember(UID_temp,SelectedID); %which elements of UID_temp are also in SelectedID as well as their corresponding locations in SelectedID.
     
     bearing = zeros(size(SelectedID));
     bearing(loc(lind))=bearings_temp(lind);
     
     %convert to TDOAS
     c=1500;
     % Extract sensor separation
     RowIn = find(strcmp(Array_table.Encounter, sbfldrs(k).name));
     d_16=Array_table.Hyph_6(RowIn)-Array_table.Hyph_1(RowIn); %Separation between hyph1&6
     d_45=Array_table.Hyph_5(RowIn)-Array_table.Hyph_4(RowIn);%Separation between hyph4&5
     TDOA_16 = cos(bearing).*d_16/c;
     TDOA_45 = cos(bearing).*d_45/c;
     
     time = zeros(size(SelectedID));
     time(loc(lind))=time_relative_s(lind);
     
     %Create table of selected bearings
     Annotated_TDOAS = table(TDOA_16,TDOA_45, bearing,time,ParentUID,annotatedID,SelectedID,'VariableNames',{'TDOA_16','TDOA_45','Bearing','Time','GroupID','annotatedID','origUID'});
          
     %Save mat file
      save([sbfldrs(k).folder,'\',sbfldrs(k).name,'\',sbfldrs(k).name,'_Extracted_AnnotatedWhistles.mat'],'Annotated_TDOAS','c','d_16','d_45','Tables')
     
      clear Tables time TDOA_16 TDOA_45 bearing time_relative_s bearings_temp UID_temp annotatedID ind lind loc annotatedID_temp indx groupID ParentUID SelectedID tables N
     
      figure,
      gscatter(Annotated_TDOAS.Time,Annotated_TDOAS.TDOA_45,Annotated_TDOAS.annotatedID,'krbgm','odsx*.',6)
      title(['Annotated whistles ',sbfldrs(k).name, ', hydrophone 4 and 5'])
      
 end
 
 
 % filepath = 'C:\Users\Pina\Dropbox\Pina\HAWAII\MATLAB\Ground_truth_fromJenn\Lasker_AC191\Trial-1b\Extracted_tables_fromdatabase_PAM20013b_HICEAS_Lasker_AC191_Trial-1b\';
 % tables =dir(fullfile(filepath,'*.csv'));
 
 
%  %Plot
%  figure,
%  gscatter(Annotated_TDOAS.Time,Annotated_TDOAS.TDOA_45,Annotated_TDOAS.annotatedID,'krbgm','odsx*.',6)
