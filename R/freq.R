#### -*- Coding: utf-8 -*-
#### Methode pour afficher des frequences de facteur et les conserver dans des listes mais les afficher
#### dans un format interessant.

freq <- function(x, y = NULL, ..., labels = NULL, data = NULL){
    result <- list()
    class(result) <- "frequencies"
    if("formula" %in% class(x)){
        if(is.null(data) & !is.null(y))
            data <- y
        return(freq.formula(x, labels = labels, data=data))
    }
    if(is.matrix(x)){
        ## Changer x en data.frame
        x <- as.data.frame(x)
    }
    if(!is.data.frame(x) & !is.vector(x) & !is.factor(x))
    {
        stop("Object x not suitable for this command")
    }
    if(is.data.frame(x))
    {
        for(i in 1:dim(x)[2])
        {
            factlocal <- x[[i]]
            if(!is.factor(factlocal))
            {
                ### Convertir en facteur.
                factlocal <- factor(factlocal)
            }

            result[[i]] <- cbind(n = table(factlocal, useNA = "always"),
                                 "%" =c(prop.table(table(factlocal, useNA = "no")), NA),
                                 "% with NA" = prop.table(table(factlocal, useNA = "always")))
        }
    }
    if(is.vector(x) | is.factor(x))
    {
        factlocal <- x
        if(!is.factor(factlocal)){
            ## Convertir en facteur.
            factlocal <- factor(factlocal)
        }

        result[[1]] <- cbind("n" = table(factlocal,useNA="always"),
                             "%"=c(prop.table(table(factlocal,useNA="no")),NA),
                             "% with NA"=prop.table(table(factlocal,useNA="always")))
        if(!is.null(labels))
            names(result) <- labels
        else
            names(result) <- deparse(substitute(x))
    }
    else if(!is.null(labels) & length(labels) == dim(x)[2])
        names(result) <- labels
    else{
        names(result) <- names(x)
    }
    return(result)
}

freq.formula <- function(x, ..., data = NULL){

    if(length(x) != 2)
        stop("Invalid formula see help(freq)")
    else{
        X <- model.frame(x, data=data)
        Y <- NULL
    }
    freq(x = X, y = Y, ...)
}


print.frequencies <- function(x, ..., toLatex = FALSE){
    test <- labels(x)
    if(!toLatex){ ### default
    

        for(i in 1:length(x)){
            xlocal <- x[[i]]
            xlocal[,2:3] <- round(xlocal[,2:3]*100, digits = 1)
            cat(test[i], ":\n", sep = "")
            row.names(xlocal)[dim(xlocal)[1]] = "NA"
            print(rbind(xlocal,
                        Total = c(sum(xlocal[,1]), 100, 100)),
                  na.print = "-")
            cat("\n")
        }
    }
    else{
        for(i in 1:length(x)){
            cat("\\begin{tabular}{l r r r}\n")
            xlocal <- x[[i]]
            if(length(grep("[%&$_]", row.names(xlocal))) > 1){
                for(j in c("%","&","$","_"))
                    row.names(xlocal) <- gsub(j, paste("\\", j, sep = ""),
                                              row.names(xlocal),
                                              fixed = TRUE)    
            }
            xlocal[,2:3] = round(xlocal[,2:3]*100,
                                 digits=1)
            cat("\\multicolumn{4}{ c }{",test[i],"}\\\\\n",sep="")
            cat("\\hline\n\\hline\n")
            cat("           & Frequency & Valid Percent & Percent (with NA) \\\\\n")
            cat("\\hline\n")
            row.names(xlocal)[dim(xlocal)[1]]="NA"
            cat()
            write.table(as.data.frame(xlocal),na="-",sep=" & ",quote=F,eol="\\\\\n",col.names=FALSE)
            cat("\\hline\n\\hline\n")
            cat("Total      & ", sum(xlocal[,1]),"& 100 & 100 \\\\\n")
            cat("\\multicolumn{4}{c}{}\\\\\n")
            cat("\\end{tabular}\n\n")
        }

    }
}

