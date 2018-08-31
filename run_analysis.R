library (dplyr)
library(reshape2)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Consolidate and make column names more clear

x_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
subject_total <- rbind(subject_train, subject_test)
colnames(x_total) <- features$V2
colnames(y_total) <- c("Activity") 
colnames(subject_total) <- c("Subject")

# Task 1 - Merge the training and the test sets to create one data set.

combined_data <- cbind(x_total, subject_total, y_total)

# Get column names containing mean and std

wanted_features <- features$V2[grep("(mean|std)\\(\\)", features$V2)]

# Task 2 - Extracts only the measurements on the mean and standard deviation for each measurement.

wanted_data <- subset(combined_data, select = c(as.character(wanted_features), "Subject", "Activity" ))

# Task 3 - Uses descriptive activity names to name the activities in the data set
# Task 4 - Appropriately labels the data set with descriptive variable names

wanted_data$Activity[wanted_data$Activity == 1] <- 'Walking'
wanted_data$Activity[wanted_data$Activity == 2] <- 'Walking Upstairs'
wanted_data$Activity[wanted_data$Activity == 3] <- 'Walking Downstairs'
wanted_data$Activity[wanted_data$Activity == 4] <- 'Sitting'
wanted_data$Activity[wanted_data$Activity == 5] <- 'Standing'
wanted_data$Activity[wanted_data$Activity == 6] <- 'Laying'
wanted_data$Activity <- as.factor(wanted_data$Activity)

# Task 5 - Create a tidy data set

melted_data <- melt(wanted_data, id = c("Subject", "Activity"))
tidy_data <- dcast(melted_data, Subject+Activity ~ variable, mean)
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
