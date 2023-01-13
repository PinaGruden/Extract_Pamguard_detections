function [Annotated_data, All_data] = extract_detections_PAMcsv(Tables,parameters,sig_type)
% extract_detections_PAMcsv.m is a function that gets .csv tables extracted
% from Pamguard and extracts relevant information into a Matlab table, and
% computes corresponding TDOAs for each detection.
%
% INPUTS:
% - Tables -a structure containing tables from .csv files. It has 2 fields:
%           ~ data - table data
%           ~ tablename - table name as it comes out of Pamguard database
% - parameters - a structure containing array and encounter data. Has at
%           least 2 fields:
%           ~ d - sensor separation (m)
%           ~ c - speed of sound (m/s)
% - sig_type - string specifying signal type ('clciks'/'whistles')
%
% OUTPUTS:
% - Annotated_data - a table with annotated data from the click/whistle
%       detector. It has 7 columns:
%           ~ tdoa
%           ~ bearing
%           ~ time - relative time from beginning of the encounter (in s)
%           ~ time_UTC - date and time for each detection in UTC
%           ~ groupID - parent group IDs from the Pamguard sql database.
%           ~ annotatedID - annotated labels from the Pamguard sql database.
%           ~ origUID - original IDs for annotated data from the Pamguard sql database.
% - All_data
%


switch sig_type

    case 'whistles'
        % /////////////////////////// WHISTLES ///////////////////////////////////
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

        %/////////////////////////////////////////////////////////////////////

        %\\\\\\\\\\\\\\\\\\\\\\\\\ PLOT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        colors = 'rgbcmyk';
        m=ceil(length(unique(annotatedID))/length(colors));
        colors=repmat(colors,1,m);
        figure, hold on
        h= gscatter(time_UTC,tdoa,annotatedID,colors,'ods<p>',6);
        
        for n = 1:length(h)
            set(h(n), 'MarkerFaceColor', colors(n));
        end
        plot(time_UTC_all,tdoas_all,'k.')
        %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    case 'clicks'

        % /////////////////////////// CLICKS ///////////////////////////////////
        %\\\\\\\\\\\\ From each Table extract relevant Info: \\\\\\\\\\\\\\\\\\\\\
        % 1) Get IDs of the tracked bearings
        %   (stored in Click_Detector_OfflineClicks.csv - Child of _OfflineEvents)
        ind = find(strcmp({Tables.tablename}, 'Click_Detector_OfflineClicks.csv'));

        ParentUID = Tables(ind).data.parentuid; %this info matches to "groupID" (UID column from Click_Detector_OfflineEvents table)
        SelectedID = Tables(ind).data.uid; %These are the IDs of the selected bearings and this UID matches to the UID in Click_Detector_Clicks table

        % 2) Get group ID and Annotated IDs
        %   (stored in Click_Detector_OfflineEvents.csv - Parent)
        ind = find(strcmp({Tables.tablename}, 'Click_Detector_OfflineEvents.csv'));

        groupID = Tables(ind).data.uid;
        annotatedID_temp=Tables(ind).data.comment;
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
        %   (stored in Click_Detector_Clicks.csv)
        ind = find(strcmp({Tables.tablename}, 'Click_Detector_Clicks.csv'));

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

        %\\\\\\\\\\\\\\\\\\\\\\\\\ PLOT \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        colors = 'rgbcmyk';
        m=ceil(length(unique(annotatedID))/length(colors));
        colors=repmat(colors,1,m);
        figure, hold on
        h= gscatter(time_UTC,tdoa,annotatedID,colors,'ods<p>',6);
        
        for n = 1:length(h)
            set(h(n), 'MarkerFaceColor', colors(n));
        end
        plot(time_UTC_all,tdoas_all,'k.')
        %\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

        %/////////////////////////////////////////////////////////////////////
        otherwise
                disp('Not a valid signal type. Choose "whistles" or "clicks"')
end

end