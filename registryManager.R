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

createFileRegistry <- function( algo = "sha1", path = "FileRegistry.md" ) {

    regFile  <- path
    params   <- list( Started = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
                     HashAlgorithm = algo )
    registry <- NULL
    introText <- NULL
    
    addFile <- function(file = NA, desc = NA, dir = '.') {
        if (is.na(file)) {
            stop("RegistryManager: Attempt to addfile without file argument")
        }
        path <- file.path(dir, file);
        if (!file.exists(path)) {
            stop(paste("RegistryManager: File not found! ", path))
        }
        hash <- digest( file = path, algo = algo)
        if (path %in% registry$path) {
            message(paste("File already added to registry:", path))
            return(hash)
        }
        if (is.na(desc)) {
            stop("You must provide a description for your file")
        }
        sz   <- file.size(path)
        row <- data.frame(file = file,  dir = dir,
                          path = path,  size = sz,
                          desc = desc,  hash = hash)
        if (is.null(registry)) {
            registry <<- row
        } else {
            registry <<- rbind( registry, row )
        }
        hash
    }

    setIntro <- function( text = NA ) introText <<- text

    registryList <- function() registry

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
                   "and the `hexadecimal hash digest` of the file.")
        
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
    }
    
    list( addFile = addFile,
         registryList = registryList,
         param = param,
         setIntro = setIntro,
         writeRegistry = writeRegistry)
}
