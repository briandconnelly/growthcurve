#' Fit a modified Gompertz growth curve to the given data
#'
#' @inheritParams fit_growth_parametric
#'
#' @rdname fit_growth_gompertz_exp
#' @importFrom grofit grofit.control
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
    ctl <- grofit.control(model.type = "gompertz.exp",
                          suppress.messages = TRUE)
    fit_growth_parametric(df, time = time, data = data, control = ctl, ...)
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
    ctl <- grofit.control(model.type = "gompertz.exp",
                          suppress.messages = TRUE)
    fit_growth_parametric_(df = df, time_col = time_col, data_col = data_col,
                           control = ctl, ...)
}
