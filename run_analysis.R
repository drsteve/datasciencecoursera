#R script to get, clean data for "Getting and cleaning data" course project
#For details see comments, and CodeBook.md markdown file

#define function for merging datasets, generic for both test and train as their consistuents are the same
mergeData <- function(name, dir='UCI HAR Dataset', feat=featlabl, activ=activlabl) {
    #name - should be either 'test' or 'train'
    ##Construct filenames for relevant data to merge
    xfname   <- paste(dir, '/', name, '/', 'X_', name, '.txt', sep='')
    yfname   <- paste(dir, '/', name, '/', 'y_', name, '.txt', sep='')
    subfname <- paste(dir, '/', name, '/', 'subject_', name, '.txt', sep='')
    ftname   <- paste(dir, '/', 'features.txt', sep='')
    #now read into arrays
    xdata    <- read.table(xfname)
    actvID   <- read.table(yfname)
    subjID   <- read.table(subfname)
    features <- read.table(ftname, stringsAsFactors=FALSE)
    #add feature names to variables, add activity ID numbers (actvID)
    names(xdata) <- features$V2
    analyseme <- cbind(actvID, xdata)
    colnames(analyseme)[1] <- 'ActivityName'
    #replace activity ID with label (descriptive)
    analyseme$ActivityName <- as.character(analyseme$ActivityName)
    for (idx in 1:nrow(activ)) {
        replInds <- analyseme$ActivityName==as.character(idx)
        analyseme$ActivityName[replInds] <- activ$V2[[idx]]
    }
    #now add the subject IDs
    analyseme <- cbind(subjID, analyseme)
    colnames(analyseme)[1] <- 'SubjectID'

    #finally, label as either test or training data so we can distinguish on combining
    analyseme$DataType <- replicate(nrow(analyseme), toupper(name))

    #clean up environment
    rm(xdata, actvID, subjID, features)

    return(analyseme)
}

extractMS <- function(indata) {
    #find only those columns with a mean or standard deviation, throw the rest out
    oudata <- indata
    return(outdata)
}


#Get data files, if unzipped folder not in current working directory
havedata <- file.exists('UCI HAR Dataset')
if (!havedata) {
    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                  destfile='FUCI_HAR_dataset.zip', method='curl', mode='wb')
    unzip('FUCI_HAR_dataset.zip')
}

#the feature labels and activity labels are used for both training and test,
#so get them first
featurelabels <- read.table('UCI HAR Dataset/features.txt')
activitylabels <- read.table('UCI HAR Dataset/activity_labels.txt', stringsAsFactors=FALSE)
testdata <- mergeData('test', feat=featurelabels, activ=activitylabels)
traindata <- mergeData('test', feat=featurelabels, activ=activitylabels)

#now combine test and training data so we have one tidy table
fulldata <- rbind(traindata, testdata)

#keep only the required vars (w/ means and std. devs)
