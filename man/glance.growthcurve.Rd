% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/glance.growthcurve.R
\name{glance.growthcurve}
\alias{glance.growthcurve}
\title{Construct a Single Row Summary of a Growth Model or Fit}
\usage{
glance.growthcurve(x, ...)
}
\arguments{
\item{x}{A fit for some growth data (a \code{growthcurve} object)}

\item{...}{Additional arguments (not used)}
}
\value{
a single-row data frame or NULL
}
\description{
Currently, this function simply wraps \code{glance.nls} or
\code{glance.smooth.spline}, so parametric fits such as
\code{fit_growth_logistic} and \code{fit_growth_gompertz} cannot be compared
with results from \code{fit_growth_spline}. This function does not work with
results from \code{fit_growth_loess}.
}
\note{
This function requires the \pkg{broom} package.
}
\examples{
\dontrun{
myfit <- fit_growth_gompertz(mydata, Time, OD600)
glance(myfit)}

}

