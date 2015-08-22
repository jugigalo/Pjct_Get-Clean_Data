# Getting and Cleaning Data Project

# Obtain files
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, destfile = "E:/Data Science Specialization/3_Getting_and_Cleaning_Data/Week_3/Project/data.zip", mode="wb")
setwd("E:/Data Science Specialization/3_Getting_and_Cleaning_Data/Week_3/Project")
unzip("data.zip")

# Load Labels
activity_labels <- read.table("E:/Data Science Specialization/3_Getting_and_Cleaning_Data/Week_3/Project/UCI HAR Dataset/activity_labels.txt")

########################
## Process Test files ##
########################

# Load
test_type <- read.table("E:/Data Science Specialization/3_Getting_and_Cleaning_Data/Week_3/Project/UCI HAR Dataset/test/y_test.txt")
test <- read.table("E:/Data Science Specialization/3_Getting_and_Cleaning_Data/Week_3/Project/UCI HAR Dataset/test/X_test.txt")

# Description of each activity
test_type_desc <- merge(test_type, activity_labels, by.x = "V1", by.y = "V1", all.X = TRUE, all.y = TRUE)
# Asign names
names(test_type_desc) <- c("CodActivity", "DescActivity")

# Bind both dataframes: Data + activity of each row
test_tot <- cbind(test_type_desc, test)
test_tot$GROUP <- "TEST"

############################
## Process Training files ##
############################

# Load
train_type <- read.table("E:/Data Science Specialization/3_Getting_and_Cleaning_Data/Week_3/Project/UCI HAR Dataset/train/y_train.txt")
train <- read.table("E:/Data Science Specialization/3_Getting_and_Cleaning_Data/Week_3/Project/UCI HAR Dataset/train/X_train.txt")

# Description of each activity
train_type_desc <- merge(train_type, activity_labels, by.x = "V1", by.y = "V1", all.X = TRUE, all.y = TRUE)
# Asign names
names(train_type_desc) <- c("CodActivity", "DescActivity")

# Bind both dataframes: Data + activity of each row
train_tot <- cbind(train_type_desc, train)
train_tot$GROUP <- "TRAINING"


############################
### Process merged files ###
############################

# 1. Merges the training and the test sets to create one data set.
tot_data <- rbind(test_tot, train_tot)

# 2. Extracts only the measurements on the mean and standard deviation for 
# each measurement.

res <- data.frame(Activity = character(0), Mean = numeric(0), StDev = numeric(0))

for (n in 1:nrow(tot_data))
#for (n in 1:10)
{
  mn <- mean(as.numeric(tot_data[n, 3:563]))
  std <- sd(as.numeric(tot_data[n, 3:563]))
  act <- tot_data[n, 2]
  #x <- c(as.character(act), as.numeric(mn), as.numeric(std))
  x <- data.frame(Activity = as.character(act), Mean = as.numeric(mn), StDev = as.numeric(std))
  
  names(x) <- c("Activity", "Mean", "StDev")
  res <- rbind(res, x)
  names(res) <- c("Activity", "Mean", "StDev")
  
}

# 3. Uses descriptive activity names to name the activities in the data set

names(res)

# 4. Appropriately labels the data set with descriptive variable names. 

names(res)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library("sqldf")
tidy <- sqldf("select Activity, avg(Mean), avg(StDev) from res group by Activity")
names(tidy) <- c("Activity", "Mean", "StDev")
write.table(tidy, "E:/Data Science Specialization/3_Getting_and_Cleaning_Data/Week_3/Project/tidy.txt", row.names = FALSE)
tidy
