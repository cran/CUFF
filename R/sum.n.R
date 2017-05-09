### -*-      Coding: utf-8   -*-       ###
### Analyste: Charles-Édouard Giguère. ###

### Sum that is weighted by the number of non missing values.
### if less value than n are missing it returns NA.

sum.n <- function (x, n = 1, ...){
    n.val <- sum(!is.na(x))
    l.val <- length(x)
    if (n.val >= n){
        return(mean(x, na.rm = TRUE, ...) * l.val)
    }
    else{
        return(NA)
    }
}

