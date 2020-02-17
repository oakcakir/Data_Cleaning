# This script takes accelerometer data
# (Human Activity Recognition Using Smartphones Dataset, Version 1.0)
# from experimental subjects carrying smart phones (in the X_train.txt and X_test.txt files, 30 subjects in total) that
# were collected while the subjects were engaged in 6 different activities: walking, walking downstairs,
# walking upstairs, standing, sitting or laying down.
# The data includes 561 different accelerometer metrics at each time point for each subject during
# each activity. The data is combined and converted to numeric format. A text file, data_mean.txt is created
# that contains the mean accelerometer metrics for each subject and each activity.

library(tidyverse)

data_train <- read_delim("X_train.txt", delim = " ", col_names = FALSE)
data_train <- lapply(data_train, as.numeric)
data_y_train <- read_csv("y_train.txt", col_names = FALSE)
data_train <- cbind(data_y_train, data_train)
data_subject_train <- read_csv("subject_train.txt", col_names = FALSE)
data_train <- cbind(data_subject_train, data_train)

data_test <- read_delim("../test/X_test.txt", delim = " ", col_names = FALSE)
data_test <- lapply(data_test, as.numeric)
data_y_test <- read_csv("../test/y_test.txt", col_names = FALSE)
data_test <- cbind(data_y_test, data_test)
data_subject_test <- read_csv("../test/subject_test.txt", col_names = FALSE)
data_test <- cbind(data_subject_test, data_test)

data <- rbind(data_train, data_test)

features <- read_csv("../features.txt", col_names = FALSE)
features <- rbind("activity", features)
features <- rbind("subject", features)
features <- unlist(features)

names(data) <- features

data$activity <- factor(data$activity)
levels(data$activity) <- c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying")

data_mean <- data %>% group_by(subject, activity) %>% summarize_all(mean, na.rm = TRUE)

write.table(data_mean, "data_mean.txt", row.names = FALSE)

