# File Registry #

This document records one or more files.
Each [file path](#) is listed with the **size in kilobytes**,
a *user supplied description*,
and the `hexadecimal hash digest` of the file.

## Registry Description ##

Benchmarking using microbenchmark() to compare the relative speeds of
the available algorithms in digest(). Comparison is being run to choose
a default algorithm for registryManager.

## Parameters ##

* **Started** : 2015-11-09 15:41:47
* **HashAlgorithm** : sha1
* **Experiment Rational** : Compare speeds of hashing algorithms in digest()
* **Conclusion** : While SHA-1 is slower than the other algorithms, it is only margnially so, and provides increased collision resistance compared to MD5
* **Finished** : 2015-11-09 15:41:47

## Files ##

1. [HashFunctionBenchmarks.png](./HashFunctionBenchmarks.png)<br>
   **22.803 kb** *Plot of benchmarks, PNG*<br>
   `d044c47e386499ffbecdedeb57379d3e2c86ad06`
1. [benchmarkDigest.R](./benchmarkDigest.R)<br>
   **2.931 kb** *Script for generating hashing benchmarks from the digest() function*<br>
   `321439262948049ea3c887dcfe443d0230522a2d`
