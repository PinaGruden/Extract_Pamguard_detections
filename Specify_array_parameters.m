function [parameters]=Specify_array_parameters
% Specify_array_parameters.m lets you specify PARAMETERS for your encouter and array
% Make sure you change/adjust parameters under captions "Changable"
%
% OUTPUTS:
% - parameters - a structure containing parameters for the encounter and 
%               processing. It has 6 fields:
%       ~ parameters.year - a scalar specifying the year of the survey
%       ~ parameters.arrayname - a string specifying the array name (should
%         match the name in Array_info.csv)
%       ~ parameters.encounter- a string specifying the encounter name 
%       ~ parameters.c - a scalar specifying the speed of sound (m/s)
%       ~ parameters.channels - 1 x 2 vector specifying sensor channels to
%           be used for processing
%       ~ parameters.d - a scalar specifying sensor separation (m)
%
%
% Pina Gruden, 2022



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

% Specify which two channels of your recordings are used to compute 
% bearings/TDOAs:
parameters.channels = [1,6]; 

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~COMPUTED:~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Get distance between sensors used to compute bearings/TDOAs:
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
