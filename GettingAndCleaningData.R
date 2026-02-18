## instructions 
## have several datafile x_test,  x_train which includes measurements taken from 
## smartphones. These files have no header - the labels for each measurement can be
## found in the file "features.txt"
## have datafiles y_test and y-train which contain a number indicating the activity relating to each observation 
## in the x files.  A file activity_labels.txt relates the numeric activity to character definition of activity
## finally have subject train and subject test file which indicates the subject (labelled as number) which the 
## x measurements and y activities related to 

## Merges the training and the test sets to create one data set.

## Extracts only the measurements on the mean and standard deviation for each measurement. 

## Uses descriptive activity names to name the activities in the data set

## Appropriately labels the data set with descriptive variable names. 

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## solution pattern is as follows 
## 1. create a helper function to merges the train the test files together and perform some checking
## 2. create a function which calls funtion to merge the x train and test files then labels the columns using features.txt
## this will format the names of the columns to make them more easy to work with 
## 3. A function that will determine which colums relate to mean and standard deviation only in the x data
## 4. a function that calls function to merge the y train and test files and use activity_labels.txt to label each activity
## 5. a function that calls function to merge the subject train an test files 
## 6. a function that combines the adjusted x, y and subject files into a single file 
## 7. a function that calls function in step 7 and then aggregates to find average for each subject and activity




## here is function that that is used to merge the .test file the .train file together and perform some validation
## look in the folder below from the train set 
getCombinedData<-function(train_filename, test_filename){
  setwd("F:/R Projects/CleaningDataHomework/QuizWeek4/UCI HAR Dataset/train")  
  ## use read.table R will automatically use white space to seperate values 
  train<-read.table(train_filename,header=FALSE)
  if(is.null(train)){
    stop("Error the train x data was not read in")
  }
  numrowstrain <- nrow(train)
  
  setwd("F:/R Projects/CleaningDataHomework/QuizWeek4/UCI HAR Dataset/test")
  ## use read.table R will automatically use white space to seperate values 
  test<-read.table(test_filename,header=FALSE)
  if(is.null(test)){
    stop("Error the test x data was not read in")
  }
  numrowstest <- nrow(test)
  ## now combine the two data files 
  ## need to check the number of columns is the same 
  if(ncol(train)!=ncol(test)){
    stop("Error the number of columns in train and test data do not align")
  }
  # now combine train and test
  result<-rbind(train, test)
  numrowsresult <- nrow(result)
  
  if(numrowsresult != numrowstest + numrowstrain){
    stop("Error - combing the two data sets failed ")
  }else{
    message("combining files worked as planned")
    return(result)
  }
  
}

## here is function that merges the x files and labels using the features datafile

getxdata<-function(){

  ## use the function above to combine the test and train data 
  result<-getCombinedData("X_train.txt","X_test.txt")
  
  ## now want to label using the activities text file 
  setwd("F:/R Projects/CleaningDataHomework/QuizWeek4/UCI HAR Dataset")
  features<-read.table("features.txt",header=FALSE)
  newlabels<-as.character(features$V2)
  ## features includes problematic strings that include "(" and ")", "-" and ,
  ## these make working with a dataframe problematic 
  ## so will replace these
  ## will gsub to do this work
  ## will replace - with .
  newlabels<-gsub("-",".",newlabels)
  ## will replace ( and ) with nothing will remove these
  ## need to use \\(  because ( is a special character 
  newlabels<-gsub("\\(","",newlabels)
  newlabels<-gsub("\\)","",newlabels)
  ## will replace , with nothing - will remove these 
  newlabels<-gsub(",","",newlabels)
  
  ## now check that the number of features in newlabels correspond to the 
  ## number of columns in result
  if(ncol(result)!=length(newlabels)){
    stop("Error: do not have all the labels needed for the data file ")
  }
  ## assign the column names to the values in the vector newlabels
  colnames(result)<-newlabels
  
  ## that is it for reading in the x data 
  return(result)
}

## here is the function that determines what columns relate to mean and 
## and standard deviation measurements only and returns the corresponding
## data frame
getOnlyMeanAndStandardDeviation<-function(df){
  ## this function will create a dataframe from df where only col names 
  ## contains the word mean or stddeviation as the end of the string
  columnnames <- names(df)
  ## use grepl to create a boolean vector where mean or std can be found at 
  ## end of the string so use mean$ and std% in regex 
  mask<- grepl("mean",columnnames) | grepl("std",columnnames)
  ## check have not missed any records 
  if(sum(mask)==0){ 
    message("could not find any columns with mean or std in dataframe ")
    return(NULL)
  }
  return( df[,mask])
  
}

## function to get the subject information 
## combines the subject test and train files and labels the fields appropriately
getsubjectdata<-function(){
  
  ## use the function above to the get the combined train and test set
  result<-getCombinedData("subject_train.txt","subject_test.txt")
  ## rename the column to Subject
  colnames(result)<-"Subject"
  
  ## that is it for reading in the x data 
  return(result)
}

## function to get the y - activity information 
## combines the y test and train files and labels the fields appropriately
## using the activity data file 

getydata<-function(){
  
  ## use the function above to the get the combined train and test set
  result<-getCombinedData("y_train.txt","y_test.txt")
  
  ## now want to read in the activities 
  ## the function features.txt contains the featues
  setwd("F:/R Projects/CleaningDataHomework/QuizWeek4/UCI HAR Dataset")
  activities<-read.table("activity_labels.txt",header=FALSE)
  
  ## want to merge the activities and result files
  colnames(result)<-"Activity_enum"
  ## use the match function to combine
  ## use match to find the position of values from one vector inside another
  ## 
  result$Activity<-activities$V2[match(result$Activity_enum,
                                       activities$V1)]
    ## that is it for reading in the y data 
  return(result)
}

## this function will create the x,y and subject data and combine them 
## together 

createtidydata<-function(){
  ## function to bring together the x_data, y_date and subject_data
  ## use the functions above to get the x_data - only for columns 
  ## which relate to meand and standard deviation
  x_data<-getOnlyMeanAndStandardDeviation(getxdata())
  ## get the subject information 
  subject_data<-getsubjectdata()
  ## use the function above to get the y_data
  y_data<-getydata()
  ## use cbind to combine the two data sets 
  combined<-cbind(subject_data,y_data["Activity"],x_data)
  return(combined)
}

## this funtion will call createtidydata and then use this to aggregate 
## across Subject and Activity
## return the resulting data frame 
aggregatedata<-function(){
  ## use function to get the columns for mean and activity from above
  dat<-createtidydata()
  ## now use the aggregate function to average up the data by subject and activity
  ## will use the aggregate function 
  ##need to check that Subject and Activity are in the dataframe 
  missingcols<-setdiff(c("Subject","Activity"),colnames(dat))
  if(length(missingcols)!=0){
    stop("Could not find the columns Subject or Activity in the dataframe")
  }
  ## now use the aggregate function to group by - remove na's
  result<-aggregate(.~Subject + Activity, data=dat, mean, na.rm=TRUE)
  return(result)
  
}

saveResults<-function(){
  dat<-aggregatedata()
  write.table(dat,row.name=FALSE,"output.txt")
}


## that is the end 











