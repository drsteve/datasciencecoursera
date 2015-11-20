#Code Book: Human Activity Recognition Using Smartphones Dataset
## Data Source and Description

The data used in this exercise are part of the UCI Machine Learning repository and a description
can be found at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

There are 6 activities captured in these data; the activity names are:
 - WALKING
 - WALKING_UPSTAIRS
 - WALKING_DOWNSTAIRS
 - SITTING
 - STANDING
 - LAYING

A full description of the data is given in the README file contained in the downloaded data set.

## Variables
All variables, called 'Features' in the dataset notes, are normalized and bounded in the interval [-1,1]

The features are listed below, with units (given above the list) surmised from the measurement description 
and physical quantity, and the `XYZ` suffix denotes Cartesian components of a vector measurement. The 
`Mag` suffix denotes a vector magnitude (Euclidean Norm).

`Acc` refers to a linear acceleration, units of [m/s^2]
`AccJerk` refers to the time derivative of a linear acceleration, units of [m/s^3]
`Gyro` refers to an angular velocity (use of radians or degrees unclear)
`GyroJerk` refers to the second derivative wrt time of the angular velocity
Assuming radians were used for the angular measurements, the units of `Gyro` and `GyroJerk`
variables should be [rad/s] and [rad/s^3], respectively.

The variables prefixed with `t` are time domain variables and the variables prefixed with `f`
are frequency domain variables, derived by applying a Fast Fourier Transform (filter details
are in the README for the data and at the URL linked at the top of this document).
```
tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag
```

## Input data files
These data files are downloaded as a ZIP file and unpacked by the `run_analysis.R` code. The
data are unzipped into the `UCI HAR Dataset` directory.
>'features.txt': List of all features

>'activity_labels.txt': Links the class labels with their activity name

>'train/X_train.txt': Training data

>'train/y_train.txt': Training labels

>'test/X_test.txt': Test data

>'test/y_test.txt': Test labels

## Data Transformation

### Conceptual
There are 5 steps outlined in the creation of the tidy data set:
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement.
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive activity names.
5.	Creates a tidy data set with the average of each variable for each activity and each subject.

### Detail
This code requires only the `base` and `utils` packages in R, so should run on any R
installation without requiring further packages be installed.

Functions defined in `run_analysis.R`
 - `mergeData` : reads [train|test] data, labels columns, adds subject IDs, activity names and data type (test or train)
 - `extractMS` : given a data frame, returns only those columns with
   * `mean(` in the name
   * `std(` in the name
   * and ActivityName, DataType, SubjectID

Actions performed by `run_analysis.R` to create the tidy output file
 - Check for presence of HAR dataset, if not present then download
 - Read the feature and activity labels
 - Read both test and train data using `mergeData`
 - Combine the test and train data
 - Extract a subset with just the mean and standard deviation columns using `extractMS`
 - Decompose data frame from previous step by subject ID (list of data frames)
 - For each subject, calculate the mean of all variables, for each activity name
 - Re-combine the summarized data frames for each subject, forming a tidy data set
 - Write the tidy dataset to file

## Output File
The final file contains 180 rows, corresponding to all combinations of 30 subjects
and 6 activity types. The file contains 68 columns, which represent all of the means
and standard deviations on the measurements that were reported in the original data.

Each observation (row) is the mean value of each variable (column) for the reported
subject and activity.

### Variable Names
With the exception of the subject ID number (`SubjectID`) and the activity
name (`ActivityName`), each variable name is as described in the UCI HAR dataset
README file; a summary of the variable naming convention is given near the top of 
this document. The vector data have the component name (X, Y or Z) appended to the 
variable name, such that each vector component is stored separately.
```
 [1] "SubjectID"                   "ActivityName"               
 [3] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
 [5] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
 [7] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
 [9] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
[11] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
[13] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
[15] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
[17] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
[19] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
[21] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
[23] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
[25] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
[27] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
[29] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
[31] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
[33] "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
[35] "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
[37] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
[39] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
[41] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
[43] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
[45] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
[47] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
[49] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
[51] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
[53] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
[55] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
[57] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
[59] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
[61] "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
[63] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
[65] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
[67] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"
```
