%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{xtab}
\alias{xtab}
\alias{Total}
\title{Crosstabulations using formula}
\description{Functions to create contingency table using formula}
\usage{
xtab(formula, data, useNA = FALSE, exclude = c(NA,NaN), miss.char = "-",
     na.action = na.exclude, subset = NULL, sparse = FALSE,
     drop.unused.levels = FALSE)
Total(x)
}
\arguments{
  \item{formula}{ Object of class \code{cross} to be printed}
  \item{data}{data frame to use with formula}
  \item{useNA}{logical values to add NA to the levels in the table}
  \item{exclude}{levels to exclude from table}
  \item{miss.char}{Character to replace NA}
  \item{na.action}{methods to deal with NA}
  \item{subset}{subset to use in data}
  \item{sparse}{see \code{help(xtabs)} for details}
  \item{drop.unused.levels}{logical values indicating whether we drop
    empty levels}
  \item{x}{numerical vector}
}
\value{
  \code{xtab} returns an object of type \code{table} (see
  details). Total returns a sum with \code{na.rm=TRUE} by
  default and replaces NA with 0. 
}
\details{
  The \code{xtab} functions corrects the inability to deal with missing
  values in the original \code{xtabs} that comes with R base. Total is
  a utility function to use in conjunction with addmargins instead of sum.
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
require(CUFF)
### example of crosstabs
xtab( ~ N + P, npk)
}
\keyword{table}
\keyword{cross}
