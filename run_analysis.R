## Coursera assignment from:

## https://class.coursera.org/getdata-034/human_grading/view/courses/975118/assessments/3/submissions

(function(){
    ## This is an anonymous code block that runs when this file is
    ## sourced. It is a trick to keep all your variables locally scoped
    ## inside the function. The very last statement to be evaluated
    ## will be returned in the source call. Just run:

    ## data <- source("run_analysis.R")$value

### *** Some shared variables *** ###

    ## Where we expect to find the data. Relative to this script!!
    dataDir <- "UCI HAR Dataset"
    if (!dir.exists( dataDir) ) {
        stop(paste("Failed to find data directory:", dataDir))
    }
    
    ## The two arms of the data
    trainOrTest <- c("train", "test")
    
    ## The parameters we want
    desiredParameters <- c("std", "mean")

    ## Handy empty objects
    nullChar <- vector("character")
    nullList <- list()

    if (!require("dplyr")) {
        stop("This script requires dplyr to run. You can install it with install.packages('dplyr')")
    }

    ## I have been working on R code to automatically create a file
    ## registry. This is part of an Reproducible Research initiative
    ## at work. The regMan object below will help construct a MarkDown
    ## file that lists all relevant files.

    source("registryManager.R")
    regMan <- createFileRegistry( )
    regMan$setIntro("This registry describes both the input and output files used for the Coursera 'Getting and Cleaning Data' course.")
    
    regMan$param("CourseraURL", "https://class.coursera.org/getdata-034/human_grading/view/courses/975118/assessments/3/submissions")
    regMan$param("CourseraTitle", "Getting and Cleaning Data")
    regMan$param("CourseraDate", "November 2015")
    
    regMan$addFile( file = "run_analysis.R",
                   desc = "The R script used to process input into output")
    regMan$addFile( file = "registryManager.R",
                   desc = "The R script used to create this registry page")
    regMan$addFile( file = "README.md",
                   desc = "An introduction to the project")
    
### *** Functions *** ###
    
    run <- function() {
        ## This is the main function to wrap everything together

        ## Find the columns that we want (mean / standard deviation)
        feats <- parseFeatures()
        ## Read in all the data we want
        data  <- readRawData( feats )
        ## Generate tidy files from the data
        tidy  <- buildTidyFiles( data )
        ## Generate the file registry:
        regFile <- regMan$writeRegistry()
        ## When sourcing is complete, the full data frame will be
        ## returned to the user:
        data
    }

    parseFeatures <- function() {
        ## Find the raw columns that we are interested in with the
        ## awesome power of regular expressions

        ## Make sure we have the file we neeed
        file <- "features.txt"
        path <- file.path(dataDir, file)
        
        if (!file.exists(path)) {
            stop(paste("Failed to find features file:", path))
        }
        regMan$addFile( file = file, dir = dataDir,
                       desc = "Input data: Column headers for raw data files")
        
        ## We will build the code book as we find the columns we want:
        codeBook <- "CodeBook.md"
        ## I have boilerplate for the "top" of the code book:
        codeIntro <- "CodeBookIntroOnly.md"
        if (file.size( codeIntro )) {
            ## Initiate the code book with the intro
            file.copy( from = codeIntro, to = codeBook, overwrite = TRUE )
            regMan$addFile( file = codeIntro,
                           desc = "Output template: Hand-written 'intro' for the 'top' of the Code Book")
       } else {
            message(paste("Did not locate code book intro: ", codeIntro))
           ## If an old file is present remove it:
            if (file.size(codeBook)) file.remove(codeBook)
        }
        cbCon <- file( codeBook, open = "a" )

        ## This structure will hold information about the columns we
        ## wish to extract:
        rv <- data.frame( col   = vector("integer"),
                         type   = vector("character"),
                         metric = nullChar,
                         full   = nullChar,
                         original = nullChar,
                         desc     = nullChar,
                         stringsAsFactors = FALSE)
        feat <- read.table(path,
                           colClasses = c("integer", "character"))
        for (i in seq_len(nrow(feat))) {
            ## Parse the metric name (function defined below)
            info <- parseFeatureName( feat[[2]][[i]] )
            ## Skip if it is not of interest
            if (!length(info)) next
            
            ## Note the column number that it comes from. Take this
            ## directly from the first column, not as i; They *should* be
            ## the same, but I have not checked:
            info$col <- feat[[1]][[i]]
            
            ## Build a description for the Code Book:
            niceType <- if (info$type == 'mean')
            { "mean" } else { "standard deviation" }
            info$desc <- sprintf("The %s of %s, taken from column number %d in the `X_test.txt` or `X_train.txt` files (original column identifier '%s')", niceType, info$metric, info$col, info$original)

            ## Add the description to the code book
            writeLines( sprintf("1. **%s** - %s", info$full, info$desc), cbCon)

            ## Extend our return value with this column information:
            rv <- rbind(rv, info)
        }
        close(cbCon)
        regMan$addFile( file = codeBook,
                       desc = "Output: Code Book describing data sets, with manually written introduction and auto-generated column listing")

        message(sprintf("%d columns captured from %s", nrow(rv), path))
        message(sprintf("  Code Book written to %s", codeBook))
        rv
    }

    parseFeatureName <- function( fname ) {
        ## I do not like the parens or commas, so remove them. eg:
        ## tBodyAcc-arCoeff()-Z,4  ---> tBodyAcc-arCoeff-Z4

        cleaned <- gsub("[\\(\\),]", "", fname)
        
        ## Split on dashes:
        parts <- strsplit(cleaned, '-')[[1]]
        nice <- parts[1]
        type <- parts[2]
        
        ## If the type is not something we want, return an empty list
        if (! type %in% desiredParameters ) return( nullList )

        nameSep <- '_'
        ## NOTE: Using dash (-) as a separator seems to cause problems
        ## with dplyr, because when using "naked" column names it is
        ## treated as a subtraction operator.
        
        plen <- length(parts)
        if (plen > 2) {
            ## If we have more than two "parts", stick the remainder onto nice
            for (i in seq(from = 3, to = plen)) {
                nice <- paste(nice, parts[[i]], sep = nameSep)
            }
        }
        ## Return the nice name, its type, and the original column name
        data.frame( metric = nice, type = type, original = fname,
             full = paste(nice, type, sep = nameSep), stringsAsFactors = FALSE)
    }

    activityLookup <- function() {
        ## Generate a code-to-text lookup for activities
        ## Read the file into a data frame
        file <- "activity_labels.txt"
        path <- file.path(dataDir, file)
        if (!file.exists(path)) {
            stop(paste("Failed to find activity label file:", path))
        }
        regMan$addFile( file = file, dir = dataDir,
                       desc = "Input data: Activity factors, relating integer ID to human-readable name")
        
        acts  <- read.table(path, colClasses = c("integer", "character"))
        ## Set up the return value, which will be a character vector
        nActs <- nrow(acts)
        actNames <- vector(mode = "character", length = nActs)
        for (i in seq_len(nActs)) {
            ## So the file is already sorted, but to be safe we will
            ## explicitly read the code integer and use it directly
            actNames[ acts[[1]][i] ] <- acts[[2]][ i ]
        }
        numNames <- length(actNames)
        message(sprintf("%d activities read from %s", numNames, path))

        ## Returned value is a function that takes an index and
        ## returns the appropriate activity string:
        function (index) {
            if (is.integer(index) & index > 0 & index <= numNames) {
                ## Yay, found it
                return(actNames[ index ])
            }
            ## Boo, unrecognized index. Could stop() here, I suppose.
            message(sprintf("Unrecognized activity index '%s'", index))
            return("UNKNOWN")
        }
    }

    buildTidyFiles <- function( data ) {
        ## Generate the desired tidy files given the merged data file
        full     <- "SamsungHumanActivity_Full.tsv"
        fullPath <- file.path(full)
        write.table(data, file = fullPath, sep = "\t", row.names = FALSE)
        regMan$addFile( file = full,
                       desc = "Output: Full tidy data file, including all rows from test and train sets, with selected mean and std columns")
        message(paste("Full data set written:", fullPath))

        ## dplyr operations:
        ## Group the data by subject and activity
        bySubAct <- group_by(data, SubjectID, Activity)

        ## Get the numeric columns (exclude the first three headers)
        meanNames <- names(subAct)[ -(1:3) ]

        ## Calculate counts for each grouping pair
        bySubAct <- mutate(bySubAct, Count = n() )

        ## Finally, use summarize_each() to generate the mean for each
        ## column and each Subj/Act group. We exclude the DataSet
        ## category which is not of interest to us at this
        ## point. Also, Count will get mean()ed here, but that's ok
        ## since it should be the same for all rows in a Sub/Act pair.
        meanData <- summarize_each(bySubAct, "mean", -3)

        ## I want the count column "at the front":
        meanData <- ungroup(meanData)
        meanData <- meanData[ c("SubjectID", "Activity", "Count", meanNames) ]
        
        ## Write the mean data to disk:
        mf       <- "SamsungHumanActivity_Means.tsv"
        meanPath <- file.path(mf)
        write.table(meanData, file = meanPath, sep = "\t", row.names = FALSE)
        regMan$addFile( file = mf,
                       desc = "Output: Mean tidy data file, with data grouped by SubjectID and Activity, and values representing the mean within each group")
        message(paste("Mean data set written:", meanPath))
        
        list(full = fullPath,
             mean = meanPath)
    }
    
    readRawData <- function( feats ) {
        ## Get the activity lookup (used to map factor number to name):
        actLU <- activityLookup()
        myFrames <- list()

        message("Reading and merging kinematic data...")
        for (arm in trainOrTest) {
            ## Cycle through the two arms
            
            ## Make sure we have the expected directory!
            armDir <- file.path(dataDir, arm);
            armDirRel <- paste(dataDir, arm, sep="/") # Relative path
            if (!dir.exists(armDir)) {
                stop(sprintf("Failed to find %s directory at %s", arm, armDir))
            }
            


            ## Get the subject IDs
            subArm  <- sprintf("subject_%s.txt", arm)
            subFile <- file.path(armDir, subArm)
            if (!file.size(subFile)) {
                stop(sprintf("Failed to find subject file at %s", subFile))
            }
            subCol <- read.table(subFile, colClasses = c("factor"))
            regMan$addFile( file = subArm, dir = armDirRel,
                           desc = paste("Input data: Subject IDs for the",arm,
                                        "data arm"))

            ## Get the activities
            actArm  <- sprintf("y_%s.txt", arm)
            actFile <- file.path(armDir, actArm)
            if (!file.size(actFile)) {
                stop(sprintf("Failed to find activity file at %s", actFile))
            }
            actCol  <- read.table(actFile, colClasses = c("integer"))
            ## Map the activity IDs to names using our look-up:
            actNames <- sapply( actCol[[ 1 ]], actLU )
            regMan$addFile( file = actArm, dir = armDirRel,
                           desc = paste("Input data: Activity IDs for the",arm,
                                        "data arm"))

            ## Create a data frame for this arm of the study
            ## DataSet is just the arm for all rows
            thisArm <- data.frame( SubjectID = subCol[[ 1 ]],
                                  Activity = actNames,
                                  DataSet = rep(arm, length(actNames)))

            ## Now, read the core of the data
            dataArm  <- sprintf("X_%s.txt", arm)
            dataFile <- file.path(armDir, dataArm)
            if (!file.size(dataFile)) {
                stop(sprintf("Failed to find main data file at %s", dataFile))
            }
            rawData <- read.table(dataFile)
            regMan$addFile( file = dataArm, dir = armDirRel,
                           desc = paste("Input data: Primary raw data from the",arm,
                                        "data arm"))
            
            ## We will use feats to pull out the columns we want
            ## We will chose the columns by their index number
            wantedData <- rawData[,  feats$col ]
            ## Now assign our "nice" names to the columns
            names(wantedData) <- feats$full

            ## And finally we want to merge these columns in with what
            ## we alreaddy have in the data frame
            thisArm <- cbind(thisArm, wantedData)
            ## Store this data.frame under the arm name in myFrames:
            myFrames[[ arm ]] <- thisArm
            message(sprintf("  %d rows read from %s", nrow(thisArm), arm))
        }

        fullData <- rbind( myFrames$test, myFrames$train )
        message("Full data.frame generated : ")
        str(fullData)
        # Return the DF:
        fullData
    }

### *** Run the code, return final value (the full data.frame) *** ###
    run() 
    
})()
## Above is the end of the anonymous function block, with terminal
## "()" to cause it to execute.
