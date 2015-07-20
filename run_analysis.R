##  Getting & Cleaning Data, Course Project
##  You should create one R script called run_analysis.R that does the following. 
##   1.  Merges the training and the test sets to create one data set.
##   2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
##   3.  Uses descriptive activity names to name the activities in the data set
##   4.  Appropriately labels the data set with descriptive variable names. 
##   5.  From the data set in step 4, creates a second, independent tidy data set with the average 
##           of each variable for each activity and each subject.

setwd("~/Documents/GCD_Coursera")
library(dplyr)
if (!file.exists("data")) {
        dir.create("data")
}

##  1.  Read all input files
##  Read activity_labels Data File

actlbl <- read.table("./UCI HAR Dataset/activity_labels.txt")
dateread <- Sys.Date()
head(actlbl)
str(actlbl)

##  Read features Data File

feat <- read.table("./UCI HAR Dataset/features.txt")
dateread <- Sys.Date()
head(feat)
str(feat)

##  Read subject_train Data File

subjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
dateread <- Sys.Date()
head(subjtrain)
str(subjtrain)
table(subjtrain)

##  Read X_train Data File

traindf <- read.table("./UCI HAR Dataset/train/X_train.txt")
dateread <- Sys.Date()
head(traindf)
str(traindf)

##  Read Y_train Data File

ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
dateread <- Sys.Date()
head(ytrain)
str(ytrain)
table(ytrain)

##  Read subject_test Data File

subjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
dateread <- Sys.Date()
head(subjtest)
str(subjtest)
table(subjtest)

##  Read X_test Data File

testdf <- read.table("./UCI HAR Dataset/test/X_test.txt")
dateread <- Sys.Date()
head(testdf)
str(testdf)

##  Read Y_test Data File

ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
dateread <- Sys.Date()
head(ytest)
str(ytest)
table(ytest)

##  2.  Create column headers 
##  use features for column names, need to tidy
feat <- mutate(feat,t1 = tolower(gsub('[[:space:]|[:punct:]]+', '', V2))) %>%
        ##  select only mean or std vars
        filter(grepl("mean",t1) | grepl("std",t1))
##  check that no dups created
nrow(feat[3])
nrow(unique(feat[3]))

##  3.  Apply column names 
##  a.  to testdf

names(testdf)[feat[,1]]<- feat[,3]
head(testdf,3)
str(testdf)

##  b.  to traindf

names(traindf)[feat[,1]]<- feat[,3]
head(traindf,3)
str(traindf)

##  4,  Extract mean, std columns
##  a.  from testdf -> testdf2

testdf2 <- select(testdf, contains("mean"), contains("std"))
str(testdf2)

##  b.  from traindf -> traindf2

traindf2 <- select(traindf, contains("mean"), contains("std"))
str(traindf2)

##  5.  Append subject, activity, & origin columns
##  a.  to testdf2 -> testdf3

testdf3 <- cbind(testdf2, subject = as.factor(subjtest$V1), 
                 activity = actlbl$V2[ytest$V1], origin = "test")
head(testdf3)
str(testdf3)
summary(testdf3[,87:89])

##  b.  to traindf2 -> traindf3

traindf3 <- cbind(traindf2, subject = as.factor(subjtrain$V1), 
                 activity = actlbl$V2[ytrain$V1], origin = "train")
head(traindf3)
str(traindf3)
summary(traindf3[,87:89])

##  6. Combine testdf3, traindf3 data sets -> combinedf

combinedf <- rbind(testdf3, traindf3)
head(combinedf)
str(combinedf)

##  7.  Separate dataframe combinedf into segment where activity & subject are reduced to "Total" levels

cdf1 <- mutate(combinedf, activity = factor(0, labels = "Total"))
cdf2 <- mutate(combinedf, subject = factor(0, labels = "Total"))
cdf3 <- mutate(combinedf, subject = factor(0, labels = "Total"), activity = factor(0, labels = "Total"))

##  8.  Then recombine -> recombdf

recombdf <- rbind(combinedf, cdf1, cdf2, cdf3)

##  9.  Convert dataframe recombdf to datatable recombdt.

library(datasets)
library(data.table)
recombdt = data.table(recombdf)

#  10.  Extract vector of names of variables to calculate - the first 86 columns -> variables. 
variables <- head( names(recombdt), 86)

##  11.  Compute means for 86 columns (variables) by activity & subject -> final. 
final <- data.frame(recombdt[, lapply(.SD, mean), .SDcols=variables, 
                               by=list(activity, subject)])
head(str(final))

##  12.  Write out .txt file for submission -> gcdproject.txt.
write.table(final, file = "gcdproject.txt", row.names = FALSE)

           