#' Fit a growth curve to the given data
#' 
#' \code{fit_growth} fits a growth curve using either a parametric model or 
#' splines.
#'
#' @inheritParams fit_growth_gfparametric
#' @param type Type of model to fit. One of \code{parametric} (default),
#' \code{gompertz}, \code{gompertz.exp}, \code{logistic}, \code{parametric},
#' \code{richards}, or \code{spline}. If \code{parametric} is chosen, several       
#' candidate models are fitted, and the model with the best AIC is returned.
#' @return A list of types \code{gcfit} and \code{gcfitparametric} that contains:
#' \item{\code{type}}{The type of model (always "parametric")}
#' \item{\code{model}}{The model used (e.g., "logistic"). Models fit by grofit are prefixed with \code{grofit::}}
#' \item{\code{grofit}}{For models fit with grofit, the results from \code{\link{gcFitModel}}}
#' \item{\code{parameters}}{Model parameters}
#' \item{\code{fit}}{Data fitted to the model}
#' \item{\code{data}}{The original data frame and the names of columns used}
#' @importFrom lazyeval lazy
#' @seealso \code{\link{fit_growth_gfparametric}}
#' @seealso \code{\link{fit_growth_spline}}
#' @seealso \url{https://en.wikipedia.org/wiki/Generalised_logistic_function}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth(mydata, Time, OD600, type = "logistic")}
#'
fit_growth <- function(df, time, data, type = "parametric", ...) {
    fit_growth_(df, time_col = lazy(time), data_col = lazy(data),
                type = type, ...)
}


#' @export
#' @rdname fit_growth
#' @importFrom grofit grofit.control
fit_growth_ <- function(df, time_col, data_col, type = "parametric", ...) {

    if (!type %in% c("parametric", "logistic", "gompertz", "gompertz.exp",
                    "richards", "spline")) {
        stop(sprintf("Unsupported model type '%s'", type))
    }

    if (identical(type, "spline")) {
        ctl <- grofit.control(suppress.messages = TRUE)
        fit_growth_spline_(df, time_col = time_col, data_col = data_col,
                           control = ctl, ...)
    }
    else if (identical(type, "parametric")) {
        ctl <- grofit.control(suppress.messages = TRUE)
        fit_growth_gfparametric_(df, time_col = time_col, data_col = data_col,
                               control = ctl, ...)
    }
    else {
        ctl <- grofit.control(model.type = type, suppress.messages = TRUE)
        fit_growth_gfparametric_(df, time_col = time_col, data_col = data_col,
                               control = ctl, ...)
    }
}
