#' Plot growth data and its fitted growth curve
#'
#' @param x A fit for some growth data
#' @param y Not used
#' @param show_fit Whether or not to show the fitted curve (default: \code{TRUE})
#' @param show_data Whether or not to show the original data (default \code{TRUE})
#' @param show_maxrate Whether or not to show a tangent line where the maximum growth rate occurs (default \code{TRUE})
#' @param show_asymptote Whether or not to indicate the maximum growth level (default \code{FALSE})
#' @param show_lag Whether or not to indicate where lag phase ends (default \code{FALSE}
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
plot.gcfit <- function(x, y = NULL, show_fit = TRUE, show_data = TRUE,
                       show_maxrate = TRUE, show_asymptote = FALSE,
                       show_lag = FALSE, ...) {
    opt_args <- list(...)

    opt_args$xlab <- ifelse("xlab" %in% names(opt_args), opt_args$xlab,
                            x$data$time_col)
    opt_args$ylab <- ifelse("ylab" %in% names(opt_args), opt_args$ylab,
                            x$data$data_col)
    opt_args$x <- x$fit$time
    opt_args$y <- x$fit$data
    opt_args$type <- "l"

    opt_args$show_maxrate <- NULL
    opt_args$show_data <- NULL
    opt_args$show_asymptote <- NULL

    # Plot the fitted curve
    if (show_fit) {
        try(do.call(plot, opt_args))
    }

    # Add the raw data points
    if (show_data) {
        points(x = x$data$df[[x$data$time_col]],
               y = x$data$df[[x$data$data_col]], ...)
    }

    if (show_lag) {
        try(abline(v = x$parameters$lag_length[[1]]))
    }

    # Add a tangent line where the maximum growth rate occurs
    if (show_maxrate) {
        yvals <- x$parameters$max_rate[[1]] * (x$fit$time - x$parameters$lag_length[[1]])
        try(lines(x = x$fit$time, y = yvals, lw = 2, lty = 2))
    }

    # Add a horizontal line indicating the maximum growth level
    if (show_asymptote) {
        try(abline(h = x$parameters$max_growth[[1]], lw = 2, lty = 3))
    }

}
