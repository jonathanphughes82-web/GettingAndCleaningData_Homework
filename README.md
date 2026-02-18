Overview

This repository contains the script and documentation required to transform the UCI Human Activity Recognition Using Smartphones Dataset into a tidy dataset.

The transformation process:

Merges training and test datasets

Extracts mean and standard deviation measurements

Applies descriptive activity names

Labels variables clearly

Produces a tidy dataset with averages by subject and activity

Dataset Source

The original dataset is available from:

UCI Machine Learning Repository
Human Activity Recognition Using Smartphones Dataset

The following raw data files are required:

UCI HAR Dataset/
│
├── train/
│   ├── X_train.txt
│   ├── y_train.txt
│   └── subject_train.txt
│
├── test/
│   ├── X_test.txt
│   ├── y_test.txt
│   └── subject_test.txt
│
├── features.txt
└── activity_labels.txt

Files in This Repository
File	Description
run_analysis.R	Main script that performs data cleaning and transformation
tidydata.txt	Final tidy dataset output
CodeBook.md	Describes variables, transformations, and dataset structure
README.md	Instructions for using this repository
How the Script Works

The script performs the following steps:

1. Merge Training and Test Sets

Combines measurement, activity, and subject datasets

Uses row binding to create unified datasets

2. Label Measurement Variables

Feature names applied from features.txt

Invalid characters cleaned:

Parentheses removed

Hyphens replaced with periods

Commas removed

3. Extract Mean and Standard Deviation

Only variables containing:

mean
std


were retained.

4. Apply Descriptive Activity Names

Activity IDs were mapped to labels using activity_labels.txt.

Example:

ID	Activity
1	WALKING
2	WALKING_UPSTAIRS
3	WALKING_DOWNSTAIRS
4	SITTING
5	STANDING
6	LAYING
5. Add Subject Identifiers

Subject IDs (1–30) were added to each observation.

6. Create Combined Dataset

Subject, activity, and measurement data were merged column-wise.

7. Produce Tidy Dataset

A second dataset was created containing:

The average of each measurement variable
For each subject and each activity

Aggregation was performed using:

aggregate(. ~ Subject + Activity, mean)

How to Run the Script

1️⃣ Download and unzip the HAR dataset.

2️⃣ Place the dataset folder in your working directory.

3️⃣ Open R or RStudio.

4️⃣ Set working directory:

setwd("path_to_dataset")


5️⃣ Run the script:

source("run_analysis.R")


6️⃣ Generate tidy dataset:

tidy <- aggregatedata()

write.table(tidy,
            "tidydata.txt",
            row.names = FALSE)

Output

The final output file:

tidydata.txt


Structure:

Column	Description
Subject	Participant ID
Activity	Activity name
Measurement variables	Averaged sensor signals

Each row represents:

One subject performing one activity

Dependencies

This script uses base R only.

No additional packages are required.

Notes

Row order integrity was preserved when mapping activity labels.

Only mean and standard deviation measurements were retained.

Variable names were cleaned for readability and syntactic validity.

Author

Submitted as part of:

Getting and Cleaning Data — Course Project
