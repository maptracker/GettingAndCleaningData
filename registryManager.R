### This script is designed to help automate tracking of "important
### files" used during an R session

## Usage:
##   source("registryManager.R")
##   regman <- createFileRegistry( path = "TestRegistry.md")
##   regman$addFile( "HashFunctionBenchmarks.png", "Plot of benchmarks, PNG")
##   ## Should gripe and not do anything:
##   regman$addFile( "HashFunctionBenchmarks.png", "My benchmarks")
##   regman$addFile( "benchmarkDigest.R", "Script for generating hashing benchmarks from the digest() function")
##   regman$param("Experiment Rational", "Compare speeds of hashing algorithms in digest()")
##   regman$param("Conclusion", "While SHA-256 is slower than the other algorithms, it is only margnially so, and provides increased collision resistance compared to MD5")
##   regman$setIntro("Benchmarking using microbenchmark() to compare the relative speeds of the available algorithms in digest(). Comparison is being run to choose a default algorithm for registryManager.")
##   regman$writeRegistry()

library(digest)

## I am not convinced that I am packaging this up properly. I had some
## weird errors where re-running the script failed to add files to the
## registry because they had already been added. This implies that I
## am mangling scope somewhere. Lexical scoping is bizzare.

createFileRegistry <- function( algo = "sha1", path = "FileRegistry.md" ) {

    regFile  <- path
    params   <- list( Started = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
                     HashAlgorithm = algo )
    registry  <- NULL
    introText <- NULL
    naChar    <- as.character(NA)
    nferr     <- "As-yet unverified data parsed from registry file"
    
    addFile <- function(file = NA, desc = NA, dir = '.') {
        if (is.na(file)) {
            stop("RegistryManager: Attempt to addfile without file argument")
        }
        path <- file.path(dir, file)
        if (!file.exists(path)) {
            stop(paste("RegistryManager: File not found! ", path))
        }
        if (is.na(desc)) {
            stop("You must provide a description for your file")
        }
        hash <- digest( file = path, algo = algo)
        sz   <- file.size(path)
        row  <- .newRow(file = file,  dir = dir, size = sz,
                        desc = desc,  hash = hash, verified = TRUE,  error = "")
        .addRegistryRow( row )
        ## Return the generated hash value
        hash
    }

    .newRow <- function (file, dir, size = as.double(NA), desc = naChar,
                         hash = naChar, verified = FALSE,
                         error = "No error given!") {
        path <- file.path(dir, file)
        data.frame(file = file,  dir = dir, path = path,  size = size,
                   desc = desc,  hash = hash, verified = verified,
                   error = error, stringsAsFactors = FALSE)
    }

    .addRegistryRow <- function( row ) {
        if (is.null(registry)) {
            registry <<- row
        } else {
            if (row$path %in% registry$path) {
                ## This file is already registered
                message(paste("File already added to registry:", path))
            } else {
                registry <<- rbind( registry, row )
            }
        }
    }

    setIntro <- function( text = NA ) introText <<- text
    getIntro <- function() introText

    registryList <- function() registry

    numFiles <- function() {
        if (is.null(registry)) { 0 } else { nrow(registry) }
    }

    param <- function( tag = NA, val = NA ) {
        if (is.na(tag)) {
            stop("Must pass a non-NA tag to setParam()")
        }
        if (!is.na(val)) {
            params[ tag ] <<- val
        }
        params[ tag ]
    }

    writeRegistry <- function() {
        ## Write the registry as a markdown file
        fh <- file( regFile, open = "wt")
        ## Write top boilerplate
        intro <- c("# File Registry #\n",
                   "This document records one or more files.",
                   "Each [file path](#) is listed with the **size in kilobytes**,",
                   "a *user supplied description*,",
                   "and the `hexadecimal hash digest` of the file.",
                   "The registry could be validated against current files with:",
                   "", "```R", 'source("registryManager.R")',
                   sprintf("regMan <- createFileRegistry( path = '%s' )", regFile),
                   "regLines <- regMan$readRegistry()",
                   "failed <- regMan$verifyRegistry()",
                   "```"
                   )
        
        writeLines(text = intro, con = fh)

        ## Add user intro, if provided:
        if (!is.na(introText)) writeLines(text = c("\n## Registry Description ##\n",strwrap(introText)), con = fh)

        ## Write parameter block:
        params$Finished <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
        tags <- names(params)
        writeLines(text = "\n## Parameters ##\n", con = fh)
        for (tag in tags) {
            writeLines(text = sprintf("* **%s** : %s", tag, params[tag]),
                       con = fh)
        }
        
        if (is.null(registry)) {
            ## No files were provided
            writeLines(text = "\n*No files were registered!*", con = fh)
        } else {
            ## Make a numbered list of files
            ## 1. `<dir/file>`
            ##    **<size> kb** *<user comment>*
            ##    `<hash>`
            numFiles <- nrow( registry )
            writeLines(text = "\n## Files ##\n", con = fh)
            for (i in seq_len(numFiles)) {
                ## Get the row representing this entry:
                entry <- registry[i, ]
                writeLines(text = sprintf("1. [%s](%s/%s)<br>",
                                          entry$file,entry$dir,
                                          entry$file), con = fh)
                writeLines(text = sprintf("   **%.3f kb** *%s*<br>",
                                          entry$size/1000, entry$desc),
                           con = fh)
                writeLines(text = sprintf("   `%s`", entry$hash), con = fh)

            }
        }
        message(paste("File registry written to:", regFile))
        close(fh)
        regFile
    }

    .parenRE <- function(RegExp, text) {
        ## RegExp in R is not fully fleshed out. This implements a
        ## hack suggested in the internal documentation to allow
        ## recovery of text from multiple parenthetical captures
        m <- lapply(regmatches(text, gregexpr(RegExp, text)), function(e) {
            regmatches(e, regexec(RegExp, e))
        })
        hitList <- m[[1]]
        ## Return NA if the match failed
        if (length(hitList) == 0) return(NA)
        ## Otherwise, extract out the character vector of the matches,
        ## and exclude the first entry
        hitList[[1]][-1]
    }

    readRegistry <- function () {
        ## Make sure the file exists and is non-empty
        if (!file.exists(regFile)) {
             stop(paste("readRegistry() failed to find file:", regFile))
        } else if (!file.size(regFile)) {
             stop(paste("readRegistry() found file, but it is empty:", regFile))
        }
        message(paste("Reading registry", regFile))
        fh <- file( regFile, open = "rt")
        lines <- readLines( fh )
        close(fh)

        ## Parse the lines from the file
        lineHandler <- function( line ) { } # Start by doing nothing
        
        for (i in seq_len(length(lines))) {
            line <- lines[i]
            if (grepl("^\\s*$",line)) {
                ## Ignore blank lines
                next
            } else if (!is.na(m <- .parenRE('## (Registry Description|Parameters|Files) ##', line))) {
                ## We have just entered a new block
                message(paste("  Parsing Block:", m))
                if (m == "Registry Description") {
                    introText <<- NULL
                    lineHandler <- .LineHandlerIntro
                } else if (m == "Parameters") {
                    lineHandler <- .LineHandlerParams
                } else if (m == "Files") {
                    lineHandler <- .LineHandlerFiles
                } else {
                    message("    Unrecognized block! No code available!")
                    lineHandler <- function( line ) {
                        message(paste("      IGNORED:", line))
                    }
                }
            } else {
                lineHandler(line)
            }
        }
        if (!is.na(foundAlg <- params$HashAlgorithm)) {
            ## Capture the algorith as stored in the parameters
            algo <<- foundAlg
            message(paste("  Hash algorithm set to", foundAlg))
        }
        message(paste("  Done. Parsed", nrow(registry),"files from registry"))
        ## Return the parsed lines, because why not.
        lines
    }
    
    .LineHandlerIntro <- function (line) {
        ## Parser for the Registry Description block
        ## The description is just a (line wrapped) single
        ## string. Read it in.
        if (is.null(introText)) {
            ## First line of text in the block
            setIntro( line )
        } else {
            ## Extend the line
            setIntro( paste(introText, line ))
        }
    }
    
    .LineHandlerParams <- function (line) {
        ## RegExp parser for the Parameters block
        ## Parse out the key/val pairs for the parameters
        if (!any(is.na(kv <- .parenRE('^\\* \\*\\*(.+?)\\*\\* : (.+)$', line)))) {
            ## Set the parameter pair
            param(tag = kv[1], val = kv[2])
        } else {
            message(paste("    Unexpected line in parameter block:", line))
        }
    }
    

    .LineHandlerFiles <- function (line) {
        ## RegExp parser for the Files block
        ## This is why we have a registry in the first place
        ## Parse out the files and their metadata
        if (!any(is.na(dirFile <- .parenRE('^1\\. \\[.+\\]\\((.+)\\/([^\\)]+?)\\)<br>\\s*$', line)))) {
            ## We have encountered a new file entry
            row  <- .newRow(file  = dirFile[2],
                            dir   = dirFile[1],
                            error = nferr)
            .addRegistryRow( row )
        } else {
            if (is.null(registry)) {
                stop(paste("    ERROR! Encounted a Files line before registry is set up!", line))
            }
            priorRow = nrow(registry)
            if (!any(is.na(hash <- .parenRE('^\\s+`(.+)`\\s*$', line)))) {
                ## We have found a hash row
                if (is.na(registry$hash[priorRow])) {
                    ## Good, the slot is still NA
                    registry$hash[priorRow] <<- hash
                } else {
                    str(registry[[priorRow]])
                    stop(paste("    ERROR! Attempt to reset hash value in Files block!", line))
                }
            } else if (!any(is.na(szDesc <- .parenRE('^\\s+\\*\\*\\s*([0-9\\.]+)\\s*kb\\*\\*\\s+\\*(.+)\\*<br>\\s*$', line)))) {
                ## We have found a size/description row
                
                if (is.na(registry$size[priorRow])) {
                    ## Good, the slot is still NA
                    registry$size[priorRow] <<- as.double(szDesc[1]) * 1000
                } else {
                    str(registry[[priorRow]])
                    stop(paste("    ERROR! Attempt to reset file size in Files block!", line))
                }
                if (is.na(registry$desc[priorRow])) {
                    ## Good, the slot is still NA
                    registry$desc[priorRow] <<-szDesc[2]
                } else {
                    str(registry[[priorRow]])
                    stop(paste("    ERROR! Attempt to reset description in Files block!", line))
                }
            } else {
                message(paste("    Unexpected line in files block:", line))
            }
        }
    }

    verifyRegistry <- function() {
        if (is.null(registry)) {
            message("Registry is empty, verification passes by default")
            return(NULL)
        }
        ## Check each file to assure it is present and has appropriate
        ## hash digest. Scott believes it is faster to build a new DF
        ## and assign it monolithically to 'registry'; Benchmarking
        ## implies that this may be true, although marginally
        numFiles <- nrow( registry )
        newReg   <- data.frame()
        for (i in seq_len(numFiles)) {
            newReg <- rbind(newReg, .verifyRow( i ));
        }
        ## For a return value, provide a DF of problematic rows
        failed    <- newReg[ !newReg$verified, ]
        registry <<- newReg
        numFailed <- nrow(failed)
        if (nrow(failed) == 0) {
            ## We will return NULL if everything is OK
            failed <- NULL
            message("All", numFiles, "files in registry have been verified")
        } else {
            message(paste("!!", numFailed,"of", numFiles,
                          "files failed verification!"))
        }
        failed
    }
    
    .verifyRow <- function( i ) {
        ## Scott says I should break this out as a separate function.
        ## This call will check that a file exists and has the right
        ## hash value. First get the row representing this entry:
        entry  <- registry[i, ]
        verify <- FALSE
        error  <- "Error was not set during verification!"
        path   <- entry$path
        
        if (!file.exists(path)) {
            error <- "File not found"
        } else {
            check <- digest( file = path, algo = algo)
            if (identical(check, entry$hash)) {
                verify <- TRUE
                error  <- ""
            } else {
                error <- paste("Checksum does not match:", check)
            }
        }
        entry["verified"] <- verify
        entry["error"]    <- error
        ## Return this row:
        entry
    }

### Finally, the return value for createFileRegistry() is a list of
### functions that will be used by the RegistryManager "object":
    
    list(addFile        = addFile,
         registryList   = registryList,
         numFiles       = numFiles,
         param          = param,
         setIntro       = setIntro,
         getIntro       = getIntro,
         writeRegistry  = writeRegistry,
         readRegistry   = readRegistry,
         verifyRegistry = verifyRegistry)
}
