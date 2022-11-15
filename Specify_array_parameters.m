% Specify PARAMETERS

%////////////////ARRAY and ENCOUNTER PARAMETERS & INFO/////////////

% ~~~~~~~~~~~~~~~~~~~~~~~CHANGABLE:~~~~~~~~~~~~~~~~~~~~~~~~
%Specify survey year
parameters.year=2017;

%Specify array name
parameters.arrayname= 'SugarGli_20m_Echidna';

%Specify ENCOUNTER:
parameters.encounter= 'Lasker_AC109'; 

% Specify speed of sound
parameters.c=1500; 

% Specify which two channels of your recordings you want to cross-correlate
% Select two that are furthest apart
parameters.channels = [1,6]; % Note All NOAA 2013 data has only four channels

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~COMPUTED:~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Compute distance between sensors used for cross-correlation:
Array_table=readtable('Array_Info.csv');
RowIn = find(strcmp(Array_table.Array_name, parameters.arrayname));
if ~isempty(RowIn)
    RowIn=RowIn(1);
    headers=Array_table.Properties.VariableNames;
    ColumnIn_1=contains(headers,num2str(parameters.channels(1)));
    ColumnIn_2=contains(headers,num2str(parameters.channels(2)));
    %Hydrophone separation:
    parameters.d=Array_table{RowIn,ColumnIn_2}-Array_table{RowIn,ColumnIn_1};
    if parameters.d<=0
        msg = ['Hydrophone distance error. Wrong hydrophone channels selected. ' ...
            ' Refer to Array_Info.csv to see which hydrophones are available. '];
        error(msg)
    end
else
    %     prompt="What is the sensor separation?";
    %     parameters.d=input(prompt);
    msg = ['The specified array is not found in Array_Info.csv ' ...
        '(found in the main folder). Please add the array ' ...
        'info to it and try again.'];
    error(msg)
end
 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
