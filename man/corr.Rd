%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{correlation}
\alias{correlation}
\alias{print.corr}
\title{Bivariate correlations}
\description{
  This is a function that creates correlation matrix objects that can be
  printed with the corresponding N and p-values. It is a wrapper for cor
  and cor.test.
}
\usage{
correlation(x, y = NULL, method = "pearson",
            alternative = "two.sided", exact = NULL,
            use = "pairwise.complete.obs",
            continuity = FALSE, data = NULL)
\method{print}{corr}(x, ... , toLatex = FALSE, cutstr = NULL, toMarkdown = FALSE)
}
\arguments{
  \item{x}{x is a matrix/\code{data.frame} or a formula defining which
    variable to use in the correlation matrix (see details).}
  \item{y}{y is a matrix/\code{data.frame} to correlate against x. If x
  is a formula y is passed to data argument}
  \item{method}{Method used to compute correlations.}
  \item{alternative}{Unilateral (\code{one.sided}) test or bilateral
    (\code{two.sided}) test. See \code{help(cor)} for more details.} 
  \item{exact}{Logical value to know if a p.value is exact or
    asymptotic. See \code{help(cor)} for more details.}
  \item{use}{Methods to deal with missing values.}
  \item{continuity}{Logical value to know if continuity correction
    must be used. See \code{help(cor)} for more details.}
  \item{...}{Unused in this function}
  \item{data}{data.frame to use in conjuction with formula}
  \item{toLatex}{Logical value to know if output displayed as a latex
    tabular environment.}
  \item{cutstr}{ Optional digits that cut the length of variable names}
  \item{toMarkdown}{Logical value to know if output should be displayed as a markdown table for report}
}
\value{
  Returns a list with correlations, N for each pair of correlations and
  p.value for each correlations.
}

\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
require(CUFF)
X=rnorm(10)
Y=rnorm(10)
correlation(cbind(X,Y))
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ correlation }
\keyword{ corr }
\keyword{ cor }
