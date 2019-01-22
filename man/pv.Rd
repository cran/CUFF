%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{pv}
\alias{pv}
\title{Format p-values}
\description{
  This is a function that format p-values for publication.
}
\usage{
pv(p, style = 1)
}
\arguments{
  \item{p}{A vector of p-values}
  \item{style}{By default (1), formatting according to APA style guide
    version 6}
}
\value{
  returns a character vector of formatted p-value. 
}
\details{
  \itemize{    
    \item{
      (1) APA: 2 digits of significance except if p is <0.05. If p < 0.05 we
      use 3 digits of significance except if p < 0.001 when we print
      "<0.001".}
    \item{
      (2) Other: 4 digits of significance except if p < 0.0001 when we print
      "<0.0001".
    }
  }
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
p <- c(0.1563,0.0122,0.00001) 
pv(p)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ pv }
\keyword{ p-value }
\keyword{ APA }
