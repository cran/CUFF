%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{freq}
\alias{freq}
\alias{print.frequencies}
\title{Frequencies}
\description{Functions to display frequency }
\usage{
freq(x, y = NULL, ..., labels = NULL, data = NULL)
\method{print}{frequencies}(x, ..., toLatex = FALSE)
}
\arguments{
  \item{x}{ Object of type \code{formula}, \code{matrix} or
    \code{data.frame}}
  \item{y}{If x is a formula,\code{y} or \code{data} contains the data
    from x or are set to NULL if the variables are in the main
    environment}
  \item{...}{used for compatibility}
  \item{labels}{Optional vector of labels the same length as the
    dimension of x or the number of variables in formula.}
  \item{data}{see y for details}
  \item{toLatex}{Logical value that indicates if the print methods
  should return a tabular latex environment to use with Sweave or knitr.}
}
\value{
  An object of type "frequencies" that is a list of \code{matrix} containing
  the frequencies the \% and the \% with missing value.
  
}
\details{
  The \code{freq} methods returns an object of type \code{frequencies}
  object with a \code{print} methods associated. 
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere}}
\examples{
require(CUFF)
### example of crosstabs
fr1 <- freq( ~ N + P, npk, c("Nitrogen", "Phosphate"))
fr1
### To use with sweave or knitr.
print(fr1, toLatex = TRUE)
}
\keyword{freq}
\keyword{frequencies}
