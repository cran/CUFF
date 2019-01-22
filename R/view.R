### Function view uses DT::datatable as a viewer and sends options to datatable.
view <- function(x, ...){
  if(is.vector(x))
    x  <- data.frame(x)
  datatable(x, ...)
}

