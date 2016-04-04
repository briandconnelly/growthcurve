#' Fit smooth splines to growth data
#' 
#' \code{fit_growth_spline} uses \code{\link{gcFitSpline}} from the \pkg{grofit}
#' package to fit a smoothed spline to growth data.
#'
#' @inheritParams fit_growth_parametric
#' @param ... Additional arguments for \code{\link{gcFitSpline}}
#'
#' @return A list of types \code{gcfit} and \code{gcfitspline} that contains:
#' \item{\code{type}}{The type of model (always "spline")}
#' \item{\code{model}}{The model used (e.g., "spline"). Models fit by grofit are prefixed with \code{grofit::}}
#' \item{\code{grofit}}{For models fit with grofit, the results from \code{\link{gcFitSpline}}}
#' \item{\code{parameters}}{Model parameters}
#' \item{\code{fit}}{Data fitted to the model}
#' \item{\code{data}}{The original data frame and the names of columns used}
#' @importFrom lazyeval lazy
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_spline(mydata, Time, OD600)}
#'
fit_growth_spline <- function(df, time, data, ...) {
    fit_growth_spline_(df, time_col=lazy(time), data_col=lazy(data), ...)
}


#' @inheritParams fit_growth_parametric_
#' @export
#' @importFrom grofit gcFitSpline
#' @importFrom lazyeval lazy_eval
#' @rdname fit_growth_spline
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_spline_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_spline_ <- function(df, time_col, data_col, ...) {

    ignoreme <- capture.output(
        gres <- gcFitSpline(time=lazy_eval(time_col, df),
                            data=lazy_eval(data_col, df), ...)
    )

    result <- list(
        type = "spline",
        model = paste("grofit", "spline", sep="::"),
        grofit = gres,
        parameters = list(
            lag_length = gres$parameters$lambda,
            max_rate = gres$parameters$mu,
            max_growth = gres$parameters$A,
            integral = gres$parameters$integral
        ),
        fit = list(
            time = gres$fit.time,
            data = gres$fit.data,
            residuals = gres$raw.data - gres$fit.data
        ),
        data = list(
            df = df,
            time_col = as.character(time_col)[1],
            data_col = as.character(data_col)[1]
        )
    )
    class(result) <- c("gcfit", "gcfitspline")
    result
}
