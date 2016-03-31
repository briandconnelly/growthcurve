#' Fit a growth curve to the given data
#'
#' @inheritParams fit_growth_parametric
#' @param type Type of model to fit. One of \code{gompertz}, \code{gompertz.exp}, \code{logistic}, \code{parametric}, \code{richards}, \code{spline} (default: \code{parametric})
#'
#' @importFrom lazyeval lazy
#' @seealso \code{\link{fit_growth_parametric}}
#' @seealso \code{\link{fit_growth_spline}}
#' @seealso \url{https://en.wikipedia.org/wiki/Generalised_logistic_function}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth(df=mydata, Time, OD600, type = "logistic")}
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
        fit_growth_spline_(df, time_col = time_col, data_col = data_col, ...)
    }
    else if (identical(type, "parametric")) {
        fit_growth_parametric_(df, time_col = time_col, data_col = data_col,
                               ...)
    }
    else {
        fit_growth_parametric_(df, time_col = time_col, data_col = data_col,
                               control = grofit.control(model.type=type), ...)
    }
}
