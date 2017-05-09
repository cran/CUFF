\encoding{latin1}
\name{sum.n}
\alias{sum.n}
\title{sum weighted on the number of non-missing values}
\description{Methods that estimates a sum weighted by the number of non-missing values}
\usage{ \method{sum}{n}(x,n = 1, ...) }
\arguments{
  \item{x}{A vector of values possibly containing missing values.}
  \item{n}{Minimum number of valid values}
  \item{...}{extra parameters to sum}
}
\value{
  sum.n returns the values of the weighted sum.
}
\details{ sum(x,n) = mean(x) * length(x) / n.valid(x) }
\author{ \enc{Charles-Édouard}{Charles-Edouard} \enc{Giguère}{Giguere} }
\examples{
sum.n(c(1, 2, NA, NA), n = 2)
### [1] 6
sum.n(c(1, NA, NA, NA), n = 2)
### [1] NA
}
\keyword{missing}
\keyword{sum}
