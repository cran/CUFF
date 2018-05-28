###     -*- Coding: utf-8 -*-          ###
### Analyste Charles-Édouard Giguère   ###

### fonction pour afficher les proportions.
ftab <- function(xt, margin = seq_along(dim(xt)), fmt = "%d (%5.1f %%)", quiet = FALSE){
    ## Si ce n'est pas une table on sort.
    if(!is.table(xt))
        stop("xt must be a table")

    ## Table 1d: On affiche les N et les proportions plus le total.
    if(length(dim(xt)) %in%  1){
        xts <- as.table(matrix(addmargins(xt), ncol = 1,
                               dimnames = list(c(names(xt),"Total"),
                                               "N(%)")))
        xts[] <- sprintf(fmt,
                         addmargins(xt),
                         addmargins(prop.table(xt)*100)
                         )
        if(!quiet)
            print(xts, right = TRUE)
        invisible(xts)
    }
    ## Table 2d: on affiche soit le % dans chaque cellules et on fait
    else if(length(dim(xt)) %in%  2){
        xts <- addmargins(prop.table(xt)*100, FUN = Total, quiet = TRUE)
        xts[] <- sprintf(fmt,
                       addmargins(xt),
                       addmargins(prop.table(xt))*100)
        if(is.null(names(dimnames(xts))))
            names(dimnames(xts)) <- list("","")
        if(length(margin) == 1 & margin[1] == 1){
            names(dimnames(xts))[2] <- sprintf("%s N(%% %s)",
                                               names(dimnames(xts))[2],
                                               "In row")
            xts[1:dim(xt)[1], 1:dim(xt)[2]] <- sprintf(fmt,
                                                       xt,
                                                       prop.table(xt,margin = 1 )*100)
        } else if(length(margin) == 1 & margin[1] == 2){
            names(dimnames(xts))[2] <- sprintf("%s N(%% %s)",
                                               names(dimnames(xts))[2],
                                               "In col")
            xts[1:dim(xt)[1], 1:dim(xt)[2]] <- sprintf(fmt,
                                                       xt,
                                                       prop.table(xt,margin = 2 )*100)
        }
        else
            names(dimnames(xts))[2] <- sprintf("%s N(%%)",names(dimnames(xts))[2])

        if(!quiet)
            print(xts, right = TRUE)
        invisible(xts)
    }

}
