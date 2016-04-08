# Read subject files
subjectTrain, subjectTest  

# Read activity files
activityTrain, activityTest  

# Read data files.
train, test

# Other variables to define subject and activity
subject, activity


# merge data set
dtable 

# name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
features 

# column names for activity labels
actLabels

# Merge columns into one data set
subjact

# extracting only the mean and standard deviation
featuresMeanStd 

# create dtable with variable means sorted by subject and Activity
names(dtable)<-gsub("^t", "time", names(dtable))
names(dtable)<-gsub("^f", "frequency", names(dtable))
names(dtable)<-gsub("Acc", "Accelerometer", names(dtable))
names(dtable)<-gsub("Gyro", "Gyroscope", names(dtable))
names(dtable)<-gsub("Mag", "Magnitude", names(dtable))
names(dtable)<-gsub("BodyBody", "Body", names(dtable))

# create file to store the cleansed data
tidy.txt

