#' Fit a logistic growth curve to the given data
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' @param ... Additional arguments for \code{\link{gcFitModel}}
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
#' fit_growth_logistic(df=mydata, Time, OD600)}
#'
fit_growth_logistic <- function(df, time, data, ...)
{
    fit_growth_logistic_(df, time_col=lazy(time), data_col=lazy(data), ...)
}


#' @export
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @rdname fit_growth_logistic
#' @importFrom grofit grofit.control
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_logistic_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_logistic_ <- function(df, time_col, data_col, ...)
{
    fit_growth_parametric_(df, time_col=time_col, data_col=data_col,
                           control=grofit.control(model.type="logistic"), ...)
}
