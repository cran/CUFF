%% -*- Coding: utf-8 -*-
\encoding{utf-8}
\name{ftab}
\alias{ftab}
\title{Fonctions pour ajouter les pourcentages dans les tables}
\description{La fonction retourne une table avec le contenu en
  \enc{caractères}{caracteres} de la \enc{fréquence}{frequence} et du pourcentage}
\usage{
ftab(xt, margin = seq_along(dim(xt)), fmt = "\%d (\%5.1f \%\%)", quiet = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{xt}{Une table de contingence généré avec table ou xtabs}
  \item{margin}{ Si 2x2, est que le pourcentage est en ligne (1) ou en
colonne(2) ou total (1:2). Par défaut, pourcentage total. Ne sert à rien
lorsque le tableau est à une dimension. }
  \item{fmt}{format d'affichage}
  \item{quiet}{Valeur logique qui indique si le tableau est imprimé}
}
\value{
  Retourne une table avec le contenu en caractères de la frequence et du
pourcentage
}
\author{Charles-\enc{Édouard}{Edouard} \enc{Giguère}{Giguere} }
\examples{
ex <- as.table(cbind(3:4,5:6))
ftab(ex,2)
}
\keyword{ftab, table, xtabs, xtab}
