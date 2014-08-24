# Getting and Cleaning Data, Course Project, Coursera

# STEP1) Merges the training and the test sets to create one data set.

# read X_test.txt file as numeric vector of 1,653,267 (= 561 x 2947)
x_test <- scan('UCI HAR Dataset/test/X_test.txt')

# reshape as 561 x 2947 data.frame
x_test <- data.frame(t(matrix(x_test, nrow = 561, ncol = 2947)))
dim(x_test)     # [1] 2947  561



# read y_test.txt (numeric vecter of 2947 items)
y <- scan('UCI HAR Dataset/test/y_test.txt')

# read subject_test.txt (numeric vecter of 2947 items)
sub<- scan('UCI HAR Dataset/test/subject_test.txt')

# Conbine these data into 'test'
test <- cbind(sub, y, x_test)
dim(test)       # [1] 2947  563 (= 2 + 561)

head(colnames(test))
rm(x_test, y, sub) 

# read X_train.txt file as numeric vector of 4,124,472 (= 561 x 7352)
x_train <- scan('UCI HAR Dataset/train/X_train.txt')

# reshape as 561 x 7352 data.frame
x_train <- data.frame(t(matrix(x_train, nrow = 561, ncol = 7352)))
dim(x_train)     # [1] 7352  561

# read y_train.txt (numeric vecter of 7352 items)
y <- scan('UCI HAR Dataset/train/y_train.txt')

# read subject_test.txt (numeric vecter of 7352 items)
sub <- scan('UCI HAR Dataset/train/subject_train.txt')

# Conbine these data into 'training'
training <- cbind(sub, y, x_train)
dim(training)   # [1] 7352  563 (= 2 + 561)
head(colnames(training))
rm(x_train, y, sub) 



# Combine test and training data.frame and make a large data set
dim(test)
dim(training)
data <- rbind(test, training)
dim(data) # [1] 10299   563   (10299 = 2947 + 7352)
rm(test, training)


# STEP2) Extracts only the measurements on the mean and standard deviation 
#    for each measurement. 

# read 'features.txt' (561 obs.)
features <- read.table('UCI HAR Dataset/features.txt', sep = ' ', header = F)
dim(features)   # [1] 561   2

# set a col names derives from "features.txt"
colnames(data) <- c("subjects", "labels", as.character(features$V2))
head(colnames(data))
rm(features)

# decide which colimn to sebset
tf <- grepl("mean()", as.character(names(data))) | grepl("std()",as.character(names(data)))
tf[1:2] <- c(T, T)      # preseve 1st and 2nd column
sum(tf)         # [1] 81 ; the number of subsetting row
exData <- data[, tf]
rm(tf, data)
dim(exData)       # [1] 10299    81

# STEP3) Uses descriptive activity names to name the activities in the data set

# read a file
activity_label <- read.table(file = 'UCI HAR Dataset/activity_labels.txt')
names(activity_label) <- c('labels', 'activity'); activity_label

# merge (link label and descriptive activity)
exData <- merge(activity_label, exData, by = "labels")
dim(exData)     # [1] 10299    82 (= 81 + 1)
rm(activity_label)      # remove an object

# STEP4) Appropriately labels the data set with descriptive variable names. 
head(names(exData), 10)
names(exData) <- gsub("-|\\()", "", names(exData))
head(names(exData), 10)

# STEP5) Creates a second, independent tidy data set with the average of each 
#    variable for each activity and each subject. 

# melt a data
library(reshape2)
dataMelt <- melt(exData, id =c("labels", "activity", "subjects"))
dim(dataMelt)
head(dataMelt, 10)

# calculate a average of each variable for each activity and each subject
library(plyr)
dataMean <- ddply(dataMelt, .(subjects, activity, variable), summarise, average = mean(value))
dim(dataMean)
head(dataMean, 10)

# reshape a data in appropriate format
library(reshape)
colnames(dataMean)[4] <- 'value'
dataStep5 <- cast(dataMean, id = c('activity', 'variable'))
dim(dataStep5)
dataStep5[1:10, 1:7]
rm(dataMelt, dataMean)


#### for Submission ####
write.table(x = dataStep5, file = 'step5.txt', row.names = F)
