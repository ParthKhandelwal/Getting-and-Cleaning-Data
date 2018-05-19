library(plyr)

filename<- "GCD Project.zip"

## Download the file

if(!file.exists(filename)){
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", filename)
}

if(!file.exists("UCI HAR Dataset")){
	unzip(filename)
}


## Preparing the labels

activity<- read.table("UCI HAR Dataset/activity_labels.txt")
activity[,2]<- as.character(activity[,2])
features<- read.table("UCI HAR Dataset/features.txt")
features<- as.character(features[,2])

##Read the data into r

train_subject<- read.table("UCI HAR Dataset/train/subject_train.txt")
train_value<- read.table("UCI HAR Dataset/train/X_train.txt")
train_activity<- read.table("UCI HAR Dataset/train/y_train.txt")

test_subject<- read.table("UCI HAR Dataset/test/subject_test.txt")
test_value<- read.table("UCI HAR Dataset/test/X_test.txt")
test_activity<- read.table("UCI HAR Dataset/test/y_test.txt")

##binding the data

train_data<- cbind(train_subject, train_value, train_activity)
test_data<- cbind(test_subject, test_value, test_activity)

##Merging the training and test data set to form one

human_activity<- rbind(train_data, test_data)

##labelling the columns of this dataset
colnames(human_activity)<- c("subject", features, "activity")


##Determining which columns to keep
keep_column<- grepl("subject|activity|mean|std", colnames(human_activity))

human_activity<- human_activity[,keep_column]

##naming the activities in the dataset
human_activity$activity<- factor(human_activity$activity, level= activity[,1], label=activity[,2])

##Appropriately labels the data set with descriptive variable names

column_names<- colnames(human_activity)

column_names<- gsub("^f", "FrequencyDomain", column_names)
column_names<- gsub("^t", "TimeDomain", column_names)
column_names<- gsub("Acc", "Acceleration", column_names)
column_names<- gsub("Mag", "Magnitude", column_names)
column_names<- gsub("Gyro", "Gyroscope", column_names)
column_names<- gsub("freq", "Frequency", column_names)
column_names<- gsub("mean", "Mean", column_names)
column_names<- gsub("std", "StandardDeviation", column_names)
column_names<- gsub("BodyBody", "Body", column_names)

colnames(human_activity)<- column_names

##creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy<- aggregate(human_activity, list(human_activity$subject, human_activity$activity), mean)
tidy<- tidy[,c(-3,-83)]
colnames(tidy)<- c("subject", "activity", column_names[c(-1,-81)])

write.table(tidy, "tidy_data.txt", row.names=FALSE, quote=FALSE)



