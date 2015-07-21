#Getting & Cleaning Data, Course Project

##UCI-HAR Dataset

###activity_label.txt
*	dim[]6]
*	WALKING, WALKING_UPSTAIRS,,,,LAYING

###features_info.txt
*	unformatted text
*	descriptive

###features.txt
*	dim[]561,2]
*	column names, with caps, special characters
*	some dups  
*	2nd column is sequent number, 1-561


###test directory
####subject_test.txt  
* dim[2947]   
* integers 2-24 not inclusive  
* multiples  
* in seq   

####X_test.txt
* dim[2947,561]  
* numeric data

####Y_test.txt
* dim[2947]   
* integers 1-6  
* not in seq   

###train directory
####subject_train.txt
* dim[7352]   
* integers 1-30 not inclusive  
* multiples  
* in seq   

####X_train.txt
* dim[7352,561]  
* numeric data

####Y_train.txt
* dim[7352]   
* integers 1-6  
* not in seq   

##Objective

###You should create one R script called run_analysis.R that does the following.
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.   
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.   
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

##Data Set Relationships
1. features.txt links to X.test.txt & X_train.txt by column 2 (sequence number) of features.txt <-> column number of X_(test,train).txt.
2. activity_label.txt links to Y_test.txt & Y_train.txt by row number of activity_label.txt <-> column 1 of Y_(test,train).txt
3. subject_(test,train).txt & Y_(test,train).txt link to X_(test,train).txt by row number of subject_(test,train).txt & Y_(test,train).txt <-> row number of X_(test,train).txt.
4. X_test.txt & X_train.txt match by columns.


##Plan of Attack. 

1. Input all data files. 
	a. activity_labels.txt -> actlbl. 
	b. features.txt -> feat. 
	c. subject_train.txt - subjtrain. 
	d. X_train.txt - traindf. 
	e. Y_train.txt -> ytrain. 
	f. subject_test.txt -> subjtest.
	g. X_test.txt -> testdf. 
	h. Y_test.txt -> ytest. 

2. Create column headers.
	a. convert features literals to lowercase from feat. 
	b. remove special characters (-_(),etc). 
	c. select only leterals containing "mean" or "std", i.e.  variables contining means or standard deviations. 
	
3. Apply column headers. 
	a. to testdf. 
	b. to traindf. 
	
4. Extract mean, std columns. 
	a. from testdf -> testdf2. 
	b. from traindf -> traindf2. 
	
5. Append subject, activity, & origin("test" or "train") columns. 
	a. to testdf2 -> testdf3. 
	b. to traindf2 -> traindf3. 

6. Combine testdf3, traindf3 data sets -> combinedf.
7. Separate dataframe combinedf into segment where activity & subject are reduced to "Total" levels.
8. Then recombine -> recombdf.
9. Convert dataframe recombdf to datatable recombdt.
10. Extract vector of names of variables to calculate - the first 86 columns -> variables.
11. Compute means for 86 columns (variables) by activity & subject -> final.
12. Write out .txt file for submission -> gcdproject.txt.   


##  Codebook:  see codebook.md
