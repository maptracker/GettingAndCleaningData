## Code Book ##

This file describes the variables used in the Tidy Data file
[SamsungHumanActivity.txt](./SamsungHumanActivity.txt). The raw data
are available from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The scripts used to process them may be found on
[GitHub](https://github.com/maptracker/GettingAndCleaningData).

#### Important! ####

If you are viewing [CodeBookIntroOnly.md](./CodeBookIntroOnly.md),
that file represents only the human-generated part of the code
book. The full code book may be found in [CodeBook.md](./CodeBook.md),
which additionally includes script-generated descriptions for many of
the variables.

### Data Utilized ###

All files are contained in the top-level directory `UCI HAR Dataset`
from the zip archive. "<test|train>" indicates that the file had either "test"
or "train" at that position, depending on the source directory.

The file `features.txt` contains column header information for
`X_<test|train>.txt`. The assignment specifies that only mean and
standard deviation values are of interest for our analysis; These
columns are represented by the tokens `-mean()-` and `-std()-`,
respectively. String matches to these tokens were used to identify and label the desired columns

The `train` and `test` subdirectories were fully parsed to extract the
desired data.

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
grouped by **SubjectID** and **Activity**, with the mean value being
represented.

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
   represents the count of averaged observations for that row's
   **SubjectID**/**Activity** pair.

The following columns are represent the measurements extracted from
the `X_<test|train>.txt` files. For `fullTidyData.tsv` the values will
be taken directly from the files. For `meanTidyData.tsv`, the values
are means of all observations for the indicated
**SubjectID**/**Activity** pair.

These data are unitless, having been normalized to between -1 and 1 by
the original researchers.
