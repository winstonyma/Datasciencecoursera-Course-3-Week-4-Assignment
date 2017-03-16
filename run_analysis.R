# download and unzip data

## download data
if(!file.exists("C:/Users/v-wima/Desktop/Coursera")){dir.create("C:/Users/v-wima/Desktop/Coursera")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset.zip")

## Unzip dataSet to /data directory
unzip(zipfile="C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset.zip",exdir="C:/Users/v-wima/Desktop/Coursera")

# merge training dataset with test dataset

## read datasets

### read train dataset
x_train <- read.table("C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset/train/subject_train.txt")

### read test dataset
x_test <- read.table("C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset/test/subject_test.txt")

### read feavtures and activity labels
features <- read.table("C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset/features.txt")
activity_labels <- read.table("C:/Users/v-wima/Desktop/Coursera/UCI HAR Dataset/activity_labels.txt")

## assign column names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

## merge data sets

train <- cbind(x_train, y_train, subject_train)
test <- cbind(x_test, y_test, subject_test)
all_in_one <- rbind(train, test)

# extract measurements of the mean and the std for each measurement

## set column names
col_names <- colnames(all_in_one)

## vector for pattern matching and replacement
mean_and_std <- (grepl("activityId" , col_names) | 
                 grepl("subjectId" , col_names) | 
                 grepl("mean.." , col_names) | 
                 grepl("std.." , col_names)) 
                 
## subsetting the data
mean_and_std <- all_in_one[ , mean_and_std == TRUE]

# merge data

activity_names <- merge(mean_and_std, activity_labels, by='activityId', all.x=TRUE)

# summarize and set in order the mean of each variable for each activty and each subject

secondtidydata <- aggregate(. ~subjectId + activityId, activity_names, mean)
secondtidydata <- secondtidydata[order(secondtidydata$subjectId, secondtidydata$activityId),]

# write second tidy data set

write.table(secondtidydata, "secondtidydata.txt", row.name=FALSE)





