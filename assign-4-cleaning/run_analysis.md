---
title: "Run analysis"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Prepare environment

Load packages
```r
packages <- c("data.table", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)
```
Set working directory
```r
setwd("/Users/admin/git/data-science-coursera/assign-4-cleaning/")
path <- getwd()
```


## Get the data
```r
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip <- "Dataset.zip"
if (!file.exists(path)) {
  dir.create(path)
}
download.file(url, file.path(path, zip))
```

## Read the files, label (Step 4) and merge training and test sets (Step 1)

Load column names
```r
f <- "UCI HAR Dataset/features.txt"
col_names <- read.table(unz(file.path(path, zip), f), header = FALSE)
```
Load all data
```r
f <- "UCI HAR Dataset/test/subject_test.txt"
test_subject <- read.table(unz(file.path(path, zip), f), col.names = "subject", header = FALSE)
f <- "UCI HAR Dataset/test/y_test.txt"
test_activity <- read.table(unz(file.path(path, zip), f), col.names = "activity", header = FALSE)
f <- "UCI HAR Dataset/test/X_test.txt"
# Appropriately labels the data set with descriptive variable names.
test_data <- read.table(unz(file.path(path, zip), f), col.names = col_names[["V2"]], header = FALSE)
```
Merge subjects, activity and data together
```r
test <- cbind(test_subject, test_activity, test_data)
```

```r
f <- "UCI HAR Dataset/train/subject_train.txt"
train_subject <- read.table(unz(file.path(path, zip), f), col.names = "subject", header = FALSE)
f <- "UCI HAR Dataset/train/y_train.txt"
train_activity <- read.table(unz(file.path(path, zip), f), col.names = "activity", header = FALSE)
f <- "UCI HAR Dataset/train/X_train.txt"
# Appropriately labels the data set with descriptive variable names.
train_data <- read.table(unz(file.path(path, zip), f), col.names = col_names[["V2"]], header = FALSE)
```
Merge subjects, activity and data together
```r
train <- cbind(train_subject, train_activity, train_data)
```

Merges the training and the test sets to create one data set.
```r
data <- rbind(train, test)
```

```r
#remove temp variables from memory
rm(train, train_data, test, test_data)
```

## Extract measurements (Step 2).

Extracts only the measurements on the mean and standard deviation for each measurement
```r
extract_col_names <- as.integer(grep("mean\\(\\)|std\\(\\)", col_names[["V2"]]))
data <- select(data, extract_col_names)
```

## Ddescriptive names (Step 3)

Uses descriptive activity names to name the activities in the data set
```r
f <- "UCI HAR Dataset/activity_labels.txt"
activity_labels_table <- read.table(unz(file.path(path, zip), f), header = FALSE)
activity_labels <- as.vector(activity_labels_table[["V2"]])
data <- data %>% mutate(activity=cut(activity, breaks=c(0, 1, 2, 3, 4, 5, 6), 
                                     labels = activity_labels))
```

## Tidy data set (Step 5)
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```r
melted_data <- melt(extracted_data, id = c("subject", "activity"))

tidy <- dcast(melted_data, subject+activity ~ variable, mean)
```
write the tidy data set to a file
```r
write.csv(tidy, "tidy.csv", row.names=FALSE)
```

remove data
```r
rm(data, melted_data)
```