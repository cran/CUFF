###     -*- Coding: utf-8 -*-          ###
### Analyste: Charles-Édouard Giguere  ###
###                              .~    ###
###  _\\\\\_                    ~.~    ###
### |  ~ ~  |                 .~~.     ###
### #--O-O--#          ==||  ~~.||     ###
### |   L   |        //  ||_____||     ###
### |  \_/  |        \\  ||     ||     ###
###  \_____/           ==\\_____//     ###
##########################################

xyboth <- function(x, y){

  ## Must be either 2 vectors or 2 matrix/data.frame of same size.
  if(is.vector(x) & !is.vector(y) |
     !is.vector(x) & is.vector(y)){
    stop("x and y are not of the same type and cannot be compare")
  }
  if((is.matrix(x) | is.data.frame(x)) & !(is.matrix(y) | is.data.frame(y)) |
     !(is.matrix(x) | is.data.frame(x)) & (is.matrix(y) | is.data.frame(y))){
    stop("x and y are not of the same type and cannot be compare")
  }

  ## convert x and y to a data.frame
  if(is.vector(x) & is.vector(y)){
    xc <- data.frame(ID = as.character(x))
    yc <- data.frame(ID = as.character(y))
  }
  else{
    xc <- as.data.frame(x)
    xc[] <- sapply(xc, as.character)
    yc <- as.data.frame(y)
    yc[] <- sapply(yc, as.character)
  }

  if(any(c("INX", "INY", "DIMX", "DIMY") %in%
         c(names(xc), names(yc))
         )
     ){
    stop("Variables INX/INY/DIMX/DIMY are reserved for this command")
  }

  ## No test for dimensionality of index but will result no intersection in x and y.

  xc[,"INX"]  <- 1
  xc[,"DIMX"]  <- sprintf(sprintf("%%0%dd",nchar(dim(xc)[1])),1:dim(xc)[1])

  yc[,"INY"]  <- 1
  yc[,"DIMY"] <- sprintf(sprintf("%%0%dd",nchar(dim(yc)[1])),1:dim(yc)[1])

  xyc <- merge(xc, yc,
               all = TRUE)
  row.names(xyc) <- sprintf("x:%s y:%s",
                            ifelse(is.na(xyc$DIMX), "", xyc$DIMX),
                            ifelse(is.na(xyc$DIMY), "", xyc$DIMY))
  xyc$INX <- ifelse(!is.na(xyc$INX), xyc$INX, 0)
  xyc$INY <- ifelse(!is.na(xyc$INY), xyc$INY, 0)
  varxy <- setdiff(names(xyc), c("INX","INY", "DIMX", "DIMY"))
  xyc <- xyc[order(row.names(xyc)),]
  list(x = xyc[xyc$INX %in% 1 & xyc$INY %in% 0, varxy],
       y = xyc[xyc$INX %in% 0 & xyc$INY %in% 1, varxy],
       both = xyc[xyc$INX %in% 1 & xyc$INY %in% 1, varxy])
}

`%xyb%` <- xyboth

