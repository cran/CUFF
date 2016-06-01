\encoding{latin1}
\name{xf}
\alias{xf}
\title{Methods that apply a function across a levels of one or more
  factors}
\description{Methods that apply a function across a levels of one or more
  factors. It works like aggregate but returns a table instead. It also
  has a useNA options that adds NA as a level before applying the function.}
\usage{
xf(formula,data,FUN, ...,subset,na.action=na.omit,useNA = FALSE)}
\arguments{
  \item{formula}{ Formula defining the variables. On the left is the
    variable we are applying the function to, on the right, variables
    defining levels of the tables}
  \item{data}{Data.frame containing the variables}
  \item{FUN}{The function to apply to each subset of data}
  \item{...}{extra parameters to FUN}
  \item{subset}{Vectors defining a subset of data.frame
    (see \code{help(aggregate)}).}
  \item{na.action}{Action functions to deal with NA in data file}
  \item{useNA}{Make NA a level of the factors (if any)}
}
\value{
  xf returns an object "xf" that behaves like a table with all
  associated methods.}
\author{ \enc{Charles-Édouard}{Charles-Edouard} \enc{Giguère}{Giguere} }
\examples{
res <- xf(Sepal.Length~Species,iris,mean)
barplot(res)}
\keyword{table}
\keyword{xf}
