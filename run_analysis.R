library(dplyr)
## This script processes the test and training data from Human Activity Recognition Using Smartphones Dataset to produce a separate 
## tidy dataset (see codebook.md for a description of this dataset)

## To run this script you must -
##      1. create a local directory and make it your working directory
##      2. copy this script to your working dircectory
##      3. download the data into your working directory 
##         it can be obtaied from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##      4. Unzip it - it will create a directory callled 'UCI HAR Dataset'
##      5. source run_analysis.R to run the scipt
##      6. The resulting dataset will be written to 'MeansByActivityAndSubject.txt' in your working directory

## STEP 1 - Merge the training and test datasets

## read the activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
## and the features = these are the column names for the data
features <- read.table("UCI HAR Dataset/features.txt")
## fix up the column names so that a) they're unique and b) we can use dplyr finctions
feature.names = make.names(features$V2, unique = TRUE)

## read the test data in three parts
## 1. the subject IDs
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
## 2. the actual test data
test.x <- read.table("UCI HAR Dataset/test/X_test.txt", colClasses = "numeric")
## 3. the activities
test.activities = read.table("UCI HAR Dataset/test/y_test.txt")
## apply the names to the test data columns
names(test.x) = feature.names
## add the subjects and activities to the test data
test.raw <- cbind(test.subjects, test.activities, test.x)
names(test.raw)[1] <- "subject"
names(test.raw)[2] <- "activityId"

## read the training data in three parts
## 1. the subject IDs
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
## 2. the actual data
train.x <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses = "numeric")
## 3. the activities
train.activities = read.table("UCI HAR Dataset/train/y_train.txt")
## apply the names to the training data columns
names(train.x) = feature.names
## add the subjects and activities to the training data
train.raw <- cbind(train.subjects, train.activities, train.x)
names(train.raw)[1] <- "subject"
names(train.raw)[2] <- "activityId"

## combine the test and trainging data
full.data = rbind(train.raw, test.raw)

## STEP 2 - select columns containing mean and standard deviations of the measurments
mean.data = select(full.data, activityId, subject, contains(".mean."), contains(".std."))

## STEP 3 - add descriptive activity names
mean.data <- right_join(x = activity_labels, y = mean.data,  c("V1" = "activityId"))
## drop the activity ids and label the activity description
mean.data <- select(mean.data, -V1)
mean.data = rename(mean.data, activity = V2)
## tidy up the descriptions
mean.data$activity <- tolower(mean.data$activity)               ## convert to lower case
mean.data$activity <- gsub("_", " ", mean.data$activity)        ## replace underscores with spaces

## STEP 4 - label the data columns
## fix up the column names further. Doing it earlier would make it more difficult to select the correct columns
names(mean.data) <- gsub("BodyBody", "Body", names(mean.data))  ## correct an error in the original dataset
names(mean.data) <- gsub("\\.mean\\.", "Mean", names(mean.data))
names(mean.data) <- gsub("\\.std\\.", "Std", names(mean.data))
names(mean.data) <- gsub("\\.", "", names(mean.data))           ## remove all '.'

## STEP 5 - calculate the mean for all measurements by activity and subject
result <- mean.data %>% 
        group_by(activity, subject) %>%                         ## groupy by activity and then subject
        summarise_each(funs(mean))                              ## and calculate the mean of all measurements

## save the result
write.table(file = "MeansByActivityAndSubject.txt", result)

                                                                                                             