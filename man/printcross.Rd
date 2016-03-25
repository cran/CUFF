%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{printcross}
\alias{print.cross}
\title{Crosstabs print methods}
\description{Functions to display (2 x 2) contingency table}
\usage{
\method{print}{cross}(x, ..., test = "chisq.test", export = NULL)
}
\arguments{
  \item{x}{ Object of type \code{cross} to print}
  \item{...}{Unused arguments}
  \item{test}{ list of statistical tests (as character vector) passed to
    the 2x2 table. By default, \code{test} is set to "chisq.test" which
    performs a khi-square test with Yates continuity correction.}
  \item{export}{Either "pdf" or "xlsx" or NUll. Crosstab is
    flushed into either a pdf using latex or an Excel spreadsheet using
    package openxlsx}
}
\value{
  Print methods associated with the \code{cross} object.  
}
\details{
  Export to "pdf", "xlsx" open the crosstabs in the corresponding formats.
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
require(CUFF)
### example of crosstabs
cr1 <- cross( ~ N + P, npk)
print(cr1, test = c("chisq.test", "fisher.test"))
}
\keyword{table}
\keyword{cross}
