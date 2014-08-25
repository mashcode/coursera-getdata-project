# merging the training and the test sets to create one data set.
metrics <- rbind(
  read.table("UCI HAR Dataset/train/X_train.txt"),
  read.table("UCI HAR Dataset/test/X_test.txt")
)

# getting names of features to label the data set with descriptive variable names. 
header <- read.table("UCI HAR Dataset/features.txt")
names(header) <- c("num","title")

header$title <- gsub("\\(\\)", "", header$title)
header$title <- gsub("\\(", "_", header$title)
header$title <- gsub("\\)", "_", header$title)
header$title <- gsub("-", "_", header$title)
header$title <- gsub(",", "_", header$title)
header$title <- gsub("_$", "", header$title)
header$title

names(metrics) <- header$title

# extracting only the measurements on the mean and standard deviation for each measurement.
metrics <- metrics[,grep('mean|std', header$title)]

# adding descriptive activity names
labels <- rbind(
  read.table("UCI HAR Dataset/train/Y_train.txt"),
  read.table("UCI HAR Dataset/test/Y_test.txt")
)
labels <- cbind(labels, row(labels)) # for sorting after merge
names(labels) <- c("act_id", 'row_id')

ref_activities <-  read.table("UCI HAR Dataset/activity_labels.txt")
names(ref_activities) <- c("act_id", "activity")

activity <- merge(labels, ref_activities, by="act_id")
activity <- activity[order(activity$row_id), "activity"]


metrics <- cbind(metrics, activity)

# adding subject info
subjects <- rbind (
  read.table("UCI HAR Dataset/train/subject_train.txt"),
  read.table("UCI HAR Dataset/test/subject_test.txt")
)
names(subjects) <- c("subject_id")

metrics <- cbind(metrics, subjects)

# data set with the average of each variable for each activity and each subject. 
agg_data <- aggregate(metrics[,grep('mean|std', names(metrics))], list(Activity = metrics$activity, Subject = metrics$subject_id), mean)
write.table(agg_data, file = "UCI HAR Dataset/tidy_data_set.txt", row.name=FALSE)
