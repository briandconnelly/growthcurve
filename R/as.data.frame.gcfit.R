#' Create a data frame from a fit
#'
#' \code{as.data.frame} creates a data frame that contains the parameters of
#' fitted curve.
#' 
#' @param x A fit for some growth data
#' @param row.names \code{NULL} or a character vector giving the row names for
#' the data frame. Missing values are not allowed. (ignored)
#' @param optional (ignored)
#' @param ... Additional arguments (ignored)
#'
#' @return A data frame containing the parameters for the fit
#' @export
#'
#' @examples
#' \dontrun{
#' # Plot some sample data and overlay a fit line
#' library(ggplot2)
#' library(growthcurve)
#' 
#' sampledata <- data.frame(Time=1:30, OD600=1/(1+exp(0.5*(15-1:30)))+rnorm(30)/20)
#' lfit <- fit_growth_logistic(sampledata, Time, OD600)
#' 
#' ggplot(sampledata, aes(x=Time, y=OD600)) +
#'     geom_point(shape=1) +
#'     geom_line(data=as.data.frame(lfit))}
#' 
as.data.frame.gcfit <- function(x, row.names=NULL, optional=FALSE, ...)
{
    as.data.frame(x$parameters)
}
