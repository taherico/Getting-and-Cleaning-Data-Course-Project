

#reading train and test data
trainData <- read.delim(".\\UCI HAR Dataset\\train\\x_train.txt", sep = "", header = FALSE)
testData <- read.delim(".\\UCI HAR Dataset\\test\\x_test.txt", sep = "", header = FALSE)
#reading subject  data file
trainSubjectID <- read.delim(".\\UCI HAR Dataset\\train\\subject_train.txt", sep ="", header = FALSE)
testSubjectID <- read.delim(".\\UCI HAR Dataset\\test\\subject_test.txt", sep ="", header = FALSE)
#reading activity names file
activityNames <- read.delim(".\\UCI HAR Dataset\\activity_labels.txt", sep = "", header =  FALSE)
#reading train and test activity files
trainActivity <- read.delim(".\\UCI HAR Dataset\\train\\y_train.txt", sep = "", header = FALSE)
testActivity <- read.delim(".\\UCI HAR Dataset\\test\\y_test.txt", sep = "", header = FALSE)
#extract activity names as an array of character to be used as column names 
activityNames <- as.character(activityNames[[2]])
featuresNames  <- read.delim(".\\UCI HAR Dataset\\features.txt", sep = "", header = FALSE)
#extract activity names as an array of character to be used as column names 
featuresNames <- as.character(featuresNames[[2]])

#column bind data frames with to columns of activity and subject
trainBindedData <- cbind(trainActivity, trainSubjectID)
trainBindedData <- cbind(trainBindedData, trainData)
testBindedData <- cbind(testActivity, testSubjectID)
testBindedData <- cbind(testBindedData, testData)

# row bind test and train data
AllBindedData <- rbind(testBindedData, trainBindedData)

#add column names to data
names(AllBindedData) <- c("activity", "subject", featuresNames)

desiredColumnNamesBool <- grepl("mean\\(\\)|std", names(AllBindedData))
desiredColumnNames[1:2] <- TRUE
desiredColNames <- names(AllBindedData)[desiredColumnNames]

#extract desired data contains mean and std
desiredData <- AllBindedData[,desiredColNames]

#change column names to more meaningful names
names(desiredData) <-gsub("Acc", "Accelerometer", names(desiredData))
names(desiredData) <-gsub("^t", "time", names(desiredData))
names(desiredData)<-gsub("Gyro", "Gyroscope", names(desiredData))
names(desiredData)<-gsub("Mag", "Magnitude", names(desiredData))
names(desiredData)<-gsub("BodyBody", "Body", names(desiredData))
names(desiredData)<-gsub("^f", "frequency", names(desiredData))

#averaging over each group of activity and activity
finalTidyData <- aggregate(.~subject +activity, desiredData, mean)
finalTidyData <- finalTidyData[order(finalTidyData$activity, finalTidyData$subject),]

#save new tidy data file as a new text file
write.table(finalTidyData, file = "tidydata.txt",row.name=FALSE)
