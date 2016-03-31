#' Fit a logistic growth curve to the given data
#'
#' @inheritParams fit_growth_parametric
#'
#' @importFrom lazyeval lazy
#' @seealso \code{\link{fit_growth_parametric}}
#' @seealso \code{\link{logistic}}
#' @seealso \url{https://en.wikipedia.org/wiki/Logistic_function}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_logistic(mydata, Time, OD600)}
#'
fit_growth_logistic <- function(df, time, data, ...) {
    fit_growth_parametric_(df, time_col=lazy(time), data_col=lazy(data),
                           control=grofit.control(model.type="logistic"), ...)
}


#' @export
#' @inheritParams fit_growth_parametric_
#' @rdname fit_growth_logistic
#' @importFrom grofit grofit.control
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_logistic_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_logistic_ <- function(df, time_col, data_col, ...) {
    fit_growth_parametric_(df, time_col=time_col, data_col=data_col,
                           control=grofit.control(model.type="logistic"), ...)
}
