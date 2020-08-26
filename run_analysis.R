library(fs) # for getting the file paths in a way that will work cross platform

# Step 1: Merge the training and test sets
## read train data
x_train <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                              'UCI HAR Dataset', 'train', 'X_train', ext='txt'),
                      header = FALSE)
train_sub_id <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                                   'UCI HAR Dataset', 'train', 'subject_train',
                                   ext='txt'), header = FALSE)
y_train <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                              'UCI HAR Dataset', 'train', 'y_train', ext='txt'),
                      header = FALSE)
train <- cbind(train_sub_id, x_train, y_train)

## read test data
x_test <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                        'UCI HAR Dataset', 'test', 'X_test', ext='txt'),
                   header = FALSE)

test_sub_id <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                                  'UCI HAR Dataset', 'test', 'subject_test',
                                  ext='txt'), header = FALSE)
y_test <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                             'UCI HAR Dataset', 'test', 'y_test', ext='txt'),
                     header = FALSE)
test <- cbind(test_sub_id, x_test, y_test)

# combine test and train dataframes
combined <- rbind(train, test)

# Step 2: Extract the mean and standard deviation for each measurement
features <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset'
                               , 'UCI HAR Dataset', 'features',
                               ext='txt'), header = FALSE)
combined <- combined[c(TRUE, grepl('mean|std', features[[2]]), TRUE)]

# Step 3: Use descriptive activity names
activity_lab <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                                   'UCI HAR Dataset', 'activity_labels',
                                   ext='txt'), header = FALSE)
convert <- function(x){activity_lab[[x, 2]]}
combined[[length(combined)]] <- sapply(combined[[length(combined)]], convert)

# Step 4: Use descriptive variable names
names(combined) <- c('subject_id', features[[2]][grepl('mean|std',
                                                features[[2]])], 'activity')
#write.table(combined, file='combined.csv', sep=',', row.names = FALSE)

# Step 5: Create a second dataset with average of each variable for each
#         activity and each subject
avg_data <- aggregate(. ~ subject_id + activity, combined, mean)
write.table(avg_data, 'tidy_dataset.txt', row.names=FALSE)