## course project - getting an cleaning data

# the objectives are:
# You should create one R script called run_analysis.R that does the following.
# 
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names.
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# To set the wd to the folder where the file was extracted.
setwd("C:/Users/jdemijian/Documents/Curso datascience/3 - Getting & cleaning data/Haciendo el course project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/")

# to create data frames with the info from the necesary files
features <- read.table("./features.txt",header=FALSE)
activityLabel <- read.table("./activity_labels.txt",header=FALSE)
subjectTrain <-read.table("./train/subject_train.txt", header=FALSE)
xTrain <- read.table("./train/X_train.txt", header=FALSE)
yTrain <- read.table("./train/y_train.txt", header=FALSE)
subjectTest <-read.table("./test/subject_test.txt", header=FALSE)
xTest <- read.table("./test/X_test.txt", header=FALSE)
yTest <- read.table("./test/y_test.txt", header=FALSE)

# assigning names to columns
colnames(activityLabel)<-c("activityId","activityName")
colnames(subjectTrain) <- "subjectId"
colnames(xTrain) <- features[,2]
colnames(yTrain) <- "activityId"
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- features[,2]
colnames(yTest) <- "activityId"

# binding train data into a single dataframe
trainBind <- cbind(yTrain,subjectTrain,xTrain)

# binding test data into a single dataframe
testBind <- cbind(yTest,subjectTest,xTest)

# Merge test and train data
data = rbind(testBind, trainBind)

# to take a look how it is
str(data)

##########
## point 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
cNames <- colnames(data)
dataMeanStd <-data[,grepl("mean|std|subject|activityId",colnames(data))]

##########
## point 3 - Uses descriptive activity names to name the activities in the data set
dataMeanStd$activityId <- activityLabel[dataMeanStd$activityId, 2]

##########
## point 4 - Appropriately labels the data set with descriptive variable names.
names(dataMeanStd)<-gsub("Acc", "Acceleration", names(dataMeanStd))
names(dataMeanStd)<-gsub("Gyro", "Gyroscope", names(dataMeanStd))
names(dataMeanStd)<-gsub("BodyBody", "Body", names(dataMeanStd))
names(dataMeanStd)<-gsub("Mag", "Magnitude", names(dataMeanStd))
names(dataMeanStd)<-gsub("^t", "Time", names(dataMeanStd))
names(dataMeanStd)<-gsub("^f", "Frequency", names(dataMeanStd))
names(dataMeanStd)<-gsub("-mean()", "Mean", names(dataMeanStd), ignore.case = TRUE)
names(dataMeanStd)<-gsub("-std()", "STD", names(dataMeanStd), ignore.case = TRUE)
names(dataMeanStd)<-gsub("Freq()", "Frequency", names(dataMeanStd), ignore.case = TRUE)

##########
## point 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
tidydata<-aggregate(. ~subjectId + activityId, dataMeanStd, mean)
write.table(tidydata, file = "tidydata.txt",row.name=FALSE)


