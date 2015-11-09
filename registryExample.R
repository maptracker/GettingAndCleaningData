## Example usage for registryManager
source("registryManager.R")
regman <- createFileRegistry( path = "TestRegistry.md")

## Will not work if you don't have the added files available...

regman$addFile( "HashFunctionBenchmarks.png", "Plot of benchmarks, PNG")
## Should gripe and not do anything:
regman$addFile( "HashFunctionBenchmarks.png", "My benchmarks")
regman$addFile( "benchmarkDigest.R", "Script for generating hashing benchmarks from the digest() function")

## Set some parameters:
regman$param("Experiment Rational", "Compare speeds of hashing algorithms in digest()")
regman$param("Conclusion", "While SHA-256 is slower than the other algorithms, it is only margnially so, and provides increased collision resistance compared to MD5")

## Set the introduction block:
regman$setIntro("Benchmarking using microbenchmark() to compare the relative speeds of the available algorithms in digest(). Comparison is being run to choose a default algorithm for registryManager.")

## Write the file:
regman$writeRegistry()

