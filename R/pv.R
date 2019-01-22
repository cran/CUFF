### Format a vector of p-value according to APA style guide v6 (1) or with 4 dec (2).

pv  <- function(p, style = 1){
  if(style == 1){
    ifelse(p > 0.05,
           sprintf("%.2f", p),
    ifelse(p < 0.001,
           "<0.001", sprintf("%.3f",p)))
  } else{
    ifelse(p < 0.0001,
           "<0.0001",
           sprintf("%.4f", p))
  }
}

