library(dplyr)
library(data.table)
library(tidyr)

# 1) Downloaded the dataset we need to work on.

# Read subject files
subjectTrain <- read.table("C:/Renjith/DS/Software/RStudio/WorkDir/UCI HAR Dataset/train/subject_train.txt")
subjectTest  <- read.table("C:/Renjith/DS/Software/RStudio/WorkDir/UCI HAR Dataset/test/subject_test.txt" )

# Read activity files
activityTrain <- read.table("C:/Renjith/DS/Software/RStudio/WorkDir/UCI HAR Dataset/train/y_train.txt")
activityTest  <- read.table("C:/Renjith/DS/Software/RStudio/WorkDir/UCI HAR Dataset/test/y_test.txt" )

# Read data files.
train <- read.table("C:/Renjith/DS/Software/RStudio/WorkDir/UCI HAR Dataset/train/X_train.txt" )
test  <- read.table("C:/Renjith/DS/Software/RStudio/WorkDir/UCI HAR Dataset/test/X_test.txt" )

subject <- rbind(subjectTrain, subjectTest)
setnames(subject, "V1", "subject")
activity<- rbind(activityTrain, activityTest)
setnames(activity, "V1", "activityNum")


# 2) Merges the training and the test sets to create one data set.

dtable <- rbind(train, test)

# name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
features <- read.table("C:/Renjith/DS/Software/RStudio/WorkDir/UCI HAR Dataset/features.txt")
setnames(features, names(features), c("featureNum", "featureName"))
colnames(dtable) <- features$featureName

# column names for activity labels
actLabels<- read.table("C:/Renjith/DS/Software/RStudio/WorkDir/UCI HAR Dataset/activity_labels.txt")
setnames(actLabels, names(actLabels), c("activityNum","activityName"))


# Merge columns
subjact<- cbind(subject, activity)
dtable <- cbind(subjact, dtable)

# 3) Extracts only the measurements on the mean and standard deviation for each measurement.

# Reading "features.txt" and extracting only the mean and standard deviation
featuresMeanStd <- grep("mean\\(\\)|std\\(\\)",features$featureName,value=TRUE) #var name

# Taking only measurements for the mean and standard deviation and add "subject","activityNum"

featuresMeanStd <- union(c("subject","activityNum"), featuresMeanStd)
dtable<- subset(dtable,select=featuresMeanStd) 

# 4) Uses descriptive activity names to name the activities in the data set

# enter name of activity into dtable
dtable <- merge(actLabels, dtable , by="activityNum", all.x=TRUE)
dtable$activityName <- as.character(dtable$activityName)


# 5) Appropriately labels the data set with descriptive variable names.

# create dtable with variable means sorted by subject and Activity
dtable$activityName <- as.character(dtable$activityName)
aggr<- aggregate(. ~ subject - activityName, data = dtable, mean) 
write.table(aggr,"test.txt")
dtable<- tbl_df(arrange(aggr,subject,activityName))

names(dtable)<-gsub("^t", "time", names(dtable))
names(dtable)<-gsub("^f", "frequency", names(dtable))
names(dtable)<-gsub("Acc", "Accelerometer", names(dtable))
names(dtable)<-gsub("Gyro", "Gyroscope", names(dtable))
names(dtable)<-gsub("Mag", "Magnitude", names(dtable))
names(dtable)<-gsub("BodyBody", "Body", names(dtable))

# 6) From the data set in step 5, creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject.

write.table(dtable, "tidy.txt", row.name=FALSE)
