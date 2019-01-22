### -*-      Coding: utf-8   -*-       ###
### Analyste: Charles-Édouard Giguère. ###

### Wrapper that applies function to a variable for levels of a formula
### via a formula. It works like aggregate but it returns a table instead
### of a list. 
xf <- function(formula, data, FUN = NULL, ...,
               subset=NULL, na.action = na.omit,
               useNA = FALSE, addmargins = TRUE){
  if(is.null(FUN)){
    cat("No function specified, default mean function is used",
        fill=TRUE)
    FUN <- mean
  }
  N <- dim(data)[1]
  md.frm <- model.frame(formula,data)
  frm.terms <- attr(terms(formula),"term.labels")
  for(t in frm.terms){
    if(useNA)
      data[,t] <- addNA(factor(data[,t]),ifany=TRUE)
    else
      data[,t] <- factor(data[,t],exclude=c(NA,NaN))
  }
  data = data[names(md.frm)]
  p  <- length(frm.terms)
  if(addmargins & length(frm.terms) > 0) {
    dat1 <- data.frame(rep(data[,1], 2^p))
    REP  <- expand.grid(as.data.frame(
      matrix(rep(1:2,p),nrow = 2, ncol = p)
    ))
    for(i in 1:p)
      dat1 <- cbind(dat1,factor(as.vector(t(rbind(as.character(data[,i+1]),
                                                  rep("Total", N))[REP[,i],])),
                                levels = c(levels(data[,i+1]),"Total")))
    names(dat1)  <- names(data)      
    data <- dat1
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
    } else {
      dimnames(res.array) <-
        list(levels(as.factor(na.exclude(data[,frm.terms]))))
    }
  } else{
    if(useNA){
      dimnames(res.array) <-
        lapply(data[,frm.terms],function(x) levels(as.factor(x)))
    } else{
      dimnames(res.array) <-
        lapply(data[,frm.terms],
               function(x) levels(as.factor(na.exclude(x))))
    }
  }
  res.array
}

