getwd()
setwd("C:/Users/Amit/Desktop/New folder/3_4/project")

X_TEST <- read.table("./data/UCI HAR Dataset/test/X_test.txt",header = F)
Y_TEST <- read.table("./data/UCI HAR Dataset/test/Y_test.txt",header = F)
Subject_T <- read.table("./data/UCI HAR Dataset/test/subject_test.txt",header = F)
X_TRAIN <- read.table("./data/UCI HAR Dataset/train/X_train.txt",header = F)
Y_TRAIN <- read.table("./data/UCI HAR Dataset/train/Y_train.txt",header = F)
Subject_TRAIN <- read.table("./data/UCI HAR Dataset/train/subject_train.txt",header = F)

feature <- read.table("./data/UCI HAR Dataset/features.txt",header = F)
feature_name <- as.character(feature[,2])
activity_Label <- read.table("./data/UCI HAR Dataset/activity_labels.txt",header = F)
act_lable <- as.character(activity_Label[,2])

library(stringr)
feature_name_up <- str_replace_all(feature_name,"[[:punct:]]","")

names(Y_TEST) <- c("Activity")
names(Y_TRAIN) <- c("Activity")
names(Subject_TRAIN) <- c("Subject_identifier")
names(Subject_T) <- c("Subject_identifier")
names(X_TRAIN) <- feature_name_up
names(X_TEST) <- feature_name_up

Train_data <- cbind(X_TRAIN,Y_TRAIN,Subject_TRAIN)
Test_data <- cbind(X_TEST,Y_TEST,Subject_T)
Complete_data <- rbind(Train_data,Test_data)

data_mean <- Complete_data[,grepl("mean",names(Complete_data))]
data_std <- Complete_data[,grepl("std",names(Complete_data))]

expected_data <- cbind(data_mean,data_std,Activity = Complete_data$Activity, Subject_identifier = Complete_data$Subject_identifier)

expected_data$Activity <- act_lable[Complete_data$Activity]

library(dplyr)

test <- group_by(expected_data,Activity,Subject_identifier)
summary <- summarise_all(test,mean)
summary <- summary[,1:81]