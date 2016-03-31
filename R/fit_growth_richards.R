#' Fit a Richards growth curve to the given data
#'
#' @inheritParams fit_growth_parametric
#'
#' @importFrom lazyeval lazy
#' @seealso \code{\link{fit_growth_parametric}}
#' @seealso \code{\link{richards}}
#' @seealso \url{https://en.wikipedia.org/wiki/Generalised_logistic_function}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_richards(mydata, Time, OD600)}
#'
fit_growth_richards <- function(df, time, data, ...) {
    fit_growth_parametric_(df, time_col=lazy(time), data_col=lazy(data),
                           control=grofit.control(model.type="richards"), ...)
}


#' @export
#' @inheritParams fit_growth_parametric_
#' @rdname fit_growth_richards
#' @importFrom grofit grofit.control
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_richards_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_richards_ <- function(df, time_col, data_col, ...) {
    fit_growth_parametric_(df, time_col=time_col, data_col=data_col,
                           control=grofit.control(model.type="richards"), ...)
}
