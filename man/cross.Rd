%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{cross}
\alias{cross}
\title{Crosstabs}
\description{Functions to display (2 x 2) contingency table}
\usage{
cross(x, ...)
}
\arguments{
  \item{x}{ Object of type \code{table} or \code{formula},
    \code{vector} to tabulate}
  \item{...}{Arguments passed to \code{table} of \code{xtabs}}
}
\value{
  The \code{cross} methods returns an object of type \code{cross} with the
  original table and the marginal percentages by row and by column. A
  print methods is associated with a \code{cross} object. \code{xtab} returns
  an object of type \code{table} (see details). Total returns a sum with
  \code{na.rm=TRUE} by default and replaces NA with 0. 
}
\details{
  The \code{xtab} functions corrects the inability to deal with missing
  values in the original \code{xtabs} that comes with R base. 
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere}}
\examples{
require(CUFF)
### example of crosstabs
cr1 <- cross( ~ N + P, npk)
print(cr1, test = c("chisq.test", "fisher.test"))
}
\keyword{table}
\keyword{cross}
