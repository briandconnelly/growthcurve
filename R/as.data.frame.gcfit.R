#' Create a data frame from a fit
#'
#' \code{as.data.frame} creates a data frame that contains data tracing the 
#' fitted curve. The column names are the same as those used when the fit was
#' created.
#' 
#' @param x A fit for some growth data
#' @param row.names \code{NULL} or a character vector giving the row names for
#' the data frame. Missing values are not allowed.
#' @param optional (ignored)
#' @param ... Additional arguments (ignored)
#'
#' @return A data frame containing the time and growth values for the fit
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
    df <- data.frame(x$fit.time, x$fit.data, row.names=row.names)
    names(df) <- c(x$time_col, x$growth_col)
    df
}
