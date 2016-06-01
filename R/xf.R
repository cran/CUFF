### -*-      Coding: utf-8   -*-       ###
### Analyste: Charles-Édouard Giguère. ###

### Wrapper that applies function to a variable for levels of a formula
### via a formula. It works like aggregate but it returns a table instead
### of a list. 
xf <- function(formula, data, FUN = NULL, ...,
          subset=NULL, na.action = na.omit, useNA = FALSE){
    if(is.null(FUN)){
        cat("No function specified, default mean function is used",
            fill=TRUE)
        FUN <- mean
    }
    md.frm <- model.frame(formula,data)
    frm.terms <- attr(terms(formula),"term.labels")
    for(t in frm.terms){
        if(useNA)
            data[,t] <- addNA(factor(data[,t]),ifany=TRUE)
        else
            data[,t] <- factor(data[,t],exclude=c(NA,NaN))
    }
    res <- do.call("aggregate",
                   list(formula=formula, data=data, FUN=FUN,
                        subset=subset, na.action=na.action, ...))
    if(length(frm.terms)==1){
        terms.length <- length(table(data[,frm.terms],
                                     useNA=ifelse(useNA,"ifany","no")))
        if(useNA){
            terms.exp <- unique(data[frm.terms])
        }
        else{
            terms.exp <- unique(na.exclude(data[frm.terms]))
        }
        names(terms.exp) <- frm.terms
    }
    else if(length(frm.terms)==0){
        class(res) <- c("xf","table")
        return(res)
    }
    else{
        terms.length <- sapply(data[,frm.terms],
                               function(x)
                                   length(table(x,
                                                useNA=ifelse(useNA,"ifany","no"))))
        if(useNA){
            terms.exp <- expand.grid(lapply(as.list(data[,frm.terms]),
                                            unique))
        }
        else{
            terms.exp <- expand.grid(lapply(as.list(data[,frm.terms]),
                                            function(x) unique(na.exclude(x))))
        }
    }
    res.exp <- merge(terms.exp,res,all.x=TRUE)
    resp <- setdiff(names(md.frm),frm.terms)
    res.array <- array(dim=terms.length)
    for(n in frm.terms)
        res.exp <- res.exp[order(res.exp[,n]),]
    res.array[] <- res.exp[,resp]

    attr(res.array,"class") <- c("xf","table")

    if(length(frm.terms)==1){
        if(useNA){
            dimnames(res.array) <-
                list(levels(as.factor(data[,frm.terms])))
        }
        else {
            dimnames(res.array) <-
                list(levels(as.factor(na.exclude(data[,frm.terms]))))
        }
    }
    else{
        if(useNA){
            dimnames(res.array) <-
                lapply(data[,frm.terms],function(x) levels(as.factor(x)))
        }
        else{
            dimnames(res.array) <-
                lapply(data[,frm.terms],
                       function(x) levels(as.factor(na.exclude(x))))
        }

    }
    res.array
}

