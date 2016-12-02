#' Create a ggplot for a growth curve
#'
#' @param object A fit for some growth data (a \code{growthcurve} object)
#' @param show_fit Whether or not to show the fitted curve (default: \code{TRUE})
#' @param show_data Whether or not to show original data points (default: \code{TRUE})
#' @param show_maxrate Whether or not to indicate the maximum growth rate (default: \code{TRUE})
#' @param show_asymptote Whether or not to show the asymptote (default: \code{TRUE})
#' @param show_lag Whether or not to indicate where lag phase ends (default: \code{FALSE}
#' @param xscale Transformation to apply to X axis values (e.g., \code{log}, \code{sqrt}. Default: \code{identity}). See \code{\link[ggplot2]{scale_continuous}}.
#' @param yscale Transformation to apply to Y axis values (e.g., \code{log}, \code{sqrt}. Default: \code{identity}). See \code{\link[ggplot2]{scale_continuous}}.
#' @param ... Additional formatting arguments. Includes \code{xlab}, \code{ylab},
#' \code{title}, \code{subtitle}, \code{caption},
#' \code{fit.alpha}, \code{fit.color}, \code{fit.linetype}, \code{fit.size},
#' \code{data.alpha}, \code{data.color}, \code{data.fill}, \code{data.shape},
#' \code{data.size}, \code{data.stroke}, \code{maxrate.alpha},
#' \code{maxrate.color}, \code{maxrate.linetype}, \code{maxrate.size},
#' \code{asymptote.alpha}, \code{asymptote.color}, \code{asymptote.linetype},
#' \code{asymptote.size}, \code{lag.alpha}, \code{lag.color},
#' \code{lag.linetype}, \code{lag.size}
#'
#' @return A ggplot object
#' @aliases gggrowthcurve
#' @export
#'
#' @examples
#' \dontrun{
#' # Get a logistic fit for some data and plot it
#' lfit <- fit_growth_logistic(mydata, Time, OD600)
#' autoplot(lfit, title="My Growth Data")}
#' 
autoplot.growthcurve <- function(object, show_fit = TRUE, show_data = TRUE,
                                 show_maxrate = TRUE, show_asymptote = FALSE,
                                 show_lag = FALSE, xscale = "identity",
                                 yscale = "identity", ...) {

    if (!requireNamespace("ggplot2", quietly = TRUE)) {
        stop("ggplot2 is required.")
    }

    other <- list(...)

    fmt_default <- list(
        data.alpha = 1,
        data.color = "grey50",
        data.fill = "grey50",
        data.shape = 1,
        data.size = 2,
        data.stroke = 0.6,
        fit.alpha = 1,
        fit.color = "blue",
        fit.linetype = "solid",
        fit.size = 0.7,
        maxrate.alpha = 1,
        maxrate.color = "grey20",
        maxrate.linetype = "dashed",
        maxrate.size = 0.5,
        asymptote.alpha = 1,
        asymptote.color = "grey20",
        asymptote.linetype = "dotted",
        asymptote.size = 0.5,
        lag.alpha = 1,
        lag.color = "grey20",
        lag.linetype = "dotted",
        lag.size = 0.5
    )

    get_fmt <- function(x) {
        ifelse(x %in% names(other), get(x, other), get(x, fmt_default))
    }

    get_arg <- function(t, missing = NULL) {
        if (t %in% names(other)) get(t, other)
        else missing
    }

    p <- ggplot2::ggplot(data = object$data$df,
                         ggplot2::aes(x = object$data$df[[object$data$time_col]],
                                      y = object$data$df[[object$data$data_col]]))

    if (show_data) {
        p <- p + ggplot2::geom_point(alpha = get_fmt("data.alpha"),
                                     color = get_fmt("data.color"),
                                     fill = get_fmt("data.fill"),
                                     shape = get_fmt("data.shape"),
                                     size = get_fmt("data.size"),
                                     stroke = get_fmt("data.stroke"))
    }

    if (show_fit) {
        p <- p + ggplot2::geom_line(ggplot2::aes(x = object$data$df[[object$data$time_col]],
                                                 y = predict(object)),
                                    alpha = get_fmt("fit.alpha"),
                                    color = get_fmt("fit.color"),
                                    linetype = get_fmt("fit.linetype"),
                                    size = get_fmt("fit.size"))
    }

    if (show_maxrate) {
        yvals <- object$parameters$max_rate[[1]] * (object$fit$time - object$parameters$lag_length[[1]])
        p <- p + ggplot2::geom_line(ggplot2::aes(y = yvals),
                                    alpha = get_fmt("maxrate.alpha"),
                                    color = get_fmt("maxrate.color"),
                                    linetype = get_fmt("maxrate.linetype"),
                                    size = get_fmt("maxrate.size"))
    }

    if (show_asymptote) {
        p <- p + ggplot2::geom_hline(
            yintercept = object$parameters$max_growth[[1]],
            alpha = get_fmt("asymptote.alpha"),
            color = get_fmt("asymptote.color"),
            linetype = get_fmt("asymptote.linetype"),
            size = get_fmt("asymptote.size")
        )
    }

    if (show_lag) {
        p <- p + ggplot2::geom_vline(
            xintercept = object$parameters$lag_length[[1]],
            alpha = get_fmt("lag.alpha"),
            color = get_fmt("lag.color"),
            linetype = get_fmt("lag.linetype"),
            size = get_fmt("lag.size")
        )
    }

    p <- p + ggplot2::scale_y_continuous(trans = yscale)
    p <- p + ggplot2::scale_x_continuous(trans = xscale)

    p <- p + ggplot2::labs(x = get_arg("xlab", missing = object$data$time_col),
                           y = get_arg("ylab", missing = object$data$data_col),
                           title = get_arg("title", missing = NULL),
                           subtitle = get_arg("subtitle", missing = NULL),
                           caption = get_arg("caption", missing = NULL))
    p
}

#' @export
gggrowthcurve <- autoplot.growthcurve
