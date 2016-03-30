#' Fit smooth splines to growth data
#' 
#' \code{fit_growth_spline} uses \code{\link{gcFitSpline}} from the \pkg{grofit}
#' package to fit a smoothed spline to growth data.
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' @param include_grofit Whether or not to include result object from grofit
#' (default: \code{TRUE})
#' @param ... Additional arguments for \code{\link{gcFitSpline}}
#'
#' @return A list of type \code{gcfit} that contains (TODO - this is under construction). Use \code{names()} to see these items.
#' @seealso \code{\link{gcFitSpline}}
#' @importFrom lazyeval lazy
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_spline(df=mydata, Time, OD600)}
#'
fit_growth_spline <- function(df, time, data, include_grofit = TRUE, ...) {
    fit_growth_spline_(df, time_col=lazy(time), data_col=lazy(data),
                       include_grofit = include_grofit, ...)
}


#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
#' @importFrom grofit gcFitSpline
#' @importFrom lazyeval lazy_eval
#' @rdname fit_growth_spline
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_spline_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_spline_ <- function(df, time_col, data_col, include_grofit = TRUE,
                               ...) {
    ignoreme <- capture.output(
        gres <- gcFitSpline(time=lazy_eval(time_col, df),
                            data=lazy_eval(data_col, df), ...)
    )

    result <- list()
    result$type <- "spline"
    class(result) <- c("gcfit")

    result$uses_grofit <- TRUE
    if (include_grofit) result$grofit <- gres

    result$lag_length <- gres$parameters$lambda
    result$max_rate <- gres$parameters$mu
    result$max_growth <- gres$parameters$A
    result$integral <- gres$parameters$integral

    result$fit.time <- gres$fit.time
    result$fit.data <- gres$fit.data
    result$spline <- gres$spline
    result$residuals <- residuals(gres$spline)

    result$raw$df <- df
    result$raw$time_col <- as.character(time_col)[1]
    result$raw$data_col <- as.character(data_col)[1]

    result
}
