## Code Book ##

This file describes the variables used in the Tidy Data files
[SamsungHumanActivity_Full.tsv](./SamsungHumanActivity_Full.tsv) and
[SamsungHumanActivity_Means.tsv](./SamsungHumanActivity_Means.tsv). The
raw data are available on [cloudfront.net][Source], and a description
of the original experiment is available from
[The Machine Learning Repository][MLR].

The scripts used to process them may be found on [GitHub][GandCD]. A
full registry of every file used, both input and output, can be found
in the [File Registry](./FileRegistry.md).

[Source]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
[MLR]: https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
[GandCD]: https://github.com/maptracker/GettingAndCleaningData
[Description]: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#### Important! ####

If you are viewing [CodeBookIntroOnly.md](./CodeBookIntroOnly.md),
that file represents only the human-generated part of the code
book. The full code book may be found in [CodeBook.md](./CodeBook.md),
which additionally includes script-generated descriptions for many of
the variables.

### Data Utilized ###

All files are contained in the top-level directory
[UCI HAR Dataset](./UCI HAR Dataset) from the zip
archive. "<test|train>" indicates that the file had either "test" or
"train" at that position, depending on the source directory.

The file `features.txt` contains column header information for
`X_<test|train>.txt`. The assignment specifies that only mean and
standard deviation values are of interest for our analysis; These
columns are represented by the tokens `-mean()-` and `-std()-`,
respectively. String matches to these tokens were used to identify and
label the desired columns.

The [train](./UCI HAR Dataset/train) and [test](./UCI HAR Dataset/test)
subdirectories were parsed to extract the desired data.

* `subject_<test|train>.txt` = Used to extract **SubjectID** for each row
* `y_<test|train>.txt` = Used to extract **Activity** for each row
* `X_<test|train>.txt` = Parsed to extract the columns identified when
  `features.txt` was parsed. These column descriptions are
  auto-populated in the final code book.

Data held within the `Inertial Signals` subdirectories were not used;
These represent semi-raw data from the accelerometer and gyroscope.

### Tidy Files ###

Two tidy files were created. `fullTidyData.tsv` represents all
observations taken from the selected columns. `meanTidyData.tsv` are
grouped by **SubjectID** and **Activity**, with the mean value of each
metric being represented in the measurement columns.

### Variables Used ###

1. **SubjectID** - Factor, an integer 1-30, representing the thirty
   individuals participating in the study
1. **Activity** - Factor, one of "WALKING", "WALKING_UPSTAIRS",
   "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING" representing
   the category of activity being performed by the subject when the
   data were captured.
1. **DataSet** - Factor, one of "train" or "test", representing the
   data set the information was taken from. This column will only be
   present in the initial aggregation of the train and test sets. This
   column is not present in `meanTidyData.tsv`.
1. **Count** - Integer, number of observations represented in the
   row. This column is only found in `meanTidyData.tsv`, and
   represents the count of averaged individual observations for that
   row's **SubjectID**/**Activity** pair.

The following columns are represent the measurements extracted from
the `X_<test|train>.txt` files. For `fullTidyData.tsv` the values will
be taken directly from the files. For `meanTidyData.tsv`, the values
are means of all observations for the indicated
**SubjectID**/**Activity** pair.

Column names have been slightly modified for legibility, and to
replace dashes wwith underscores, since the dash is interpreted as a
subtraction operator in `dplyr`.

These data are unitless, having been normalized to between -1 and 1 by
the original researchers.

1. **tBodyAcc_X_mean** - The mean of tBodyAcc_X, taken from column number 1 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAcc-mean()-X')
1. **tBodyAcc_Y_mean** - The mean of tBodyAcc_Y, taken from column number 2 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAcc-mean()-Y')
1. **tBodyAcc_Z_mean** - The mean of tBodyAcc_Z, taken from column number 3 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAcc-mean()-Z')
1. **tBodyAcc_X_std** - The standard deviation of tBodyAcc_X, taken from column number 4 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAcc-std()-X')
1. **tBodyAcc_Y_std** - The standard deviation of tBodyAcc_Y, taken from column number 5 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAcc-std()-Y')
1. **tBodyAcc_Z_std** - The standard deviation of tBodyAcc_Z, taken from column number 6 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAcc-std()-Z')
1. **tGravityAcc_X_mean** - The mean of tGravityAcc_X, taken from column number 41 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tGravityAcc-mean()-X')
1. **tGravityAcc_Y_mean** - The mean of tGravityAcc_Y, taken from column number 42 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tGravityAcc-mean()-Y')
1. **tGravityAcc_Z_mean** - The mean of tGravityAcc_Z, taken from column number 43 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tGravityAcc-mean()-Z')
1. **tGravityAcc_X_std** - The standard deviation of tGravityAcc_X, taken from column number 44 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tGravityAcc-std()-X')
1. **tGravityAcc_Y_std** - The standard deviation of tGravityAcc_Y, taken from column number 45 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tGravityAcc-std()-Y')
1. **tGravityAcc_Z_std** - The standard deviation of tGravityAcc_Z, taken from column number 46 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tGravityAcc-std()-Z')
1. **tBodyAccJerk_X_mean** - The mean of tBodyAccJerk_X, taken from column number 81 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccJerk-mean()-X')
1. **tBodyAccJerk_Y_mean** - The mean of tBodyAccJerk_Y, taken from column number 82 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccJerk-mean()-Y')
1. **tBodyAccJerk_Z_mean** - The mean of tBodyAccJerk_Z, taken from column number 83 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccJerk-mean()-Z')
1. **tBodyAccJerk_X_std** - The standard deviation of tBodyAccJerk_X, taken from column number 84 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccJerk-std()-X')
1. **tBodyAccJerk_Y_std** - The standard deviation of tBodyAccJerk_Y, taken from column number 85 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccJerk-std()-Y')
1. **tBodyAccJerk_Z_std** - The standard deviation of tBodyAccJerk_Z, taken from column number 86 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccJerk-std()-Z')
1. **tBodyGyro_X_mean** - The mean of tBodyGyro_X, taken from column number 121 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyro-mean()-X')
1. **tBodyGyro_Y_mean** - The mean of tBodyGyro_Y, taken from column number 122 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyro-mean()-Y')
1. **tBodyGyro_Z_mean** - The mean of tBodyGyro_Z, taken from column number 123 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyro-mean()-Z')
1. **tBodyGyro_X_std** - The standard deviation of tBodyGyro_X, taken from column number 124 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyro-std()-X')
1. **tBodyGyro_Y_std** - The standard deviation of tBodyGyro_Y, taken from column number 125 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyro-std()-Y')
1. **tBodyGyro_Z_std** - The standard deviation of tBodyGyro_Z, taken from column number 126 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyro-std()-Z')
1. **tBodyGyroJerk_X_mean** - The mean of tBodyGyroJerk_X, taken from column number 161 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroJerk-mean()-X')
1. **tBodyGyroJerk_Y_mean** - The mean of tBodyGyroJerk_Y, taken from column number 162 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroJerk-mean()-Y')
1. **tBodyGyroJerk_Z_mean** - The mean of tBodyGyroJerk_Z, taken from column number 163 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroJerk-mean()-Z')
1. **tBodyGyroJerk_X_std** - The standard deviation of tBodyGyroJerk_X, taken from column number 164 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroJerk-std()-X')
1. **tBodyGyroJerk_Y_std** - The standard deviation of tBodyGyroJerk_Y, taken from column number 165 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroJerk-std()-Y')
1. **tBodyGyroJerk_Z_std** - The standard deviation of tBodyGyroJerk_Z, taken from column number 166 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroJerk-std()-Z')
1. **tBodyAccMag_mean** - The mean of tBodyAccMag, taken from column number 201 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccMag-mean()')
1. **tBodyAccMag_std** - The standard deviation of tBodyAccMag, taken from column number 202 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccMag-std()')
1. **tGravityAccMag_mean** - The mean of tGravityAccMag, taken from column number 214 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tGravityAccMag-mean()')
1. **tGravityAccMag_std** - The standard deviation of tGravityAccMag, taken from column number 215 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tGravityAccMag-std()')
1. **tBodyAccJerkMag_mean** - The mean of tBodyAccJerkMag, taken from column number 227 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccJerkMag-mean()')
1. **tBodyAccJerkMag_std** - The standard deviation of tBodyAccJerkMag, taken from column number 228 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyAccJerkMag-std()')
1. **tBodyGyroMag_mean** - The mean of tBodyGyroMag, taken from column number 240 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroMag-mean()')
1. **tBodyGyroMag_std** - The standard deviation of tBodyGyroMag, taken from column number 241 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroMag-std()')
1. **tBodyGyroJerkMag_mean** - The mean of tBodyGyroJerkMag, taken from column number 253 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroJerkMag-mean()')
1. **tBodyGyroJerkMag_std** - The standard deviation of tBodyGyroJerkMag, taken from column number 254 in the `X_test.txt` or `X_train.txt` files (original column identifier 'tBodyGyroJerkMag-std()')
1. **fBodyAcc_X_mean** - The mean of fBodyAcc_X, taken from column number 266 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAcc-mean()-X')
1. **fBodyAcc_Y_mean** - The mean of fBodyAcc_Y, taken from column number 267 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAcc-mean()-Y')
1. **fBodyAcc_Z_mean** - The mean of fBodyAcc_Z, taken from column number 268 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAcc-mean()-Z')
1. **fBodyAcc_X_std** - The standard deviation of fBodyAcc_X, taken from column number 269 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAcc-std()-X')
1. **fBodyAcc_Y_std** - The standard deviation of fBodyAcc_Y, taken from column number 270 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAcc-std()-Y')
1. **fBodyAcc_Z_std** - The standard deviation of fBodyAcc_Z, taken from column number 271 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAcc-std()-Z')
1. **fBodyAccJerk_X_mean** - The mean of fBodyAccJerk_X, taken from column number 345 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAccJerk-mean()-X')
1. **fBodyAccJerk_Y_mean** - The mean of fBodyAccJerk_Y, taken from column number 346 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAccJerk-mean()-Y')
1. **fBodyAccJerk_Z_mean** - The mean of fBodyAccJerk_Z, taken from column number 347 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAccJerk-mean()-Z')
1. **fBodyAccJerk_X_std** - The standard deviation of fBodyAccJerk_X, taken from column number 348 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAccJerk-std()-X')
1. **fBodyAccJerk_Y_std** - The standard deviation of fBodyAccJerk_Y, taken from column number 349 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAccJerk-std()-Y')
1. **fBodyAccJerk_Z_std** - The standard deviation of fBodyAccJerk_Z, taken from column number 350 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAccJerk-std()-Z')
1. **fBodyGyro_X_mean** - The mean of fBodyGyro_X, taken from column number 424 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyGyro-mean()-X')
1. **fBodyGyro_Y_mean** - The mean of fBodyGyro_Y, taken from column number 425 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyGyro-mean()-Y')
1. **fBodyGyro_Z_mean** - The mean of fBodyGyro_Z, taken from column number 426 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyGyro-mean()-Z')
1. **fBodyGyro_X_std** - The standard deviation of fBodyGyro_X, taken from column number 427 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyGyro-std()-X')
1. **fBodyGyro_Y_std** - The standard deviation of fBodyGyro_Y, taken from column number 428 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyGyro-std()-Y')
1. **fBodyGyro_Z_std** - The standard deviation of fBodyGyro_Z, taken from column number 429 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyGyro-std()-Z')
1. **fBodyAccMag_mean** - The mean of fBodyAccMag, taken from column number 503 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAccMag-mean()')
1. **fBodyAccMag_std** - The standard deviation of fBodyAccMag, taken from column number 504 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyAccMag-std()')
1. **fBodyBodyAccJerkMag_mean** - The mean of fBodyBodyAccJerkMag, taken from column number 516 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyBodyAccJerkMag-mean()')
1. **fBodyBodyAccJerkMag_std** - The standard deviation of fBodyBodyAccJerkMag, taken from column number 517 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyBodyAccJerkMag-std()')
1. **fBodyBodyGyroMag_mean** - The mean of fBodyBodyGyroMag, taken from column number 529 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyBodyGyroMag-mean()')
1. **fBodyBodyGyroMag_std** - The standard deviation of fBodyBodyGyroMag, taken from column number 530 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyBodyGyroMag-std()')
1. **fBodyBodyGyroJerkMag_mean** - The mean of fBodyBodyGyroJerkMag, taken from column number 542 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyBodyGyroJerkMag-mean()')
1. **fBodyBodyGyroJerkMag_std** - The standard deviation of fBodyBodyGyroJerkMag, taken from column number 543 in the `X_test.txt` or `X_train.txt` files (original column identifier 'fBodyBodyGyroJerkMag-std()')
