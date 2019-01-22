\encoding{latin1}
\name{meansd}
\alias{meansd}
\title{function to compute mean and sd into a single string}
\description{Methods that estimates a mean and sd and stores it into a
  single string}
\usage{ meansd(x, digits = c(1, 1)) }
\arguments{
  \item{x}{A vector of numeric value}
  \item{digits}{digits for respectively the mean and sd. If a single
    value is entered it applies to mean and sd}
}
\value{
  Returns a string containing mean and sd with entered digit precisions.
}
\author{ \enc{Charles-Édouard}{Charles-Edouard} \enc{Giguère}{Giguere} }
\examples{
xf(Sepal.Width ~ Species, iris, meansd)
}
\keyword{mean}
\keyword{sd}
