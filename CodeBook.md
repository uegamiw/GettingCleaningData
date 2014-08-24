# Code book for courseProject.R

## STEP 1
In this step, read files and merge into one file.

### variables and objects
- `x_text`: data from `UCI HAR Dataset/test/X_test.txt`. Because of using `scan()` function, it is a large numeric vector at first, but is reshaped into data frame afterward. 
- `y`: Data from `UCI HAR Dataset/test/y_test.txt`. A numeric vector, representing an activity label (1-6). See also `UCI HAR Dataset/activity_labels.txt`.
- `sub`: Data from `UCI HAR Dataset/test/subject_test.txt`. A numeric vector representing subjects (1-30).
- `test`: a　combined data frame of 'test', derives from `x_text`, `y`, `sub`.　
- `x_train`: data from `UCI HAR Dataset/train/X_train.txt`. Because of using `scan()` function, it is a large numeric vector at first, but is reshaped into data frame afterward. 
- `y`: Data from `UCI HAR Dataset/train/y_train.txt`. Same name as used before.
- `sub`: Data from `UCI HAR Dataset/test/subject_test.txt`. A numeric vector representing subjects (1-30). Same name as used before.
- `train`: a　combined data frame of 'test', derives from `x_text`, `y`, `sub`. Equivalant to `test` object.
- `data`: Merged data frame derives from `test` and `sub`.


## STEP 2
Extracts only the measurements on the mean and standard deviation for each measurement. 

### variables and objects
-`features`: Data from `UCI HAR Dataset/features.txt`. Read "features_info.txt" for more detail.
-`tf`: TRUE/FALSE vector. If string in features contain strings "mean()" or "std()" that means it is a measurement for mean and standerd deviation and return TRUE in that case. It is going to be used for subsetting column.
-`exData`: a data frame subsetted from `data` object.

## STEP 3
Uses descriptive activity names to name the activities in the data set

### variables and objects
- `activity_labels`: a data frame from `UCI HAR Dataset/activity_labels.txt`.


## STEP 4
Appropriately labels the data set with descriptive variable names.
Names of columns in exData contain () and -, and it makes difficult to subset by column names. In this step, remove them using `gsub()` function.

## STEP 5
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### variables and objects
- `dataMelt`: First, using `melt()` function in `reshape2 package`, melt a data frame

	   labels activity subjects      variable     value
	1       1  WALKING       26 tBodyAccmeanX 0.2314146
	2       1  WALKING       29 tBodyAccmeanX 0.3312213
	3       1  WALKING       29 tBodyAccmeanX 0.3755700
	4       1  WALKING       29 tBodyAccmeanX 0.2332297
	...
	
- `dataMean`: Second, using `ddply()` function in `plyr` package, calculate a average of each variable for each activity and each subject

	   subjects activity         variable     average
	1         1   LAYING    tBodyAccmeanX  0.22159824
	2         1   LAYING    tBodyAccmeanY -0.04051395
	3         1   LAYING    tBodyAccmeanZ -0.11320355
	4         1   LAYING     tBodyAccstdX -0.92805647
	...

- `dataStep5`: Third, using `cast()` function in `reshape` package, fix a table in appropriate format.

	  subjects activity tBodyAccmeanX tBodyAccmeanY tBodyAccmeanZ	...
	1        1   LAYING     0.2215982  -0.040513953    -0.1132036	...
	2        1  SITTING     0.2612376  -0.001308288    -0.1045442	...
	3        1 STANDING     0.2789176  -0.016137590    -0.1106018	...
	4        1  WALKING     0.2773308  -0.017383819    -0.1111481	...
	...		 ...			...		   ...			   ...

