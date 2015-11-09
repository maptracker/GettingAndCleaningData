## Running time tests on hash functions
## bench <- source("benchmarkDigest.R")$value

(function(){
    
    library("microbenchmark")
    library("ggplot2")
    ## Needed to specify unit lengths:
    library(grid)
    
    library(digest)
    source("https://gist.github.com/maptracker/07390983253758614ecc/raw/5995a7c1112420b64ff33dcb1e7dac679d05dbf9/randomMatrix.R")

    matSz <- 200
    reps  <- 2000
    image <- 'HashFunctionBenchmarks.png'
    if (file.exists(image)) unlink(image)
    
    message(paste("Running",reps,"repititions, digesting serialized",
                  matSz,"x",matSz,"matrices"))

bench <- microbenchmark( MD5     = digest( randomMatrix( matSz ), "md5" ),
                        SHA1     = digest( randomMatrix( matSz ), "sha1" ),
                        CRC32    = digest( randomMatrix( matSz ), "crc32" ),
                        SHA256   = digest( randomMatrix( matSz ), "sha256" ),
                        SHA512   = digest( randomMatrix( matSz ), "sha512" ),
                        XXHash32 = digest( randomMatrix( matSz ), "xxhash32" ),
                        XXHash64 = digest( randomMatrix( matSz ), "xxhash64" ),
                        Murmur32 = digest( randomMatrix( matSz ), "murmur32" ),
                        times = reps )

    summary(bench)
    ## Get the mean times for each algorithm
    means <- sapply(split(bench$time, bench$expr), mean)
    ## Sort the algorithms from fastest to slowest:
    sorted <- names(sort(means))
    ## Reset factor levels by sorted list
    ## https://learnr.wordpress.com/2010/03/23/ggplot2-changing-the-default-order-of-legend-labels-and-stacking-of-data/
    bench$expr <- factor(bench$expr, levels = sorted)
    
    gg   <- ggplot(bench, aes(expr, time / 1e6))
    plot <- gg +
        geom_violin(linetype = "blank", fill = "#ff0000") +
        ylab("Elapsed time (msec)") +
        xlab("digest() Algorithm") +
        ggtitle(paste("Comparison of hash algorithm speeds,", reps,
                      "random serialized",  matSz,"x",matSz,"matrices"))

    ## Worked ok, but decided to use above labeling paradigm:
    ## plot <- update_labels(plot, list(x = "Digest Algorithm",
    ##                                 y = "Elapsed time - log(msec)"))

    ## coord_flip() and annotation_logticks() do not play nicely!
    ## plot + coord_flip() + scale_y_log10()

    ## short / mid / long = have minor ticks extend across whole plot
    
    draw <- plot +
        scale_y_log10( limits = c(NA,30)) +
        annotation_logticks( sides = "l", color = "blue",
                            short = unit(100, "cm"),
                            mid   = unit(100, "cm"),
                            long  = unit(100, "cm"),
                            linetype = "dotted", size = 0.1)
    draw
    ggsave(image, plot = draw, width = 9, height = 6, dpi = 100 )

    message(paste("Benchmarks written to", image,"in", getwd()))
    bench
})()
