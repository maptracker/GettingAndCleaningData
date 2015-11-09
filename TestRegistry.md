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

* **Started** : 2015-11-09 15:23:10
* **HashAlgorithm** : sha256
* **Experiment Rational** : Compare speeds of hashing algorithms in digest()
* **Conclusion** : While SHA-256 is slower than the other algorithms, it is only margnially so, and provides increased collision resistance compared to MD5
* **Finished** : 2015-11-09 15:23:10

## Files ##

1. [HashFunctionBenchmarks.png](./HashFunctionBenchmarks.png)<br>
   **22.803 kb** *Plot of benchmarks, PNG*<br>
   `e55a7b0d33666b7c0664fb0489bac153cc578fc88fd69a3997a7561e2ec6bfde`
1. [benchmarkDigest.R](./benchmarkDigest.R)<br>
   **2.931 kb** *Script for generating hashing benchmarks from the digest() function*<br>
   `39cb555a079da190dd93c5d891bf295ec9c6f15c0c22c128fa73a2190aca8e35`
