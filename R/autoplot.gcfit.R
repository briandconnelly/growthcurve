#' Create a ggplot for a growth curve
#'
#' @importFrom ggplot2 autoplot geom_point geom_path aes geom_line geom_hline geom_vline scale_y_continuous scale_x_continuous
#' @param object A fit for some growth data
#' @param show_curve Whether or not to show the fitted curve (default: \code{TRUE})
#' @param show_data Whether or not to show original data points (default: \code{TRUE})
#' @param show_maxrate Whether or not to indicate the maximum growth rate (default: \code{TRUE})
#' @param show_asymptote Whether or not to show the asymptote (default: \code{TRUE})
#' @param show_lag Whether or not to indicate where lag phase ends (default: \code{FALSE}
#' @param xtrans Transformation to apply to X axis values (e.g., \code{log}, \code{sqrt}. Default: \code{identity}). See \code{\link{scale_continuoius}}.
#' @param ytrans Transformation to apply to Y axis values (e.g., \code{log}, \code{sqrt}. Default: \code{identity}). See \code{\link{scale_continuoius}}.
#' @param xlab Axis label for X axis. Defaults to the column name in the original data set.
#' @param ylab Axis label for Y axis. Defaults to the column name in the original data set.
#' @param title Plot title
#' @param subtitle Plot subtitle
#' @param caption Plot caption
#'
#' @return A ggplot object
#' @export
#'
#' @examples
#' \dontrun{
#' # Get a logistic fit for some data and extract its residuals
#' lfit <- fit_growth_logistic(df=mydata, Time, OD600)
#' autoplot(lfit, title="My Growth Data")}
#' 
autoplot.gcfit <- function(object, show_curve = TRUE, show_data = TRUE,
                           show_maxrate = TRUE, show_asymptote = FALSE,
                           show_lag = FALSE,
                           xtrans = "identity", ytrans = "identity",
                           xlab = NULL, ylab = NULL,
                           title = NULL, subtitle = NULL, caption = NULL) {

    p <- ggplot(data = object$data$df,
                aes(x = object$data$df[[object$data$time_col]],
                    y = object$data$df[[object$data$data_col]]))

    if (show_data) {
        p <- p + geom_point(shape = 1)
    }

    if (show_curve) {
        p <- p + geom_path(aes(x = object$fit$time, y = object$fit$data))
    }

    if (show_maxrate) {
        yvals <- object$parameters$max_rate[[1]] * (object$fit$time - object$parameters$lag_length[[1]])
        p <- p + geom_line(aes(y = yvals), linetype = "dashed")
    }

    if (show_asymptote) {
        p <- p + geom_hline(yintercept = object$parameters$max_growth[[1]])
    }

    if (show_lag) {
        p <- p + geom_vline(xintercept = object$parameters$lag_length[[1]])
    }

    p <- p + scale_y_continuous(trans = ytrans)
    p <- p + scale_x_continuous(trans = xtrans)

    p <- p + labs(x = ifelse(is.null(xlab), object$data$time_col, xlab),
                  y = ifelse(is.null(ylab), object$data$data_col, ylab),
                  title = title,
                  subtitle = subtitle,
                  caption = caption)

    p
}
