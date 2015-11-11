# File Registry #

This document records one or more files.
Each [file path](#) is listed with the **size in kilobytes**,
a *user supplied description*,
and the `hexadecimal hash digest` of the file.
The registry could be validated against current files with:

```R
source("registryManager.R")
regMan <- createFileRegistry( path = 'FileRegistry.md' )
regLines <- regMan$readRegistry()
failed <- regMan$verifyRegistry()
```

## Registry Description ##

This registry describes both the input and output files used for the
Coursera 'Getting and Cleaning Data' course.

## Parameters ##

* **Started** : 2015-11-11 16:43:47
* **HashAlgorithm** : sha1
* **CourseraURL** : https://class.coursera.org/getdata-034/human_grading/view/courses/975118/assessments/3/submissions
* **CourseraTitle** : Getting and Cleaning Data
* **CourseraDate** : November 2015
* **Finished** : 2015-11-11 16:44:05

## Files ##

1. [run_analysis.R](./run_analysis.R)<br>
   **12.472 kb** *The R script used to process input into output*<br>
   `eba62d58b431186f09d1b7ef381a6843dda22a7d`
1. [features.txt](UCI HAR Dataset/features.txt)<br>
   **15.785 kb** *Input data: Column headers for raw data files*<br>
   `21679bf2275d22adc483947009ace0c73bd6f5c0`
1. [CodeBookIntroOnly.md](./CodeBookIntroOnly.md)<br>
   **3.275 kb** *Output template: Hand-written 'intro' for the 'top' of the Code Book*<br>
   `21c7d0b2eaa2fbbcb5f653a131132c7497156dc7`
1. [CodeBook.md](./CodeBook.md)<br>
   **660.505 kb** *Output: Code Book describing data sets, with manually written introduction and auto-generated column listing*<br>
   `e9b2507059ab8f0b5b1cc2faafc4444682da722a`
1. [activity_labels.txt](UCI HAR Dataset/activity_labels.txt)<br>
   **0.080 kb** *Input data: Activity factors, relating integer ID to human-readable name*<br>
   `41321617310f6897dcf18abd5f36ff294080cb7e`
1. [subject_train.txt](UCI HAR Dataset/train/subject_train.txt)<br>
   **20.152 kb** *Input data: Subject IDs for the train data arm*<br>
   `eeb8d602f813ba19efbcafb08c55df352c981f3b`
1. [y_train.txt](UCI HAR Dataset/train/y_train.txt)<br>
   **14.704 kb** *Input data: Activity IDs for the train data arm*<br>
   `7268028e018ea20858e23dc23939ad256a977547`
1. [X_train.txt](UCI HAR Dataset/train/X_train.txt)<br>
   **66006.256 kb** *Input data: Primary raw data from the train data arm*<br>
   `f1e332529a6a0e81650dd65090f52be274e5c12b`
1. [subject_test.txt](UCI HAR Dataset/test/subject_test.txt)<br>
   **7.934 kb** *Input data: Subject IDs for the test data arm*<br>
   `a7616f032aaaa1f7a64986453675dafcc805c82d`
1. [y_test.txt](UCI HAR Dataset/test/y_test.txt)<br>
   **5.894 kb** *Input data: Activity IDs for the test data arm*<br>
   `4836229498f6db93a600168bac11961aa3b9b454`
1. [X_test.txt](UCI HAR Dataset/test/X_test.txt)<br>
   **26458.166 kb** *Input data: Primary raw data from the test data arm*<br>
   `d2bd804dff8753e6169e6a034a9c4797d514b36a`
1. [fullTidyData.tsv](./fullTidyData.tsv)<br>
   **8366.665 kb** *Output: Full tidy data file, including all rows from test and train sets, with selected mean and std columns*<br>
   `c006fb71a4a8d6f1dd076bbf980ff3e4d1e6d5cf`
