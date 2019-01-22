%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{view}
\alias{view}
\title{view methods}
\description{
  Wrapper to DT::datatable.
}
\usage{
view(x, ...)
}
\arguments{
  \item{x}{x is a matrix/\code{data.frame}/\code{table} format for viewing}
  \item{...}{arguments passed to datatable}
}
\value{
  Export data to be viewed as a web page. See \code{help(datatable,
    package = "DT")} for further details. 
}

\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
view(iris)
### add filter on top.
view(iris, filter = "top")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ correlation }
\keyword{ corr }
\keyword{ cor }
