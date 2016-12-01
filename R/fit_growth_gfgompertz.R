#' Fit a Gompertz growth curve to the given data
#'
#' @inheritParams fit_growth_gfparametric
#'
#' @importFrom grofit grofit.control
#' @seealso \code{\link{fit_growth_gfparametric}}
#' @seealso \code{\link{gompertz}}
#' @seealso \url{https://en.wikipedia.org/wiki/Gompertz_function}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfgompertz(mydata, Time, OD600)}
fit_growth_gfgompertz <- function(df, time, data, ...) {
    ctl <- grofit.control(model.type = "gompertz", suppress.messages = TRUE)
    fit_growth_gfparametric(df, time = time, data = data, control = ctl, ...)
}

#' @export
#' @inheritParams fit_growth_gfparametric_
#' @rdname fit_growth_gfgompertz
#' @importFrom grofit grofit.control
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfgompertz_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_gfgompertz_ <- function(df, time_col, data_col, ...) {
    ctl <- grofit.control(model.type = "gompertz", suppress.messages = TRUE)
    fit_growth_gfparametric_(df = df, time_col = time_col, data_col = data_col,
                             control = ctl, ...)
}
