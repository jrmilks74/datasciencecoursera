setwd("~/Desktop/Data_science/datasciencecoursera/")

course_3 <- "Coursera_DS3_Final.zip"

# Check if file already exists.
if (!file.exists(course_3)){
        URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(URL, course_3, method="curl")
}  

# Check if folder exists
if (!file.exists("UCI HAR Dataset")) { 
        unzip(course_3)
}

#Load the data and assign column names
features <- read.table("~/Desktop/Data_science/datasciencecoursera/UCI HAR Dataset/features.txt")
names(features) <- c("n", "functions")
activity_labels <- read.table("~/Desktop/Data_science/datasciencecoursera/UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("code", "activity")
subject_train <- read.table("~/Desktop/Data_science/datasciencecoursera/UCI HAR Dataset/train/subject_train.txt")
names(subject_train) <- "subject"
x_train <- read.table("~/Desktop/Data_science/datasciencecoursera/UCI HAR Dataset/train/X_train.txt")
names(x_train) <- features$functions
y_train <- read.table("~/Desktop/Data_science/datasciencecoursera/UCI HAR Dataset/train/y_train.txt")
names(y_train) <- "code"
subject_test <- read.table("~/Desktop/Data_science/datasciencecoursera/UCI HAR Dataset/test/subject_test.txt")
names(subject_test) <- "subject"
x_test <- read.table("~/Desktop/Data_science/datasciencecoursera/UCI HAR Dataset/test/X_test.txt")
names(x_test) <- features$functions
y_test <- read.table("~/Desktop/Data_science/datasciencecoursera/UCI HAR Dataset/test/y_test.txt")
names(y_test) <- "code"

#1. Merge the training and test data sets into one set
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
full <- cbind(subject, y, x)

#2. Extract only the mean and standard deviation for each measurement and subject
library(dplyr)
measurement <- full %>% select(subject, code, contains("mean"), contains("std"))

#3. Uses descriptive activity names to name the activities in the data set
measurement$code <- activity_labels[measurement$code, 2]

#4. Appropriately labels the data set with descriptive variable names
names(measurement)[2] <- "activity"
names(measurement) <- gsub("tBody", "Timebody", names(measurement))
names(measurement) <- gsub("Acc", "Accelerometer", names(measurement))
names(measurement) <- gsub("-mean()", "Mean", names(measurement), ignore.case = TRUE)
names(measurement) <- gsub("gravity", "Gravity", names(measurement))
names(measurement) <- gsub("-std()", "STD", names(measurement), ignore.case = TRUE)
names(measurement) <- gsub("Gyro", "Gyroscope", names(measurement))
names(measurement) <- gsub("f", "Frequency", names(measurement))
names(measurement) <- gsub("-freq()", "Frequency", names(measurement), ignore.case = TRUE)
names(measurement) <- gsub("Mag", "Magnitude", names(measurement))
names(measurement) <- gsub("Frequencyuency", "Frequency", names(measurement))
names(measurement) <- gsub("angle", "Angle", names(measurement))
names(measurement) <- gsub("BodyBody", "Body", names(measurement))
names(measurement) <- gsub("tGravity", "TimeGravity", names(measurement))

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
finished <- measurement %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(finished, "FinishedData.txt", row.name = FALSE)

