# Extract Pamguard detections

This is a Matlab based package that contains code to extract Pamguard detections (clicks, whistles) from Pamguard SQLite3 database file to `.csv` and Matlab tables. It also computes Time-Difference-Of-Arrivals (TDOAs) for the detected signals (for a given sensor spacing).

Copyright (c) 2024, Pina Gruden

## 1. Required Matlab version and toolboxes

This package was developed with **Matlab version 2022a (9.12)**. It uses the following Matlab toolboxes:

- *Statistics and Machine Learning Toolbox*

## 2. Package contents

The package contains the following functions, scripts, and files in the main folder:

- `A1_Extract_Tables_from_SQLite.m` - main script that extracts Tables from the Pamguard's SQLite3 database.
- `A2_Extract_Detections_Info.m` - main script that extracts Detected and Annotated (if available) vocalizations from Pamguard files.
- `Array_Info.csv` - a table specifying array spacing.
- `README.md` - readme document specifying package usage.
- `Specify_array_parameters.m` - specifies parameters for your encounter and array.
- `Specify_paths.m`  - specifies paths to folders where data is located and results saved to.



The package contains the following folders in the main folder:
1) **./extract_detections_code/** - contains code to extract tables from SQLite3 database, and extract detections information from tables. Functions included are:
     - `extract_detections_PAMcsv.m` - extracts relevant detection information from .csv tables into a Matlab table.
     - `extract_table_from_sqlite.m` - extracts a specified table from a SQLite3 database.

2) **./matlab-sqlite3-driver/** - Third party package that contains driver for SQLite3 database.
3) **./Test_example/** - contains data to use for testing the package works correctly.



## 3. How to use

To use this package you must first install the driver for SQLite3 database. This is a third party package, for instructions see `README.md` in `./matlab-sqlite3-driver/README.md`.

The package expects a certain folder structure, that is outlined in Section 3.1.

After the driver installation, you must specify paths and array parameters- see Section 3.2. After this you can run the extraction and TDOA computation- see Section 3.3. 

### 3.1. Expected folder structure 

It is expected that each encounter will be in a separate folder and have its results (and intermediate files) saved in a separate folder from other encounters. So for \textbf{each encounter} one should have:


- a separate folder for SQLite database
- a separate folder for extracted csv tables
- a separate folder for results (Pamguard detections)

Note, most of these folders (apart from essential folders holding your data- i.e. SQLite database) will be automatically created on a path you specify if they do not already exist. 


### 3.2. Modify

First, specify the paths to folders and array parameters for your application by modifying the following scripts:

- `Array_info.csv` - This is where your hydrophone array sensor separation is specified. If adding a new array, enter the array information and sensor separation in a new row. Note, the name you give your array should then match the one you specify in the `Specify_array_parameters.m`. 

     **Important:** The hydrophone sensor spacing should be specified in a continuous manner in meters from the first to the last hydrophone. For example: Assume your array is towed 300 m behind the boat, and consists of two sub-arrays that are separated by a 20 m separator, and each sub-array has three sensors that are separated by 1 m (Fig. 1). Further assume that your first sensor in each sub-array is placed right at the very beginning of a given sub-array, and assume the last sensor in each sub-array is placed right at the very end of a given sub-array. Then you enter the following values for hydrophones (each in a corresponding column): 0, 1, 2, 22, 23, 24. In practice, there is typically some separation between the beginning of the sub-array and the first sensor, and between the last sensor and the end of the sub-array (so measure and note sensor positions in a continuous manner). You will also have to enter the distance at which the array is towed behind the boat- this is a distance from the position of the GPS antenna, including the length of the tow cable, to the start of the first sub-array (or array if you only have one section with sensors). Carefully measure and note all sensor positions in a continuous manner. Insert -999 for fields where spacing is unknown (but the channel exists in the recordings), or if your number of sensors is less than 6.

    <img width="1367" alt="Array_spacing" src="https://github.com/PinaGruden/TDOA_tracking_master/assets/62533526/91f96d30-c536-4800-825c-951a7b89c883">
    Fig. 1. Diagram of the Array spacing and associated measurements. Each sub-array contains 3 sensors (black circles).

  
- `Specify_array_parameters.m` - This is where you specify your array and encounter information. Scroll down to change any parameters in the sections labeled “ CHANGABLE:” as needed. The parameters are documented in the function.
  
- `Specify_paths.m` - Specify folders where data is located and where results should be saved to. The expected folder structure is outlined in Section 3.1. The expected data format are `.sqlite3` database files that are produced by Pamguard (in here detections from whislte/click detectors are saved).

### 3.3. Run

Before running scripts below, your ''Current Folder'' must be navigated to the main folder of this package (then paths will get added automatically) OR add the main folder and subfolders to path manually. Either works!

Then run the package by running:

1) `A1_Extract_Tables_from_SQLite.m` - This extracts and saves specific tables (from click/whistle detectors) from `.sqlite3` database to `.csv` tables.
2) `A2_Extract_Detections_Info.m` - This extracts bearing information and computes TDOAs (for a given sensor separation) for all detections and annotated detections and saves them as a Matlab table. All detections and annotated detections are also displayed as plots.

## 4. Output

This package outputs `.csv` and Matlab tables (in `.mat` files- e.g.,  `<Encounter>_Extracted_Annotated<Clicks/Whistles>.mat`) of all and annotated detections (clicks/whistles) from Pamguard. All detections and annotated detections are also displayed as plots. Note, plots are not automatically saved.

Example plot that is obtained as the output of this package is shown in Fig. 2.

<img width="2330" alt="Pamguard_plots_example" src="https://github.com/PinaGruden/Extract_Pamguard_detections/assets/62533526/7f8cd85b-690f-4976-8435-1b0e53165b5c">

Fig. 2 Example output plots for ''Extract Pamguard detections'' package. Raw Pamguard detections (black dots) as well as and user annotations (colored symbols) are shown.

