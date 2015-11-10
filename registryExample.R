## Example usage for registryManager
source("registryManager.R")
regFile <- "TestRegistry.md" # This is where the registry will be written
## Create the Registry Manager object:
regman <- createFileRegistry( path = regFile)

## This will throw errors if you don't have the files
## "HashFunctionBenchmarks.png" and "benchmarkDigest.R" available in
## the working directory...

## Add HashFunctionBenchmarks.png
regman$addFile( "HashFunctionBenchmarks.png", "Plot of benchmarks, PNG")
## Try to add it again: Should gripe and not do anything:
regman$addFile( "HashFunctionBenchmarks.png", "My benchmarks")
## Add a second file:
regman$addFile( "benchmarkDigest.R", "Script for generating hashing benchmarks from the digest() function")

## Set some parameters. These are for human consumption (ie will not
## be machine parsed)
regman$param("Experiment Rational", "Compare speeds of hashing algorithms in digest()")
regman$param("Conclusion", "While SHA-1 is slower than the other algorithms, it is only margnially so, and provides increased collision resistance compared to MD5")

## Set the introduction block:
regman$setIntro("Benchmarking using microbenchmark() to compare the relative speeds of the available algorithms in digest(). Comparison is being run to choose a default algorithm for registryManager.")

## Write the registry to a file
regman$writeRegistry()



## Let's validate the file. Create another manager:
check <- createFileRegistry( path = regFile)
## Read in the file we just created
lines <- check$readRegistry()
## Run through the registry and verify the existance of each file, and
## that the hash matches reality.
check$verifyRegistry()

