#' Plot growth data and its fitted growth curve
#'
#' @param x A fit for some growth data (a \code{growthcurve} object)
#' @param y Not used
#' @param show_fit Whether or not to show the fitted curve (default: \code{TRUE})
#' @param show_data Whether or not to show the original data (default \code{TRUE})
#' @param show_maxrate Whether or not to show a tangent line where the maximum growth rate occurs (default \code{TRUE})
#' @param show_asymptote Whether or not to indicate the maximum growth level (default \code{FALSE})
#' @param show_lag Whether or not to indicate where lag phase ends (default \code{FALSE}
#' @param ... Optional formatting arguments. Includes \code{xlab}, \code{ylab},
#' \code{title}, \code{subtitle},
#' \code{fit.color}, \code{fit.linetype}, \code{fit.size},
#' \code{data.color}, \code{data.fill}, \code{data.shape},
#' \code{data.size}, \code{data.stroke},
#' \code{maxrate.color}, \code{maxrate.linetype}, \code{maxrate.size},
#' \code{asymptote.color}, \code{asymptote.linetype},
#' \code{asymptote.size}, \code{lag.color},
#' \code{lag.linetype}, \code{lag.size}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get a logistic fit for some data and plot it
#' lfit <- fit_growth_logistic(mydata, Time, OD600)
#' plot(lfit)
#' }
#'
plot.growthcurve <- function(x, y = NULL, show_fit = TRUE, show_data = TRUE,
                             show_maxrate = TRUE, show_asymptote = FALSE,
                             show_lag = FALSE, ...) {
    other <- list(...)

    fmt_default <- list(
        data.color = "grey50",
        data.fill = "grey50",
        data.shape = 1,
        data.size = 1,
        data.stroke = 0.6,
        fit.color = "blue",
        fit.linetype = "solid",
        fit.size = 1.2,
        maxrate.color = "grey20",
        maxrate.linetype = "dashed",
        maxrate.size = 1,
        asymptote.color = "grey20",
        asymptote.linetype = "dotted",
        asymptote.size = 0.8,
        lag.color = "grey20",
        lag.linetype = "dotted",
        lag.size = 0.8
    )

    get_fmt <- function(x) {
        ifelse(x %in% names(other), get(x, other), get(x, fmt_default))
    }

    get_arg <- function(t, missing = NULL) {
        if (t %in% names(other)) get(t, other)
        else missing
    }

    xrange <- range(pretty(c(x$fit$time, x$data$df[[x$data$time_col]])))
    yrange <- range(pretty(c(x$fit$data, x$data$df[[x$data$data_col]])))

    plot.new()
    plot.window(xlim = xrange, ylim = yrange)
    axis(1)
    axis(2)

    if (show_fit) {
        if (identical(x$type, "spline")) {
            p <- predict(x)
            fitx <- p$x
            fity <- p$y
        }
        else {
            fitx <- x$data$df[[x$data$time_col]]
            fity <- predict(x)
        }
        try(lines(x = fitx, y = fity,
                  col = get_fmt("fit.color"),
                  lwd = get_fmt("fit.size"),
                  lty = get_fmt("fit.linetype")))
    }

    if (show_data) {
        try(points(x = x$data$df[[x$data$time_col]],
                   y = x$data$df[[x$data$data_col]],
                   col = get_fmt("data.color"),
                   bg = get_fmt("data.fill"),
                   lwd = get_fmt("data.size"),
                   pch = get_fmt("data.shape")))
    }

    if (show_maxrate) {
        icept <- x$parameters$max_rate$value - (x$parameters$max_rate$time * x$parameters$max_rate$rate)
        try(abline(a = icept,
                   b = x$parameters$max_rate$rate,
                   col = get_fmt("maxrate.color"),
                   lwd = get_fmt("maxrate.size"),
                   lty = get_fmt("maxrate.linetype")))
    }

    if (show_asymptote) {
        try(abline(h = x$parameters$asymptote,
                   lwd = get_fmt("asymptote.size"),
                   lty = get_fmt("asymptote.linetype"),
                   col = get_fmt("asymptote.color")))
    }

    if (show_lag) {
        try(abline(v = x$parameters$lag_length[[1]],
                   lwd = get_fmt("lag.size"),
                   lty = get_fmt("lag.linetype"),
                   col = get_fmt("lag.color")))
    }

    title(main = get_arg("title", missing = NULL),
          sub = get_arg("subtitle", missing = NULL),
          xlab = get_arg("xlab", missing = x$data$time_col),
          ylab = get_arg("ylab", missing = x$data$data_col))

}
