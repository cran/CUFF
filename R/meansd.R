###     -*- Coding: utf-8 -*-          ###
### Analyste Charles-Édouard Giguère   ###

### Creation of a function to display mean (sd)
meansd <- function(x, digits = c(1, 1)){
  if(length(digits) %in% 1)
    digits <- rep(digits, 1)
  format_str <- sprintf("%%.%df (%%.%df)", digits[1], digits[2])
  sprintf(format_str,
          mean(x, na.rm = TRUE),
          sd(x, na.rm = TRUE))
}
