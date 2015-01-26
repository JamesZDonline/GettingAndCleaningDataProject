
# Setup -------------------------------------------------------------------

library(plyr)
library(dplyr)

#Define data url
url1<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "

#Set working directory
setwd("/home/jameszdbodhi/OpenCourse/GettingCleaning")

#Check to see if the file exists, if it doesn't, download and unzip it
if(!file.exists("projectData.zip")){
  download.file(url1,destfile="projectData.zip",method="curl")
  unzip("projectData.zip")
}

#Enter the data file
setwd("UCI HAR Dataset")


# Combine Training and Test Data (Part 1) ------------------------------------------

#Load Training and Test Data
y_train <- read.delim("train/y_train.txt",col.names="LabelCodes",header=FALSE)
x_train<-read.delim("train/X_train.txt", sep="", header=FALSE)
subject_train <-read.delim("train/subject_train.txt",col.names="SubjectNumber",header=FALSE)

y_test <- read.delim("test/y_test.txt",col.names="LabelCodes",header=FALSE)
x_test<-read.delim("test/X_test.txt", sep="", header=FALSE)
subject_test <-read.delim("test/subject_test.txt",col.names="SubjectNumber",header=FALSE)

#Combine Training and Test Datasets
LabelCodes <- rbind(y_train,y_test)
Data <- rbind(x_train,x_test)
Subject <- rbind(subject_train,subject_test)

#Remove intermediat data frames to save space
rm(y_train, x_train, subject_train, x_test, y_test, subject_test)


# Use only mean and standard Deviation measurements (Part 2) ---------------------------------

# Read in the names of all of the features
nameData<-read.delim("features.txt", sep="", header=FALSE, col.names=c("id","names"))
names <- nameData$names

#Find the features that have either mean or standard deviation in the name
stand<-grep(c("std"),x=names,ignore.case=TRUE)
me<-grep(c("mean"),x=names,ignore.case=TRUE)
keep <- c(stand,me)

keepData <- Data[keep]


# Label Data Set With Descriptive Variable Names (Part 4) --------------------------

names(keepData)<-names[keep]


#Combine Subject, LabelCodes and Data one dataframe
FullData<-cbind(Subject, LabelCodes, keepData)


#Remove intermediate dataframes to save space
rm(LabelCodes, Data, Subject, keepData, me, stand)


# Give factor variables readable names (Part 3) ------------------------------------

#Make Subject Number and  Label Codes Factors and give readable names
FullData$SubjectNumber <- factor(FullData$SubjectNumber)
FullData$LabelCodes <- factor(FullData$LabelCodes)
levels(FullData$LabelCodes) <- c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying")


#And arrange it so the subject numbers are in order just so it looks nice
tidy<-arrange(FullData,SubjectNumber)


#remove temps
rm(keep,names,nameData)


# Take mean of each Variable for each activity and each subject (Part 5) -----------

summaryTidy <- ddply(tidy,.(SubjectNumber,LabelCodes),numcolwise(mean))

#export to text file for submission
write.table(summaryTidy,file="tidyData.txt",row.name=FALSE)

