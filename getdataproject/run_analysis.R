## This script creates the tidy dataset according to the
## instructions of the Coursera getdata-003 course.

## Load training subjects from file
train.subj <- read.table("train/subject_train.txt", colClasses="factor")

## Load training activities from file
train.activity <- read.table("train/y_train.txt", colClasses="factor")

## Transform the list of activities to a factor with the appropriate labels.
f <- unlist(train.activity)
levels(f) <- c("walk", "walk upstairs", "walk downstairs", "sit", "stand", "lie")
train.activity[1] <- f

## Load training data (for all 561 variables) from file
train.data <- read.table("train/X_train.txt", sep="", fill=TRUE)

## Combine the three tables containing the subject codes, activities
## and training data into a single table (with 7352 rows and 563 columns)
train.data <- cbind(train.subj, train.activity, train.data)

## Repeat the same series of steps as above, but for
## the test data.
test.subj <- read.table("test/subject_test.txt", colClasses="factor")
test.activity <- read.table("test/y_test.txt", colClasses="factor")
f <- unlist(test.activity)
levels(f) <- c("walk", "walk upstairs", "walk downstairs", "sit", "stand", "lie")
test.activity[1] <- f
test.data <- read.table("test/X_test.txt", sep="", fill=TRUE)
test.data <- cbind(test.subj, test.activity, test.data)

## Combine the rows for the training and test data, according to the instruction:
## "Merges the training and the test sets to create one data set"
all.data <- rbind(train.data,test.data)

## Read variable names from file and label the columns of the
## combined table according to these variable names.
features <- read.table("features.txt", sep=" ", colClasses=c("NULL", "character"))
features <- as.character(unlist(features))
names(all.data) <- c("subject", "activity", features)

## "Extract only the measurements on the mean and standard deviation for each measurement"
## First those columns the names of which contain the substring "mean(" or "std"
## are extracted into a separate table, then the "subject" and "activity" columns are added back.
## The latter contain the descriptive activity names as labels for data rows
## as required by point 3 and 4 of the instructions.
means.and.stds <- all.data[grep("mean\\(|std\\(", names(all.data))]
means.and.stds <- cbind(all.data[1], all.data[2], means.and.stds)


## "Creates a second, independent tidy data set with the average of each variable for each activity and each subject."
## This table has 6 (activities) * 30 (subjects) = 180 rows
## and 2 (subject and activity) + 66 (means and stds) = 68 columns.
tidyset <- aggregate(means.and.stds[3:68], by=list(means.and.stds$activity, means.and.stds$subject), FUN=mean)
tidyset[c(1,2)] <- tidyset[c(2,1)]
colnames(tidyset) <- c("subject", "activity", names(tidyset[3:68]))

write.table(tidyset, "tidyset.txt")