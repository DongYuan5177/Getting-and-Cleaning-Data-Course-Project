setwd("E:/R/getting and cleaning data PPT week 4/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

library(dplyr)
library(gsubfn)
library(reshape2)
library(tidyr)

features<-read.table("features.txt") ## features= 561 variabls

testData<-read.table("./test/X_test.txt") ##read test set
names(testData)<-features[,2] ##name dataset with features
testDataselect<-testData[,grep("mean\\()|std\\()", names(testData))] ##Extracts only the measurements on the mean and standard deviation for each measurement
testlables<-read.table("./test/y_test.txt") ##read test lables, which contain 6 activities
testsubjects<-read.table("./test/subject_test.txt") ## read test subjects, 21 individuals
testfinal<-cbind(testsubjects, testlables, testDataselect) ##bind with subjects and lables
names(testfinal)[1]<-"subjects";names(testfinal)[2]<-"lables"


trainData<-read.table("./train/X_train.txt") ## read train set
names(trainData)<-features[,2] ##name dataset with features
trainDataselect<-trainData[,grep("mean\\()|std\\()", names(testData))]##Extracts only the measurements on the mean and standard deviation for each measurement
trainlables<-read.table("./train/y_train.txt") ## read train lables, 6 activities
trainsubjects<-read.table("./train/subject_train.txt") ## read train subjects, 9 individuals
trainfinal<-cbind(trainsubjects, trainlables, trainDataselect)##bind with subjects and lables
names(trainfinal)[1]<-"subjects";names(trainfinal)[2]<-"lables"

finalData<-rbind(trainfinal, testfinal) ##bind train and test sets together
finalData$lables<-as.character(finalData$lables) 
finalData<-mutate(finalData, lables=gsubfn (".",list("1"="walking","2"="walking_upstairs","3"="walking_downstairs","4"="sitting","5"="standing","6"="laying"), finalData$lables))


list<-names(finalData)[-c(1,2)]
datamelt<-melt(finalData, id=c("subjects","lables"), measure.vars=list) ##reshaping data
step5data<-dcast(datamelt, subjects+lables~variable, mean) ##casting data frame
final<-gather(step5data, variable, mean, -subjects, -lables) ##reshaping
names(final)[2]<-"activity"

write.table(final, file="final.txt", row.name=FALSE) ##dataframe output
