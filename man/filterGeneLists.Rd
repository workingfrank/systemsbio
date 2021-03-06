% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/HLP_filterGeneLists.R
\name{filterGeneLists}
\alias{filterGeneLists}
\title{Filter gene lists}
\usage{
filterGeneLists(
  genes,
  newheader = NULL,
  filtercat1 = "adj.P.Val",
  filtercat1.decreasing = FALSE,
  filtercat1.function = abs,
  filtercat1.threshold = 0.05,
  filtercat2 = "logFC",
  filtercat2.decreasing = TRUE,
  filtercat2.function = abs,
  filtercat2.threshold = log2(1.5)
)
}
\arguments{
\item{genes}{dataframe or character with path directing to table with genelist and columns to filter for.}

\item{newheader}{NULL if \code{genes} already supplied with header. Character vector with new header otherwise.}

\item{filtercat1}{column name of first category to filter \code{genes} (e.g. p-values). Skipped if NULL.}

\item{filtercat1.decreasing}{(boolean): direction to order and filter \code{filtercat1}}

\item{filtercat1.function}{select transforming function for \code{filtercat1} (no quotes). 
e.g. \code{abs} for absolute values, \code{identity} for no transformation}

\item{filtercat1.threshold}{Threshold for \code{filtercat1} or 'top123' for (123) top Hits}

\item{filtercat2}{column name of second category to filter \code{genes} (e.g. effect size). Skipped if NULL.}

\item{filtercat2.decreasing}{(boolean): direction to order and filter \code{filtercat2}}

\item{filtercat2.function}{select transforming function for \code{filtercat2} (no quotes). E.g. abs for foldchanges.}

\item{filtercat2.threshold}{Threshold for \code{filtercat2} or 'top123' for top Hits}
}
\value{
dataframe filtered for desired criteria and sorted for \code{filtercat1} (if not Null).
}
\description{
Gene list are filtered for selected columns considering desired direction and/or transformation.
}
\details{
The function filters a dataframe or a character directing to dataframe for up to two categories (e.g. p-value and foldchange).
Columns for filter criteria must be included in the input dataframe \code{genes}.
Values in filter criteria may be transformed e.g. to absolute values by \code{filtercat.function = abs}, 
which is needed for log foldchanges. No tranformation if \code{filtercat.function = identity}.
}
\author{
Frank Ruehle
}
