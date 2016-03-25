%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{strutils}
\alias{\%+\%-methods}
\alias{\%+\%}
\alias{\%n\%}
\alias{paste}
\alias{numtostr}
\title{Utility functions to treat characters}
\description{
  Function \%+\% paste characters with other characters pairwise.
  Function \%n\% is used to repeat a character n time.  
  Function \code{numtostr} converts numeric to a string in a nice
  format. }
\usage{
x \%+\% y
x \%n\% y
numtostr(x,nch,digits=4)
}
\arguments{
  \item{x}{Character vector or a numeric vector for \code{numtostr} functions}
  \item{y}{Character vector}
  \item{nch}{(Optionnal) length of the resulting character vector}
  \item{digits}{Number of digits in the resulting strings}
  }
  \value{
    Function  \%+\% is an operator that shortens \code{paste(x, y,
    sep="")} see \code{help(paste)} for more options. Function
    \%n\% returns the character vector x repeated y times. If both x and
    y are vector each element of x are applied to each element of y.
    Function \code{numtostr} converts numerical vector to a character
    vector using a nice format. 
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
require(CUFF)
"Hello " \%+\% "world."
cat(" " \%n\%  c(rep(1,9),2) \%+\% 1:10,fill=TRUE)
### Returns a * because specified length of character is unsufficient. 
numtostr(9048948449.94948,nch=8)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{paste}
\keyword{char}
\keyword{character}
