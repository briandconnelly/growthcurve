#' Create a ggplot for a growth curve
#'
#' @importFrom ggplot2 autoplot ggplot geom_point geom_path aes geom_line geom_hline geom_vline scale_y_continuous scale_x_continuous labs
#' @param object A fit for some growth data
#' @param show_fit Whether or not to show the fitted curve (default: \code{TRUE})
#' @param show_data Whether or not to show original data points (default: \code{TRUE})
#' @param show_maxrate Whether or not to indicate the maximum growth rate (default: \code{TRUE})
#' @param show_asymptote Whether or not to show the asymptote (default: \code{TRUE})
#' @param show_lag Whether or not to indicate where lag phase ends (default: \code{FALSE}
#' @param xtrans Transformation to apply to X axis values (e.g., \code{log}, \code{sqrt}. Default: \code{identity}). See \code{\link{scale_continuoius}}.
#' @param ytrans Transformation to apply to Y axis values (e.g., \code{log}, \code{sqrt}. Default: \code{identity}). See \code{\link{scale_continuoius}}.
#' @param title Plot title
#' @param subtitle Plot subtitle
#' @param caption Plot caption
#' @param ... Additional formatting arguments. Includes \code{xlab}, \code{ylab},
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
#' # Get a logistic fit for some data and extract its residuals
#' lfit <- fit_growth_logistic(df=mydata, Time, OD600)
#' autoplot(lfit, title="My Growth Data")}
#' 
autoplot.gcfit <- function(object, show_fit = TRUE, show_data = TRUE,
                           show_maxrate = TRUE, show_asymptote = FALSE,
                           show_lag = FALSE, title = NULL, subtitle = NULL,
                           caption = NULL,
                           xtrans = "identity", ytrans = "identity", ...) {

    other <- list(...)
    
    # TODO: add title, subtitle, caption. Problem: doesn't work well with NULL defaults. "" produces spaces in those areas.
    fmt_default <- list(
        xlab = object$data$time_col,
        ylab = object$data$data_col,
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
    
    p <- ggplot(data = object$data$df,
                aes(x = object$data$df[[object$data$time_col]],
                    y = object$data$df[[object$data$data_col]]))

    if (show_data) {
        p <- p + geom_point(alpha = get_fmt("data.alpha"),
                            color = get_fmt("data.color"),
                            fill = get_fmt("data.fill"),
                            shape = get_fmt("data.shape"),
                            size = get_fmt("data.size"),
                            stroke = get_fmt("data.stroke"))
    }

    if (show_fit) {
        p <- p + geom_line(aes(x = object$fit$time, y = object$fit$data),
                           alpha = get_fmt("fit.alpha"),
                           color = get_fmt("fit.color"),
                           linetype = get_fmt("fit.linetype"),
                           size = get_fmt("fit.size"))
    }

    if (show_maxrate) {
        yvals <- object$parameters$max_rate[[1]] * (object$fit$time - object$parameters$lag_length[[1]])
        p <- p + geom_line(aes(y = yvals),
                           alpha = get_fmt("maxrate.alpha"),
                           color = get_fmt("maxrate.color"),
                           linetype = get_fmt("maxrate.linetype"),
                           size = get_fmt("maxrate.size"))
    }

    if (show_asymptote) {
        p <- p + geom_hline(yintercept = object$parameters$max_growth[[1]],
                            alpha = get_fmt("asymptote.alpha"),
                            color = get_fmt("asymptote.color"),
                            linetype = get_fmt("asymptote.linetype"),
                            size = get_fmt("asymptote.size"))
    }

    if (show_lag) {
        p <- p + geom_vline(xintercept = object$parameters$lag_length[[1]],
                            alpha = get_fmt("lag.alpha"),
                            color = get_fmt("lag.color"),
                            linetype = get_fmt("lag.linetype"),
                            size = get_fmt("lag.size"))
    }

    p <- p + scale_y_continuous(trans = ytrans)
    p <- p + scale_x_continuous(trans = xtrans)

    p <- p + labs(x = get_fmt("xlab"),
                  y = get_fmt("ylab"),
                  title = title,
                  subtitle = subtitle,
                  caption = caption)
    p
}

#' @export
gggrowthcurve <- autoplot.gcfit
