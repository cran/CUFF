###     -*- Coding: utf-8 -*-          ###
### Analyste: Charles-Édouard Giguère  ###
###                              .~    ###
###  _\\\\\_                    ~.~    ###
### |  ~ ~  |                 .~~.     ###
### #--O-O--#          ==||  ~~.||     ###
### |   L   |        //  ||_____||     ###
### |  \_/  |        \\  ||     ||     ###
###  \_____/           ==\\_____//     ###
##########################################


pal_CUFF <- function(n = 10 , pal = "CUFF"){
  sel = ((1:n - 1) %% 10) + 1  
  if(pal == "CUFF"){
    c("#660066", "#004D99", "#00B300", "#B30059", "#FF6666",
      "#00CC7A", "#737373", "#FF3333", "#CC00FF", "#B57E17")[sel]
  } else{
    stop("For now, only the CUFF palette is available")
  }
}
