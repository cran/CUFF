%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{xyboth}
\alias{xyboth}
\alias{\%xyb\%}
\title{Utility function to match 2 indices}
\description{
  Function \%xyb\% or xyboth(x, y) shows index present in x, y and both}
\usage{
x \%xyb\% y
xyboth(x, y)
}
\arguments{
  \item{x}{vector(matrix/dataframe) of indices}
  \item{y}{vector(matrix/dataframe) of indices}
  }
  \value{
    Returns a list with indices present only in x and y and in both. 
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
require(CUFF)
xyboth(1:5, 3:6)
### $x
### [1] "1" "2"
### 
### $y
### [1] "6"
### 
### $both
### [1] "3" "4" "5"
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{xyboth}
\keyword{intersect}
