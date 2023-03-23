### -*- Coding: utf-8 -*-
### Author: Charles-Édouard Giguère
###
### Send a table-like object to clipboard.

clip <- function(x, sep = "\t", row.names = FALSE, quote = FALSE, ...){
    if(!is.matrix(x) & !is.data.frame(x)){
        x <- try(as.data.frame(x), silent = TRUE)
        if(inherits(x, "try-error"))
            stop("x cannot be coerced to a data.frame object")
    }

    clipr::write_clip(x, sep = sep, row.names = row.names, quote = quote,
                      object_type = "auto", ...)
}


