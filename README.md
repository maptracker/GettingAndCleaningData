### Data Cleaning Project ###

This repository contains work for the Coursera *Getting and Cleaning
Data* [course project][ProjectPage]. The raw data are exculded from
the repository, but were [provided on CloudFront][RawData]. The
scripts will assume the data are unzipped in the same directory they
reside in. Use of the data requires acknowledging the following
publication:

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and
Jorge L. Reyes-Ortiz*.
[Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine][DataSource].
**International Workshop of Ambient Assisted Living** (IWAAL 2012).
Vitoria-Gasteiz, Spain. Dec 2012

The data represent smartphone accelerometer measurements recorded with
6 distinct activities; WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,
SITTING, STANDING, LAYING. Two tidy data files were created by
extracting columns associated with mean and standard deviation.

* [SamsungHumanActivity_Full.tsv](./SamsungHumanActivity_Full.tsv) -
  All measurements for selected columns
* [SamsungHumanActivity_Means.tsv](./SamsungHumanActivity_Means.tsv) -
  The above data grouped by the subject and their activity, with all
  measurements in each group averaged.

All files used as input, script or output are captured in the
[File Registry](./FileRegistry.md). Of particular note:

* [CodeBook.md](./CodeBook.md) - A code book describing all variables
* [run_analysis.R](./run_analysis.R) - The script used to process the
  files.

[DataSource]: http://www.icephd.org/sites/default/files/IWAAL2012.pdf
[ProjectPage]: https://class.coursera.org/getdata-034/human_grading/view/courses/975118/assessments/3/submissions
[RawData]: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
