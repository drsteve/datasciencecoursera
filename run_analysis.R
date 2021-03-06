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
    outdata <- cbind(actvID, xdata)
    colnames(outdata)[1] <- 'ActivityName'
    #replace activity ID with label (descriptive)
    outdata$ActivityName <- as.character(outdata$ActivityName)
    for (idx in 1:nrow(activ)) {
        replInds <- outdata$ActivityName==as.character(idx)
        outdata$ActivityName[replInds] <- activ$V2[[idx]]
    }
    #now add the subject IDs
    outdata <- cbind(subjID, outdata)
    colnames(outdata)[1] <- 'SubjectID'

    #finally, label as either test or training data so we can distinguish on combining
    outdata$DataType <- replicate(nrow(outdata), toupper(name))

    return(outdata)
}

extractMS <- function(indata) {
    #find only those columns with a mean (mean()) or standard deviation (std()), throw the rest out
    keepCols <- grep('mean\\(|std\\(|ActivityName|DataType|SubjectID', names(indata))
    outdata <- indata[,keepCols]
    return(outdata)
}

colAvgs <- function(indata, colIgnore=FALSE, group='ActivityName'){
    #drop all the columns that we don't want, average the rest by group
    if (is.character(colIgnore)) {
        colIgnore <- paste(colIgnore, 'DataType', 'ActivityName', sep='|')
    } else {
        colIgnore <- paste('DataType', 'ActivityName', sep='|')
    }
    keepCols <- -1*grep(colIgnore, names(indata)) #minus column number drops it
    varnames <- names(indata)[keepCols]
    colNums  <- seq(length(names(indata)))[keepCols]
    subj     <- indata$SubjectID[1] #these are all the same since we pass in grouped tables

    grps <- levels(factor(indata[[group]]))
    outdata = data.frame(matrix(NA, nrow=length(grps), ncol=length(varnames)))
    names(outdata) <- varnames
    #loop over groups, so we have an output vector for each
    rownum <- 1
    for (gid in grps) {
        #get indices for our current group
        useRows <- indata[[group]]==gid
        #now loop through columns and calculate means
        colnum = 1
        for (idx in colNums) {
            outdata[rownum, colnum] <- mean(indata[[idx]][useRows])
            colnum <- colnum+1
        }
        rownum <- rownum+1
    }
    #now add the ActivityName and SubjectID back in...
    outdata <- cbind(grps, outdata)
    names(outdata)[1] <- 'ActivityName'
    outdata <- cbind(rep(subj, nrow(outdata)), outdata)
    names(outdata)[1] <- 'SubjectID'

    return(outdata)
}


############################
######## Main Code #########
############################

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
traindata <- mergeData('train', feat=featurelabels, activ=activitylabels)

#now combine test and training data so we have one tidy table
fulldata <- rbind(traindata, testdata)

#keep only the required vars (w/ means and std. devs)
keepdata <- extractMS(fulldata)

##and now we've finished step 4 of the instructions
#break into groups by subject and activity and take means of each variable, so we end up with a
#data frame of X rows and N columns, where X is the number of combinations of subject and activity
subjList <- split(keepdata, keepdata$SubjectID) #break into groups by subject
avgList <- lapply(subjList, colAvgs) #now for each group do column averages for each ActivityName

#then recombine sub-tables in single data table
cleanTable <- do.call('rbind', avgList)
#TODO: subjectID column is duplicated - for now, remove here, but should fix cause
cleanTable <- cleanTable[, -3]

#write to ASCII file, tab-delimited
write.table(cleanTable, file='UCI_HAR_reduced.txt', row.names=FALSE, sep='\t')

