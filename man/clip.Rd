%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{clip}
\alias{clip}
\title{Send to clipboard}
\description{
  This is a function that sends a table-like object to the clipboard to
  paste it quickly on an external program. 
}
\usage{
clip(x, sep = "\t", row.names = FALSE, quote = FALSE, ...)
}
\arguments{
  \item{x}{x is a table a matrix or a data.frame to send to clipboard}
  \item{sep}{Type of separator for the output}
  \item{row.names}{Logical value (T/F) to include or exclude row names}
  \item{quote}{logical value to print or exclude quotation marks.}
  \item{...}{other arguments passed to \code{write.table} function}
}
\value{
  No output. The results is printed to the clipboard.
}

\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ clip }
\keyword{ clipboard }
