## Coursera assignment from:

## https://class.coursera.org/getdata-034/human_grading/view/courses/975118/assessments/3/submissions

(function(){
    ## This is an anonymous code block that runs when this file is
    ## sourced. It is a trick to keep all your variables locally scoped
    ## inside the function. The very last statement to be evaluated
    ## will be returned in the source call. Just run:

    ## retVal <- source("run_analysis.R")$value

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

### *** Functions *** ###
    
    run <- function() {
        ## This is the main function to wrap everything together

        ## Find the columns that we want (mean / standard deviation)
        feats <- parseFeatures()
        tidy <- buildTidyFiles( feats )
        tidy
        feats
    }

    parseFeatures <- function() {
        ## Find the raw columns that we are interested in
        file <- file.path(dataDir, "features.txt")
        
        if (!file.exists(file)) {
            stop(paste("Failed to find features file:", file))
        }

        ## We will build the code book as we find the columns we want:
        codeBook <- "CodeBook.md"
        ## I have boilerplate for the "top" of the code book:
        codeIntro <- "CodeBookIntroOnly.md"
        if (file.size( codeIntro )) {
            ## Initiate the code book with the intro
            file.copy( from = codeIntro, to = codeBook )
        } else {
            message(paste("Did not locate code book intro: ", codeIntro))
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
        feat <- read.table(file,
                           colClasses = c("integer", "character"))
        for (i in seq_len(nrow(feat))) {
            ## Parse the metric name
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
        message(sprintf("%d columns captured from %s", nrow(rv), file))
        close(cbCon)
        message(sprintf("Code Book written to %s", codeBook))
        rv
    }

    activityLookup <- function() {
        ## Generate a code-to-text lookup for activities
        ## Read the file into a data frame
        file <- file.path(dataDir, "activity_labels.txt")
        if (!file.exists(file)) {
            stop(paste("Failed to find activity label file:", file))
        }
        acts  <- read.table(file, colClasses = c("integer", "character"))
        ## Set up the return value, which will be a character vector
        nActs <- nrow(acts)
        actNames <- vector(mode = "character", length = nActs)
        for (i in seq_len(nActs)) {
            ## So the file is already sorted, but to be safe we will
            ## explicitly read the code integer and use it directly
            actNames[ acts[[1]][i] ] <- acts[[2]][ i ]
        }
        numNames <- length(actNames)
        message(sprintf("%d activities read from %s", numNames, file))
        
        function (index) {
            if (is.integer(index) & index > 0 & index <= numNames) {
                return(actNames[ index ])
            }
            message(sprintf("Unrecognized activity index '%s'", index))
            return("UNKNOWN")
        }
    }

    buildTidyFiles <- function( feats ) {
        ## Get the activity lookup
        actLU <- activityLookup()
        fooDebug <<- actLU
        myFrames <- list()
        for (arm in trainOrTest) {
            ## Make sure we have the expected directory!
            armDir <- file.path(dataDir, arm);
            if (!dir.exists(armDir)) {
                stop(sprintf("Failed to find %s directory at %s", arm, armDir))
            }


            ## Get the subject IDs
            subFile <- sprintf("%s/subject_%s.txt", armDir, arm)
            if (!file.size(subFile)) {
                stop(sprintf("Failed to find subject file at %s", subFile))
            }
            subCol <- read.table(subFile, colClasses = c("factor"))

            ## Get the activities
            actFile <- sprintf("%s/y_%s.txt", armDir, arm)
            if (!file.size(actFile)) {
                stop(sprintf("Failed to find activity file at %s", actFile))
            }
            actCol  <- read.table(actFile, colClasses = c("integer"))
            actNames <- sapply( actCol[[ 1 ]], actLU )

            ## Create a data frame for this arm of the study:
            thisArm <- data.frame( SubjectID = subCol[[ 1 ]],
                                  Activity = actNames,
                                  DataSet = rep(arm, length(actNames)))

            ## Now, read the core of the data
            dataFile <- sprintf("%s/X_%s.txt", armDir, arm)
            if (!file.size(dataFile)) {
                stop(sprintf("Failed to find main data file at %s", dataFile))
            }
            rawData <- read.table(dataFile)

            ## We will use feats to pull out the columns we want
            ## We will chose the columns by their index number using dplyr
            wantedData <- select(rawData, feats$col)
            ## Now assign our "nice" names to the columns
            names(wantedData) <- feats$full

            ## And finally we want to merge these columns in with what
            ## we alreaddy have in the data frame
            thisArm <- cbind(thisArm, wantedData)
            ## Store this data.frame under the arm name in myFrames:
            myFrames[[ arm ]] <- thisArm
            message(sprintf("%d rows read from %s", nrow(thisArm), arm))
        }

        fullData <- rbind( myFrames$test, myFrames$train )
        str(fullData)
        actLU
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

        plen <- length(parts)
        if (plen > 2) {
            ## If we have more than two "parts", stick the remainder onto nice
            for (i in seq(from = 3, to = plen)) {
                nice <- paste(nice, parts[[i]], sep = '-')
            }
        }
        ## Return the nice name, its type, and the original column name
        data.frame( metric = nice, type = type, original = fname,
             full = paste(nice, type, sep = '-'), stringsAsFactors = FALSE)
    }

### *** Run the code, return final value *** ###
    run() 
    
})()
## Above is the end of the anonymous function block, with terminal
## "()" to cause it to execute.
