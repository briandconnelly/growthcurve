#' Fit a Gompertz growth curve to the given data
#'
#' @inheritParams fit_growth_parametric
#'
#' @importFrom grofit grofit.control
#' @seealso \code{\link{fit_growth_parametric}}
#' @seealso \code{\link{gompertz}}
#' @seealso \url{https://en.wikipedia.org/wiki/Gompertz_function}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gompertz(mydata, Time, OD600)}
fit_growth_gompertz <- function(df, time, data, ...) {
    ctl <- grofit.control(model.type = "gompertz", suppress.messages = TRUE)
    fit_growth_parametric(df, time = time, data = data, control = ctl, ...)
}

#' @export
#' @inheritParams fit_growth_parametric_
#' @rdname fit_growth_gompertz
#' @importFrom grofit grofit.control
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gompertz_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_gompertz_ <- function(df, time_col, data_col, ...) {
    ctl <- grofit.control(model.type = "gompertz", suppress.messages = TRUE)
    fit_growth_parametric_(df = df, time_col = time_col, data_col = data_col,
                           control = ctl, ...)
}
