#Code Book
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
