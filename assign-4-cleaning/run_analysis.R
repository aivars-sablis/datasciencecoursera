packages <- c("data.table", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

#set working directory
path <- getwd()

# Get the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip <- "Dataset.zip"
if (!file.exists(path)) {
  dir.create(path)
}
download.file(url, file.path(path, zip))

# Load column names
# And Appropriately label the data set with descriptive variable names.
f <- "UCI HAR Dataset/features.txt"
col_names <- read.table(unz(file.path(path, zip), f), header = FALSE)
col_names[["V2"]] <- sub('^t', 'Time', col_names[["V2"]])
col_names[["V2"]] <- sub('^f', 'Freq', col_names[["V2"]])

f <- "UCI HAR Dataset/test/subject_test.txt"
test_subject <- read.table(unz(file.path(path, zip), f), col.names = "subject", header = FALSE)
f <- "UCI HAR Dataset/test/y_test.txt"
test_activity <- read.table(unz(file.path(path, zip), f), col.names = "activity", header = FALSE)
f <- "UCI HAR Dataset/test/X_test.txt"
test_data <- read.table(unz(file.path(path, zip), f), col.names = col_names[["V2"]], header = FALSE)
# Merge subjects, activity and data together
test <- cbind(test_subject, test_activity, test_data)

f <- "UCI HAR Dataset/train/subject_train.txt"
train_subject <- read.table(unz(file.path(path, zip), f), col.names = "subject", header = FALSE)
f <- "UCI HAR Dataset/train/y_train.txt"
train_activity <- read.table(unz(file.path(path, zip), f), col.names = "activity", header = FALSE)
f <- "UCI HAR Dataset/train/X_train.txt"
train_data <- read.table(unz(file.path(path, zip), f), col.names = col_names[["V2"]], header = FALSE)
# Merge subjects, activity and data together
train <- cbind(train_subject, train_activity, train_data)

# Merges the training and the test sets to create one data set.
data <- rbind(train, test)

#remove temp variables from memory
rm(train, train_data, test, test_data)

# Extracts only the measurements on the mean and standard deviation for each measurement.
extract_col_names <- as.integer(grep("mean\\(\\)|std\\(\\)", col_names[["V2"]]))
data <- select(data, extract_col_names)

# Uses descriptive activity names to name the activities in the data set

f <- "UCI HAR Dataset/activity_labels.txt"
activity_labels_table <- read.table(unz(file.path(path, zip), f), header = FALSE)
activity_labels <- as.vector(activity_labels_table[["V2"]])

data <- data %>% mutate(activity=cut(activity, breaks=c(0, 1, 2, 3, 4, 5, 6), 
                                     labels = activity_labels))

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

melted_data <- melt(extracted_data, id = c("subject", "activity"))

tidy <- dcast(melted_data, subject+activity ~ variable, mean)

# write the tidy data set to a file
write.csv(tidy, "tidy.csv", row.names=FALSE)

# remove data
rm(data, melted_data)

#average_data <- extracted_data %>% group_by(activity, subject) 
#summarize(average_data, avg = mean())
#features <- grep("^f[a-zA-Z]+\\-mean\\(\\)", col_names[["V2"]])
#col_names[features,]
