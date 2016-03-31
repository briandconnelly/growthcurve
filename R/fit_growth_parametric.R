#' Fit parametric models to growth data
#'
#' \code{fit_growth_parametric} uses \code{\link{gcFitModel}} from the
#' \pkg{grofit} package to fit a parametric model to growth data. Several
#' candidate models are fitted, and the model with the best AIC is returned.
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' @param include_grofit Whether or not to include result object from grofit
#' (default: \code{TRUE})
#' @param ... Additional arguments for \code{\link{gcFitModel}}
#'
#' @return A list of type \code{gcfit} that contains (TODO - this is under construction). Use \code{names()} to see these items.
#' @seealso For specific parametric models, see \code{\link{fit_growth_logistic}}, \code{\link{fit_growth_gompertz}}, \code{\link{fit_growth_gompertz.exp}}, \code{\link{fit_growth_richards}}
#' @importFrom lazyeval lazy
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_parametric(mydata, Time, OD600)}
#'
fit_growth_parametric <- function(df, time, data, include_grofit = TRUE, ...) {
    fit_growth_parametric_(df, time_col=lazy(time), data_col=lazy(data),
                           include_grofit = include_grofit, ...)
}


#' @export
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @importFrom grofit gcFitModel
#' @importFrom lazyeval lazy_eval
#' @rdname fit_growth_parametric
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_parametric_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_parametric_ <- function(df, time_col, data_col,
                                   include_grofit = TRUE, ...) {
    ignoreme <- capture.output(
        gres <- gcFitModel(time = lazy_eval(time_col, df),
                           data = lazy_eval(data_col, df), ...)
    )

    result <- list()
    result$type <- "parametric"
    class(result) <- c("gcfit")

    result$uses_grofit <- TRUE
    if (include_grofit) result$grofit <- gres

    result$lag_length <- gres$parameters$lambda
    result$max_rate <- gres$parameters$mu
    result$max_growth <- gres$parameters$A
    result$integral <- gres$parameters$integral

    result$fit.time <- gres$fit.time # necessary? - yes, for splines?
    result$fit.data <- gres$fit.data
    result$residuals <- gres$raw.data - result$fit.data

    result$raw$df <- df
    result$raw$time_col <- as.character(time_col)[1]
    result$raw$data_col <- as.character(data_col)[1]

    result
}
