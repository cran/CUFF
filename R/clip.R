### Send a table-like object to clipboard (Windows only).

clip  <- function(x, sep = "\t", row.names = FALSE, quote = FALSE, ...){    
    if (Sys.info()['sysname'] %in% c("Windows")) {
        write.table(x, file = "clipboard", sep = sep,
                    row.names = row.names, quote = quote, ...)
    }
    else {
        ## solution for unix taken from
        ## https://stackoverflow.com/questions/10959521/how-to-write-to-clipboard-on-ubuntu-linux-in-r
              
        ## https://stackoverflow.com/a/10960498/3980197
        write.xclip = function(x) {
            ## if xclip not installed
            if (!isTRUE(file.exists(Sys.which("xclip")[1L]))) {
                stop("Cannot find xclip")
            }
            con <- pipe("xclip -selection c", "w")
            on.exit(close(con))
            write.table(x, con, sep = sep,
                        row.names = row.names, quote = quote, ...)
        }

        tryCatch({
            write.xclip(x)
        }, error = function(e) {
            message("Could not write using xclip")
        })
    }
}





