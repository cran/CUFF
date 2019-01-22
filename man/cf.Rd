%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{cf}
\alias{cf}
\title{Extract and format coefficients table}
\description{
  This function extract coefficients tables from common statistical
  model (lm/glm/lme/lmer/t-test) and format them. 
}
\usage{
cf(x, addci = TRUE, pv.style = 1, signif = 2, expcf, ...)
}
\arguments{
  \item{x}{x is a lm/glm/lme/lmer/t.test model}
  \item{addci}{Logical value that tells R to add a 95\% confidence
    interval to the output. True by default.}
  \item{pv.style}{Integer specifying the style (1 or 2) of p-value
    formatting. See \code{help(pv)} for details}
  \item{signif}{Either an integer specifying the number of significant
    digits or a dimension 3 vector for respectively the estimate,
    standard error and t-value}
  \item{expcf}{Logical value that tells R to add exponentiated value of
  estimate. Set to FALSE except if the model specifies a logistic
  regression (family = binomial)}
\item{...}{Not used yet}
}
\value{
  Returns a data.frame of formatted characters of the coefficient table.
}

\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
lm1 <- lm(Sepal.Length ~ Species, iris)
cf(lm1)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ cf }
\keyword{ coefficients }
