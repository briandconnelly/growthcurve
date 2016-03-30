#' Plot growth data and its fitted growth curve
#'
#' @param x A fit for some growth data
#' @param y Not used
#' @param show_raw Whether or not to show the original data (default \code{TRUE})
#' @param show_maxrate Whether or not to show a tangent line where the maximum growth rate occurs (default \code{TRUE})
#' @param show_asymptote Whether or not to indicate the maximum growth level (default \code{FALSE})
#' @param ... Optional arguments to plot. Note that \pkg{grofit} does not pass these along to the base graphics, so they're mostly useless at the moment.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get a logistic fit for some data and extract its residuals
#' lfit <- fit_growth_logistic(df=mydata, Time, OD600)
#' plot(lfit)}
#' 
plot.gcfit <- function(x, y=NULL, show_raw=TRUE, show_maxrate=TRUE,
                       show_asymptote=FALSE, ...) {
    opt_args <- list(...)

    opt_args$xlab <- ifelse("xlab" %in% names(opt_args), opt_args$xlab,
                            x$raw$time_col)
    opt_args$ylab <- ifelse("ylab" %in% names(opt_args), opt_args$ylab,
                            x$raw$data_col)
    opt_args$x <- x$fit.time
    opt_args$y <- x$fit.data
    opt_args$type <- "l"

    opt_args$show_maxrate <- NULL
    opt_args$show_raw <- NULL
    opt_args$show_asymptote <- NULL

    # Plot the fitted curve
    # TODO fix for splines
    try(do.call(plot, opt_args))

    # Add the raw data points
    if(show_raw) {
        points(x$raw$df[[x$raw$time_col]], x$raw$df[[x$raw$data_col]], ...)
    }

    try(abline(a = x$lag_length[[1]], b = x$max_rate[[1]]))

    # Add a tangent line where the maximum growth rate occurs
    if(show_maxrate) {
        yvals <- (x$grofit$fit.time * x$max_rate[[1]]) + (-1 * x$max_rate[[1]] * x$lag_length[[1]])
        try(lines(x$grofit$fit.time, yvals, lw=2, lty=2))
    }

    # Add a horizontal line indicating the maximum growth level
    if(show_asymptote) try(abline(h = x$max_growth[[1]], lw = 2, lty = 3))

}
