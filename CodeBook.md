# Code Book

This file describes the data, the variables, and the work that has been performed to clean up the data.

## Experiment

The “Human Activity Recognition Using Smartphones Dataset” consists of wearable computing recordings from 30 participants. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone. Embedded accelerometer and gyroscope were used to capture 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The activity was manually labeled. The obtained dataset has been  partitioned into two sets: training and data.

## Variables

The acceleration signal was separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ). Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

Where are set of variables that were estimated from these signals: 

 * mean(): Mean value
 * std(): Standard deviation
 * mad(): Median absolute deviation 
 * max(): Largest value in array
 * min(): Smallest value in array
 * and more

## Data source

Main data page is http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

I got data from alternative storage https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzip it to working folder


## Files

We are intrested in following files:
- Main 561-feature vector with time and frequency domain variables
 - 'train/X_train.txt': Training set.
 - 'test/X_test.txt': Test set.
- Activity labels. 
 - 'train/y_train.txt': Training labels.
 - 'test/y_test.txt': Test labels.
- An identifier of the subject who carried out the experiment.
 - 'train/subject_train.txt': Each row identifies the subject who performed the activity
 - 'test/subject_test.txt'
- List of all features.
 - 'features.txt'
- Links the class labels with their activity name.
 - 'activity_labels.txt'


## My clean up work

It is only brief descriptions with code examples. Please see run_analysis.R script for full source code 

#### Merging

I merged training and test data as

    metrics <- rbind(
        read.table("UCI HAR Dataset/train/X_train.txt"),
        read.table("UCI HAR Dataset/test/X_test.txt")
    )

 In the same way I merged, labels and subject data

#### Labels

I loaded features names from features.txt and set them to dataset

    header <- read.table("UCI HAR Dataset/features.txt")
    names(header) <- c("num","title")
    names(metrics) <- header$title

#### Extracting measurements

I extracted only "mean" and "std" measurements

    metrics <- metrics[,grep('mean\\(\\)|std\\(\\)', header$title)]
    
#### Activities

I loaded activities reference 'activity_labels.txt', changed names of columns to accord label data, and joined it with labels ('test/y_test.txt' and 'train/X_train.txt').

    activity <- merge(ref_activities, labels)
    
Then I extracted only name column
    
    activity <- activity[,2]

So instead of ids of labels I've got vector of activity names.    

#### Combining

I added activity and subject columns to main dataset as.

    metrics <- cbind(metrics, activity)
    
#### Aggregation

I aggregated dataframe to get average of each variable for each activity and each subject. 

    agg_data <- aggregate(metrics[,grep('\\(\\)', names(metrics))], list(Activity = metrics$activity, Subject = metrics$subject_id), mean)
    
I filtred for aggregation only measurement columns (with "()" in names)
