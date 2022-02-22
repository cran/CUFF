%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{to_csv}
\alias{to_csv}
\alias{column_types}
\title{Export into a csv file with a format csv companions for factors}
\description{
  This functions export a data frame into a csv file with a csv
  companion file containing formats to properly reimport data into R.
}
\usage{
column_types(data)
to_csv(data, file)
}
\arguments{
  \item{data}{A \code{data.frame} containing data to export}
  \item{file}{Name of the csv file to export to}
}
\value{
  returns nothing
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
# to_csv(iris,"iris.csv")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ csv }
\keyword{ format }
\keyword{ export }
