library(fs) # for getting the file paths in a way that will work cross platform

## read x test data
x_test <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                        'UCI HAR Dataset', 'test', 'X_test', ext='txt'),
                   header = FALSE)

test_sub_id <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                                  'UCI HAR Dataset', 'test', 'subject_test',
                                  ext='txt'), header = FALSE)
x_test <- cbind(test_sub_id, x_test)

## read x train data
x_train <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                             'UCI HAR Dataset', 'train', 'X_train', ext='txt'),
                     header = FALSE)
train_sub_id <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                                   'UCI HAR Dataset', 'train', 'subject_train',
                                   ext='txt'), header = FALSE)
x_train <- cbind(train_sub_id, x_train)

# combine x test and x train dataframes
combined_x <- rbind(x_test, x_train)

# update variable names
features <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset'
                              , 'UCI HAR Dataset', 'features',
                              ext='txt'), header = FALSE)
names(combined_x) <- c('subject_id', features[[2]])

# only keep mean and std data
combined_x <- combined_x[grepl('mean|std', features[[2]])]

y_test <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                             'UCI HAR Dataset', 'test', 'y_test', ext='txt'),
                     header = FALSE)
y_train <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                              'UCI HAR Dataset', 'train', 'y_train', ext='txt'),
                      header = FALSE)
combined_y <- rbind(y_test, y_train)
combined <- cbind(combined_x, combined_y)

names(combined)[length(names(combined))] <- 'activity'

activity_lab <- read.table(path_wd('getdata_projectfiles_UCI HAR Dataset',
                                   'UCI HAR Dataset', 'activity_labels',
                                   ext='txt'), header = FALSE)
convert <- function(x){activity_lab[[x, 2]]}
combined$activity <- sapply(combined$activity, convert)
#write.table(combined, file='combined.csv', sep=',', row.names = FALSE)

# average of each variable for each subject and activity
avg_data <- aggregate(. ~ subject_id + activity, combined, mean)
#avg_data <- avg_data[order(avg_data$subject_id, avg_data$activity),]
write.table(avg_data, 'tidy_dataset.txt', row.names=FALSE)