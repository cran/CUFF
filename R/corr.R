###     -*- Coding: utf-8 -*-
### Analyste Charles-Édouard Giguère
### Function to create an object of that contains a matrix of bivariate
### correlations their associated N and their p-values

correlation <- function(x, y = NULL, method = "pearson",
                        alternative = "two.sided", exact = NULL,
                        use = "pairwise.complete.obs",
                        continuity = FALSE, data = NULL){

    if("formula" %in% class(x)){
        if(is.null(data) & !is.null(y))
            data <- y
        return(correlation.formula(x, method = method,
                                   alternative = alternative, exact = exact,
                                   use = use, continuity = continuity, data=data))
    }

    ## matrix dimensions
    symmetric <- is.null(y)
    dimx <- dim(x)
    if(symmetric)
        dimy <- NULL
    else
        dimy <- dim(y)
    ### Check for empty data.
    if( is.null(dimx) ){
        stop("x must be a data.frame(or matrix) " %+%
             "with at least 2 columns and 3 rows")
    }
    else if(!is.null(dimx) & symmetric & (dimx[2] <= 1) | (dimx[1] < 3)){
        stop("x must be a data.frame (or matrix) " %+%
             "with at least 2 columns and 3 rows")
    }
    else if(!is.null(dimy)){
        if(dimx[1] != dimy[1]){
            stop("x and y must have the same number of rows")
        }
    }
    ## Get dimensions names from the data.frame/matrix.
    dimnamesx <- dimnames(x)
    if(symmetric)
        dimnamesy <- NULL
    else
        dimnamesy <- dimnames(y)
    ## If the dataframe/matrix does not contains names.
    ## We call them X1, X2 and so forth.
    if(is.null(dimnamesx)){
        dimnamesx <- 'X' %+% 1:dimx[2]
    }
    else{
        dimnamesx <- dimnamesx[[2]]
    }
    if(!symmetric){
        if(is.null(dimnamesx)){
            dimnamesy <- 'Y' %+% 1:dimy[2]
        }
        else{
            dimnamesy <- dimnamesy[[2]]
        }
    }
    ## The correlation matrix is created.
    R <- cor(x, y, use = use, method = method)
    ## The na.method are
    ## everything: NA if NA in either variable of the pair of variables;
    ## all.obs: Error if NA else take everything. Error are generated
    ##          before this point;
    ## complete.obs: Casewise deletion. Error if no complete case. Error
    ##               will be generated before this point;
    ## pairwise.complete.obs: Pairwise completion (default).  It can results
    ##                        in a non positive semi-definite matrix.
    ## na.or.complete: casewise delete. NA if no complete case.
    na.method <-
        pmatch(use, c("everything", "all.obs", "complete.obs",
                      "pairwise.complete.obs", "na.or.complete"))

    ## Number of subjects in each pair (pairwise method).
    if(symmetric)
        N <- t(!is.na(x)) %*% !is.na(x)
    else
        N <- t(!is.na(x)) %*% !is.na(y)

    ## Error if use parameter do not match anything.
    if (is.na(na.method)){
        stop("invalid 'use' argument")
    }

    ## If method is "complete" do casewise deletion.
    if(na.method %in% c(3, 5)){
        if(symmetric)
            N[,] <- dim(x <- na.exclude(x))[1]
        else{
            x <- x[apply(is.na(cbind(x,y)),1,sum) %in% 0,]
            y <- y[apply(is.na(cbind(x,y)),1,sum) %in% 0,]
            N[,] <- dim(x)[1]
        }
    }

    ## Compute p-values using cor.test.
    if(symmetric){
        P <- matrix(NA, nrow = dimx[2], ncol = dimx[2])
        P[lower.tri(P)] <-
            mapply(
                function(i, j){
                    cor.test(x[,i], x[,j], alternative = alternative,
                             method = method, exact = exact,
                             continuity = continuity)$p.value
                },
                col(R)[lower.tri(R)],row(R)[lower.tri(R)])
        P[upper.tri(P)] <- t(P)[upper.tri(P)]
    }
    else{
        P <- matrix(NA, nrow = dimx[2], ncol = dimy[2])
        indexij <- expand.grid(1:dimx[2],1:dimy[2])
        P[,] <-
            mapply(
                function(i, j){
                    cor.test(x[,i], y[,j], alternative = alternative,
                             method = method, exact = exact,
                             continuity = continuity)$p.value
                },
                indexij[,1],indexij[,2])
    }

    ### adjust N for
    if(na.method %in% 1){
        N[is.na(R)] <- P[is.na(R)] <- NA
    }
    out <- list(R = R, N = N, P = P, Sym = symmetric)
    attr(out, "nomx") <- dimnamesx
    attr(out, "nomy") <- dimnamesy
    class(out) <- "corr"
    out
}

correlation.formula <- function(x, ..., data = NULL){

    if(length(x) != 2)
        stop("Invalid formula see help(correlation)")
    else if (length(x[[2]]) == 3 &&
             identical(x[[2]][[1]], as.name("|"))){
        fX <- ~.
        fX[[2]] <- x[[2]][[2]]
        X <- model.frame(fX,data=data)
        fY <- ~.
        fY[[2]] <- x[[2]][[3]]
        Y <- model.frame(fY,data=data)
    }
    else{
        X <- model.frame(x, data=data)
        Y <- NULL
    }
    correlation(x = X, y = Y, ...)
}

### Print methods for a correlation object.
print.corr <- function(x, ..., toLatex = FALSE, cutstr = NULL, toMarkdown = FALSE){

  if(!x$Sym){
    ## Send to print.corr.unsym if the correlation matrix is not symmetric.
    print.corr.unsym(x, ..., toLatex = toLatex, cutstr = cutstr,
                     toMarkdown = toMarkdown)
  }
  else {
    ## Number of variables
    dx <- dim(x$R)[1]

    ## Name of variables.
    nom <- attr(x, "nomx")
    lnom <- nchar(nom)

    ## if not cutstr takes the value of the largest variable name.
    if(is.null(cutstr))
      cutstr <- max(lnom, 7)
    else
      cutstr <- max(7 ,min(cutstr, max(lnom)))

    if(toLatex & toMarkdown)
      stop("Cannot choose both Latex and Markdown format")

    if(!toLatex & !toMarkdown){
      ## Estimating necessary space to print correlation.
      ## 13 characters are reserved for margins.
      width <- options()$width - 5 - cutstr
      if(width < cutstr + 1)
        stop(sprintf("Not enough space to print correlation matrix.\n" %+%
                       " Change page width using options(width = n) with n >= %d",
                     6 + 2 * cutstr))

      ## Only the first cutstr characters of variable names are printed.
      ## Estimating the maximum number of columns that can be displayed on
      ## one line.
      nmax <- (width %/% (cutstr + 1))

      ## variables starting lines.
      coldebvar <- seq(1, dx - 1, nmax)

      ## variables closing lines.
      colfinvar <- apply(cbind(coldebvar + nmax - 1, dx - 1), 1, min)

      ## Map var names into cutstr-character strings.
      formatname <- "%" %+% cutstr %+% "." %+% cutstr %+% "s"
      nom <- sprintf(formatname, nom)
      ## output print.
      for(i in 1:length(coldebvar)){
        nomi <- coldebvar[i]:colfinvar[i]
        cat(" " %n% (4 + cutstr), "|", sep="")
        cat(nom[nomi], sep = " ", fill = TRUE)
        cat("-" %n% (4 + (cutstr+ 1) * (length(nomi) + 1)),fill = TRUE)
        for(j in (coldebvar[i] + 1):dx){
          cat(gsub("R[(]( +)", "\\1R(", "R(" %+% nom[j]) %+% ") |")
          cat(numtostr(x$R[j, nomi[nomi < j]], cutstr, 4), fill=TRUE)
          cat(gsub("N[(]( +)", "\\1N(", "N(" %+% nom[j]) %+% ") |")
          cat(numtostr(x$N[j, nomi[nomi < j]], cutstr, 0), fill = TRUE)
          cat(gsub("P[(]( +)", "\\1P(", "P(" %+% nom[j]) %+% ") |")
          cat(numtostr(x$P[j, nomi[nomi < j]], cutstr, 4), fill = TRUE)
          cat("-" %n% (4 + (cutstr+ 1) * (length(nomi) + 1)),fill = TRUE)
        }
      }
    }
    else if(toLatex){
      cat("\\begin{tabular}{l |" %+% ("r" %n% (dx - 1)) %+% "}", fill = TRUE)
      cat("\\hline", fill = TRUE)
      cat("& " %+% paste(nom[-length(nom)], collapse=" & ") %+% " \\\\\n")
      cat("\\hline\\hline", fill = TRUE)
      for(i in 2:length(nom)){
        cat("R(" %+% nom[i] %+% ") &")
        cat(numtostr(x$R[i, 1:(i-1)], digits=4), sep = " & ")
        cat(" \\\\\n")
        cat("N(" %+% nom[i] %+% ") &")
        cat(numtostr(x$N[i, 1:(i-1)], digits = 0), sep = " & ")
        cat(" \\\\\n")
        cat("P(" %+% nom[i] %+% ") &")
        cat(numtostr(x$P[i, 1:(i-1)], digits=4), sep = " & ")
        cat(" \\\\\n")
        cat("\\hline", fill = TRUE)
      }
      cat("\\end{tabular}", fill = TRUE)
    }
    else if(toMarkdown){
      formatnom <- sprintf("%%%d.%ds", cutstr, cutstr)
      nom <- sprintf(formatnom, nom)
      cat("|" %+% (" " %n% (4 + cutstr)) %+% "|",
          sprintf(" %s|",nom[1:(dx - 1)]),"\n",
          sep = "")
      cat("|:" %+% ("-" %n% (3 + cutstr)) %+% "|",
          rep(("-" %n% (cutstr )) %+% ":|", dx - 1), "\n", sep = "")
      for(i in 2:dx){
        cat(sub("R[(]( +)(.*)[)] [|]", "R(\\2)\\1 |",
                "|R(" %+% nom[i] %+% ") |" ), sep = "")
        cat(numtostr(x$R[i, 1:(i-1)], nch = cutstr + 1, digits = 4) %+% "|", sep = "")
        cat(rep(" " %n% (cutstr + 1) %+% "|", dx - i ), "\n", sep = "")
        cat(sub("N[(]( +)(.*)[)] [|]", "N(\\2)\\1 |",
                "|N(" %+% nom[i] %+% ") |"), sep = "")
        cat(numtostr(x$N[i, 1:(i-1)], nch = cutstr + 1, digits = 0) %+% "|", sep = "")
        cat(rep(" " %n% (cutstr + 1) %+% "|", dx - i ), "\n", sep = "")
        cat(sub("P[(]( +)(.*)[)] [|]", "P(\\2)\\1 |",
                "|P(" %+% nom[i] %+% ") |"), sep = "")
        ptemp <- ifelse(x$P[i, 1:(i-1)] < 0.0001,"<0.0001",
                        sprintf("%.4f",x$P[i, 1:(i-1)]))
        cat(sprintf(" " %+% formatnom,ptemp) %+% "|", sep = "")
        cat(rep(" " %n% (cutstr + 1) %+% "|", dx - i ), "\n", sep = "")
      }
    }
  }
}


print.corr.unsym <- function(x, ..., toLatex = FALSE, cutstr = NULL,
                             toMarkdown = FALSE){
  ## Variable dimensions.
  dxy <- dim(x$R)

  ## Variable names (x, y).
  nomx <- attr(x, "nomx")
  nomy <- attr(x, "nomy")
  lnomx <- nchar(nomx)
  lnomy <- nchar(nomy)
  if(is.null(cutstr))
    cutstr <- max(c(lnomx,lnomy), 7)
  else
    cutstr <- max(7, min(cutstr, max(c(lnomx,lnomy))))

  if(toLatex & toMarkdown)
    stop("Cannot choose both Latex and Markdown format")

  ## Standard print
  if(!toLatex & !toMarkdown){

    ## Estimating necessary space to print correlation.
    ## 5 + cutstr characters are reserved for margins.
    width <- options()$width - 5 - cutstr
    if(width < cutstr + 1)
      stop(sprintf("Not enough space to print correlation matrix." %+%
                     "Change page width using options(width = n) with n >= %d",
                   6 + 2 * cutstr))

    ## Only the first cutstr characters of variable names are printed.
    ## Estimating the maximum number of columns that can be displayed on
    ## one line.
    nmax <- (width %/% (cutstr + 1))

    ## position of variables starting lines.
    coldebvar <- seq(1, dxy[2], nmax)

    ## position of variables ending lines.
    colfinvar <- apply(cbind(coldebvar + nmax - 1, dxy[2]), 1, min)

    ## Map variables into cutstr-character strings.
    formatname <- "%" %+% cutstr %+% "." %+% cutstr %+% "s"
    nomx <- sprintf(formatname, nomx)
    nomy <- sprintf(formatname, nomy)
    ## Print outputs.
    for(i in 1:length(coldebvar)){
      nomi <- coldebvar[i]:colfinvar[i]
      cat(" " %n% (4 + cutstr), "|", sep="")
      cat(nomy[nomi], sep = " ", fill = TRUE)
      cat("-" %n% (5 + cutstr + (cutstr + 1) * length(nomi)),fill = TRUE)
      for(j in 1:length(nomx)){
        cat(gsub("R[(]( +)", "\\1R(", "R(" %+% nomx[j]) %+% ") |")
        cat(numtostr(x$R[j, nomi], cutstr, 4), fill=TRUE)
        cat(gsub("N[(]( +)", "\\1N(", "N(" %+% nomx[j]) %+% ") |")
        cat(numtostr(x$N[j, nomi], cutstr, 0), fill = TRUE)
        cat(gsub("P[(]( +)", "\\1P(", "P(" %+% nomx[j]) %+% ") |")
        cat(numtostr(x$P[j, nomi], cutstr, 4), fill = TRUE)
        cat("-" %n% (5 + cutstr + (cutstr + 1) * length(nomi)), fill = TRUE)
      }
    }
  }
  ## Print into a latex tabular environment. For use with knitr/Sweave.
  else if (toLatex){
    cat("\\begin{tabular}{l |" %+% ("r" %n% (dxy[2])) %+% "}", fill = TRUE)
    cat("\\hline", fill = TRUE)
    cat("& " %+% paste(nomy, collapse=" & ") %+% " \\\\\n")
    cat("\\hline\\hline", fill = TRUE)
    for(i in 1:length(nomx)){
      cat("R(" %+% nomx[i] %+% ") &")
      cat(numtostr(x$R[i,], digits=4), sep = " & ")
      cat(" \\\\\n")
      cat("N(" %+% nomx[i] %+% ") &")
      cat(numtostr(x$N[i,], digits = 0), sep = " & ")
      cat(" \\\\\n")
      cat("P(" %+% nomx[i] %+% ") &")
      cat(numtostr(x$P[i,], digits=4), sep = " & ")
      cat(" \\\\\n")
      cat("\\hline", fill = TRUE)
    }
    cat("\\end{tabular}", fill = TRUE)
  }
  else if(toMarkdown){
    dx <- length(nomx)
    dy <- length(nomy)
    formatnom <- sprintf("%%%d.%ds", cutstr, cutstr)
    nomx <- sprintf(formatnom, nomx)
    nomy <- sprintf(formatnom, nomy)
    cat("|" %+% (" " %n% (4 + cutstr)) %+% "|", sprintf(" %s|",nomy),"\n",
        sep = "")
    cat("|:" %+% ("-" %n% (3 + cutstr)) %+% "|",
        rep(("-" %n% (cutstr )) %+% ":|", dy), "\n", sep = "")
    for(i in 1:dx){
      cat(sub("R[(]( +)(.*)[)] [|]", "R(\\2)\\1 |",
              "|R(" %+% nomx[i] %+% ") |" ), sep = "")
      cat(numtostr(x$R[i, 1:dy], nch = cutstr + 1, digits = 4) %+% "|", "\n", sep = "")
      cat(sub("N[(]( +)(.*)[)] [|]", "N(\\2)\\1 |",
              "|N(" %+% nomx[i] %+% ") |"), sep = "")
      cat(numtostr(x$N[i, 1:dy], nch = cutstr + 1, digits = 0) %+% "|", "\n", sep = "")

      cat(sub("P[(]( +)(.*)[)] [|]", "P(\\2)\\1 |",
              "|P(" %+% nomx[i] %+% ") |"), sep = "")
      ptemp <- ifelse(x$P[i, 1:dy] < 0.0001,
                      "<0.0001", sprintf("%.4f",x$P[i, 1:dy]))
      cat(sprintf(" " %+% formatnom,ptemp) %+% "|", "\n", sep = "")
    }
  }
}
