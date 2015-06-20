# GettingAndCleaningDataProject
Courera/JHU 'Getting and Cleaning Data' course project

The script 'run_analysis.R' processes the UCI HAR Dataset, 
which is available from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

In order to run the script
1. Create a local working directory
2. Copy run_analysis.R to that directory 
3. Download the dataset to that directory and unzip it
4. source run_analysis.R to run the script
5. The resulting dataset will be written to 'MeansByActivityAndSubject.txt' in your working directory

The script performs the following steps

## STEP 1 - Merge the training and test datasets

* read the activity labels from activity_labels.txt
* read features.txt - these are the column names for the data
* fix up the column names so that they're unique

* read the test data in three parts
  * the subject IDs from test/subject_test.txt
  * the actual test data from test/X_test.txt
  * the activities from test/y_test.txt")
  * apply the names to the test data columns
  * column bind the subjects and activities to the test data

* read the training data in three parts
  * the subject IDs from train/subject_train.txt
  * the actual training data from train/X_train.txt
  * the activities from train/y_train.txt")
  * apply the names to the training data columns
  * column bind the subjects and activities to the training data
* combine the test and trainging data by using row bind

## STEP 2 - select columns containing mean and standard deviations of the measurements
* use select to extract the activity, subject and columns containing either '.mean.' or '.std.'
* note the full stops were introduced by make_names 

## STEP 3 - add descriptive activity names
* join the full dataset and activity datasets on activityId. Use all the rows from full dataset 
* drop the activity ids and label the activity description
* tidy up the activity descriptions by converting to lower case and replace underscores with spaces

## STEP 4 - label the data columns
* fix up the column names further. Doing it earlier would make it more difficult to select the correct columns. The resulting labels are camelCase, i.e. each word except the first is capitalised and there are no spaces or other non-alphanumeric characters 
* replace 'BodyBody' with 'Body' to correct an error in the original dataset
* replace ".mean." by "Mean"
* replace ".std." by "Std"
* remove all '.'

## STEP 5 - calculate the mean for all measurements by activity and subject
* groupy by activity and then subject
* and use summarise to calculate the mean of all measurements
* save the result to "MeansByActivityAndSubject.txt"

                                                                                                             