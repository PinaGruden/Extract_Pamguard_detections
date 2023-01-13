# Extract Pamguard detections

This repository contains code that extracts Pamguard detections (clicks, whistles) from Pamguard sqlite3 database file to .csv and Matlab tables. 

## How to use
Before running the package specify the paths to folders, and array parameters for your application by modifying the following scripts: 
- Array_info.csv - If needed add the array information in a new row, specifying sensor separations for your array. Note- the name you give your array should then match the one you specify in the Specify_array_parameters.m.
- Specify_array_parameters.m - This is where you specify your array, and encounter information. Change any parameters in the sections labeled “ CHANGABLE:” as needed. 
- Specify_paths.m - Specify folders where data is located and where results should be saved to. The expected data format are .sqlite3 database files that are produced by Pamguard (in here detections from whislte/click detectors are saved).

Then run the package by running:
1) A1_Extract_Tables_from_SQLite.m - This extracts and saves specific tables (from click/whistle detectors) from .sqlite3 database to .csv tables.
2) A2_Extract_Detections_Info.m - This extracts bearing information and computes TDOAs (for a given sensor separation) for all detections and annotated detections and saves them as a Matlab table. All and annotated detections are also displayed as plots.

## Output

This package outputs .csv and matlab tables of all and annotated detections (clicks/whistles) from Pamguard. All and annotated detections are also displayed as plots.
