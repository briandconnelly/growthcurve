#' Fit a modified Gompertz growth curve to the given data
#'
#' @inheritParams fit_growth_parametric
#'
#' @rdname fit_growth_gompertz_exp
#' @importFrom lazyeval lazy
#' @seealso \code{\link{fit_growth_parametric}}
#' @seealso \code{\link{gompertz.exp}}
#' @seealso \url{https://en.wikipedia.org/wiki/Gompertz_function}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gompertz.exp(df=mydata, Time, OD600)}
fit_growth_gompertz.exp <- function(df, time, data, ...) {
    fit_growth_parametric_(df, time_col=lazy(time), data_col=lazy(data),
                           control=grofit.control(model.type="gompertz.exp"),
                           ...)
}

#' @export
#' @inheritParams fit_growth_parametric_
#' @rdname fit_growth_gompertz_exp
#' @importFrom grofit grofit.control
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gompertz.exp_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_gompertz.exp_ <- function(df, time_col, data_col, ...) {
    fit_growth_parametric_(df, time_col=time_col, data_col=data_col,
                           control=grofit.control(model.type="gompertz.exp"),
                           ...)
}
