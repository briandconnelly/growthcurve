#' Create a ggplot for a growth curve
#'
#' @inheritParams plot.growthcurve
#' @param object A fit for some growth data (a \code{growthcurve} object)
#' @param xscale Transformation to apply to X axis values (e.g., \code{log}, \code{sqrt}. Default: \code{identity}). See \code{\link[ggplot2]{scale_continuous}}.
#' @param yscale Transformation to apply to Y axis values (e.g., \code{log}, \code{sqrt}. Default: \code{identity}). See \code{\link[ggplot2]{scale_continuous}}.
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
                                 xscale = "identity", yscale = "identity",
                                 ...) {

    stop_without_package("ggplot2")

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
        asymptote.size = 0.5
    )

    get_fmt <- function(x) {
        ifelse(x %in% names(other), get(x, other), get(x, fmt_default))
    }

    get_arg <- function(t, missing = NULL) {
        if (t %in% names(other)) get(t, other)
        else missing
    }

    p <- ggplot2::ggplot(
        data = object$data$df,
        mapping = ggplot2::aes(x = object$data$df[[object$data$time_col]],
                               y = object$data$df[[object$data$data_col]])
        )

    if (show_data) {
        p <- p + ggplot2::geom_point(
            alpha = get_fmt("data.alpha"),
            color = get_fmt("data.color"),
            fill = get_fmt("data.fill"),
            shape = get_fmt("data.shape"),
            size = get_fmt("data.size"),
            stroke = get_fmt("data.stroke")
            )
    }

    if (show_fit) {
        p <- p + ggplot2::geom_line(
            mapping = ggplot2::aes(x = object$fit$x,y = object$fit$y),
            alpha = get_fmt("fit.alpha"),
            color = get_fmt("fit.color"),
            linetype = get_fmt("fit.linetype"),
            size = get_fmt("fit.size")
            )
    }

    if (show_maxrate) {
        icept <- object$parameters$max_rate$value - (object$parameters$max_rate$time * object$parameters$max_rate$rate)
        p <- p + ggplot2::geom_abline(slope = object$parameters$max_rate$rate,
                                      intercept = icept,
                                      alpha = get_fmt("maxrate.alpha"),
                                      color = get_fmt("maxrate.color"),
                                      linetype = get_fmt("maxrate.linetype"),
                                      size = get_fmt("maxrate.size"))
    }

    if (show_asymptote) {
        p <- p + ggplot2::geom_hline(
            yintercept = object$parameters$asymptote,
            alpha = get_fmt("asymptote.alpha"),
            color = get_fmt("asymptote.color"),
            linetype = get_fmt("asymptote.linetype"),
            size = get_fmt("asymptote.size")
        )
    }

    p <- p + ggplot2::scale_y_continuous(trans = yscale)
    p <- p + ggplot2::scale_x_continuous(trans = xscale)

    p <- p + ggplot2::labs(
        x = get_arg("xlab", missing = object$data$time_col),
        y = get_arg("ylab", missing = object$data$data_col),
        title = get_arg("title", missing = NULL),
        subtitle = get_arg("subtitle", missing = NULL),
        caption = get_arg("caption", missing = NULL)
        )
    p
}

#' @export
gggrowthcurve <- autoplot.growthcurve
