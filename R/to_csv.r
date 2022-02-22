###     -*- Coding: utf-8 -*-          ###
### Analyste: Charles-Edouard Giguere  ###
###                              .~    ###
###  _\\\\\_                    ~.~    ###
### |  ~ ~  |                 .~~.     ###
### #--O-O--#          ==||  ~~.||     ###
### |   L   |        //  ||_____||     ###
### |  \_/  |        \\  ||     ||     ###
###  \_____/           ==\\_____//     ###
##########################################


### to_csv/from_csv is a function used to export data and format factors in two csv files
### 1) The raw data and 2) the format data.
### so they can be easily recuperated but more importantly shared with others. 

### All variables are formated in this way,
### | variable | label | format | labels |
### --------------------------------------
### labels informs on values labels and when they do not apply a NA value is put in.
###
### Five type of data are considered:
###
###  * numeric (integer, double, ...)
###  * factor (categorical data, package haven *labelled vectors* are treated here)
###  * character (Character field)
###  * Date (as YYYY-mm-dd)
###  * posix (for time and date as YYYY-mm-dd hh:mm:ss)
### 
###  * other miscellaneous data type are indicated as untreated.
###  When a data.frame contains multivariate data it is splitted
###  into single columns.

# Extract column types. 
column_types <- function(data){
  p   <- dim(data)[2]
  type <- rep("other", p)
  
  type[sapply(data, is.numeric)]   <- "numeric"
  type[sapply(data, is.factor)]    <- "factor"
  type[sapply(data, is.character)] <- "character"
  type[sapply(data, inherits, what = "Date")]  <- "Date"
  type[sapply(data, inherits, what = c("POSIXct","POSIXlt"))]  <- "POSIX"
  type
}


### Function to export data in csv with a format csv companion file. 
to_csv <- function(data, file){
  dim_data <- dim(data)
  
  N <- dim_data[1]
  p <- dim_data[2]
  for(i in 1:p){
    if(inherits(data[,i], c("data.frame", "matrix"))){
      data_insert <- as.data.frame(data[,i])
      names(data_insert)  <- paste(names(data)[i],
                                   names(data_insert), sep = ".")
      data = data.frame(data[,1:(i-1), drop = FALSE],
                        data_insert,
                        data[,(i+1):p, drop = FALSE])
      p = p + dim(data_insert)[2]
      i = i + dim(data_insert)[2]
    }
  }
  for(n in names(data)){
    if(inherits(data[,n], "haven_labelled")){
      data[,n] <- as_factor(data[,n])
    }
  }
  ### The file is cleaned up of multivariate columns and
  ### labelled vector.
  ###
  ### Now we make a copy of the data.frame (tbs = to be saved) using numeric
  ### value only instead of factors and string instead of date and POSIX. 
  data_type <- column_types(data)
  data_tbs  <- data
  data_tbs[,data_type %in% "factor"] <- sapply(data_tbs[,data_type %in% "factor"],
                                               as.numeric)
  data_tbs[,data_type %in% "Date"] <- sapply(data_tbs[,data_type %in% "Date"],
                                             format, format = "%Y-%m-%d")
  data_tbs[,data_type %in% "POSIX"] <- sapply(data_tbs[,data_type %in% "POSIX"],
                                              format,
                                              format = "%Y-%m-%d %H:%M:%OS")  
  ### We eliminate newline character because they mess csv file.
  data_tbs[, data_type %in% "character"] <-
    sapply(data_tbs[, data_type %in% "character"],
           gsub, pattern = "\n\r", replacement = " |-n-| ")
  f1 <- file(file, open = "w", encoding = "utf-8")
  write.table(data_tbs, sep = ",", row.names = FALSE,
              file =  f1)
  close.connection(f1)

  ### Now we save the format and label in a file.
  ### All variables are formated in this way,
  ### | variable | label | format | value | labels |
  ### --------------------------------------
  ### labels informs on values labels and when
  ### they do not apply a NA value is put in place
  ###
  fmt <- data.frame(order = 1:p, variable = names(data))
  labels <- unlist(lapply(data,
                          function(x){
                            if(is.null(attr(x, "label")))
                              lab = NA
                            else
                              lab = attr(x, "label")
                            names(lab) <- NULL
                            lab
                          }))
  label  <- data.frame(variable = names(labels),
                       label = labels)
  fmt <- fmt %>% merge(label, all.x = TRUE)
  fmt <- fmt[order(fmt$order),]
  fmt$format <- data_type
  labs <- mapply(
    function(x){lvls <- levels(data[,x])
      data.frame(
        variable = x,
        value = 1:length(lvls),
        labels = lvls)
    }, x = names(data)[data_type %in% "factor"],
    SIMPLIFY = FALSE)
  fmt <- fmt  %>%
    merge( dplyr::bind_rows(labs), all.x = TRUE)
  
  fmt <- fmt[order(fmt$order),]
  f2 <- file(sub("[.]", "_fmt.",file), open = "w", encoding = "utf-8")
  write.table(fmt[,c("variable", "label", "format", "value", "labels")],
              sep = ",", row.names = FALSE,
              file =  f2)
  close.connection(f2)  
}

