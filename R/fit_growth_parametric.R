#' Fit parametric models to growth data
#'
#' \code{fit_growth_parametric} uses \code{\link{gcFitModel}} from the
#' \pkg{grofit} package to fit a parametric model to growth data. Several
#' candidate models are fitted, and the model with the best AIC is returned.
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments for \code{\link{gcFitModel}}
#'
#' @return A list of types \code{gcfit} and \code{gcfitparametric} that contains:
#' \item{\code{type}}{The type of model (always "parametric")}
#' \item{\code{model}}{The model used (e.g., "logistic"). Models fit by grofit are prefixed with \code{grofit::}}
#' \item{\code{grofit}}{For models fit with grofit, the results from \code{\link{gcFitModel}}}
#' \item{\code{parameters}}{Model parameters}
#' \item{\code{fit}}{Data fitted to the model}
#' \item{\code{data}}{The original data frame and the names of columns used}
#' @seealso For specific parametric models, see \code{\link{fit_growth_logistic}}, \code{\link{fit_growth_gompertz}}, \code{\link{fit_growth_gompertz.exp}}, \code{\link{fit_growth_richards}}
#' @importFrom lazyeval lazy
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_parametric(mydata, Time, OD600)}
#'
fit_growth_parametric <- function(df, time, data, ...) {
    fit_growth_parametric_(df, time_col=lazy(time), data_col=lazy(data), ...)
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
fit_growth_parametric_ <- function(df, time_col, data_col, ...) {

     ignoreme <- capture.output(
        gres <- gcFitModel(time = lazy_eval(time_col, df),
                           data = lazy_eval(data_col, df), ...)
    )

    result <- list(
        type = "parametric",
        model = paste("grofit", gres$model, sep="::"),
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
    class(result) <- c("gcfit", "gcfitparametric")
    result
}
