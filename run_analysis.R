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

### *** Functions *** ###
    
    run <- function() {
        ## This is the main function to wrap everything together

        ## Find the columns that we want (mean / standard deviation)
        feats <- parseFeatures()
        feats
    }

    parseFeatures <- function() {
        ## Find the raw columns that we are interested in
        featuresDotTxt <- file.path(dataDir, "features.txt")
        
        if (!file.exists(featuresDotTxt)) {
            stop(paste("Failed to find features file:", featuresDotTxt))
        }

        ## We will build the code book as we find the columns we want:
        codeBook <- file.path(dataDir, "CodeBook.md")
        ## I have boilerplate for the "top" of the code book:
        codeIntro <- file.path(dataDir, "CodeBookIntroOnly.md")
        if (file.size( codeIntro )) {
            # Initiate the code book with the intro
            file.copy( from = codeIntro, to = codeBook )
        } else {
            message(paste("Did not locate code book intro: ", codeIntro))
        }
        cbCon <- file( codeBook, open = "a" )
        rv <- vector("list")
        feat <- read.table(featuresDotTxt,
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
            rv <- c(rv, info)
        }
        close(cbCon)
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

        plen <- length(parts)
        if (plen > 2) {
            ## If we have more than two "parts", stick the remainder onto nice
            for (i in seq(from = 3, to = plen)) {
                nice <- paste(nice, parts[[i]], sep = '-')
            }
        }
        ## Return the nice name, its type, and the original column name
        list( metric = nice, type = type, original = fname,
             full = paste(nice, type, sep = '-'))
    }

### *** Run the code, return final value *** ###
    run() 
    
})()
## Above is the end of the anonymous function block, with terminal
## "()" to cause it to execute.
