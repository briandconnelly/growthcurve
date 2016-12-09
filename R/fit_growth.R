#' Fit a growth curve to the given data
#' 
#' \code{fit_growth} fits a growth curve using either a parametric model or 
#' splines.
#'
#' @param df a data frame
#' @param time column in \code{df} that contains time data
#' @param data column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments for specific model function
#'
#' @return A list of types \code{gcfit} and \code{gcfitparametric} that contains:
#' \item{\code{type}}{The type of model (always "parametric")}
#' \item{\code{model}}{The model used (e.g., "logistic"). Models fit by grofit are prefixed with \code{grofit::}}
#' \item{\code{grofit}}{For models fit with grofit, the results from \code{\link[grofit]{gcFitModel}}}
#' \item{\code{parameters}}{Model parameters}
#' \item{\code{fit}}{Data fitted to the model}
#' \item{\code{data}}{The original data frame and the names of columns used}
#' @seealso \code{\link{fit_growth_grofit_parametric}}
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
    fit_growth_(
        df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        type = type,
        ...
    )
}


#' @rdname fit_growth
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
fit_growth_ <- function(df, time_col, data_col, type = "parametric", ...) {

    if (!type %in% c("parametric", "logistic", "gompertz", "gompertz.exp",
                    "richards", "spline")) {
        stop(sprintf("Unsupported model type '%s'", type))
    }

    if (identical(type, "spline")) {
        ctl <- grofit::grofit.control(suppress.messages = TRUE)
        fit_growth_spline_(df, time_col = time_col, data_col = data_col,
                           control = ctl, ...)
    }
    else if (identical(type, "parametric")) {
        ctl <- grofit::grofit.control(suppress.messages = TRUE)
        fit_growth_grofit_parametric_(df, time_col = time_col, data_col = data_col,
                               control = ctl, ...)
    }
    else {
        ctl <- grofit::grofit.control(model.type = type,
                                      suppress.messages = TRUE)
        fit_growth_grofit_parametric_(df, time_col = time_col, data_col = data_col,
                               control = ctl, ...)
    }
}
