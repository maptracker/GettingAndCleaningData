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
archive. `<test|train>` indicates that the file had either "test" or
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

