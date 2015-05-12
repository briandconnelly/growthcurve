#' Fit a modified Gompertz growth curve to the given data
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param growth Name of the column in \code{df} that contains growth data
#' @param ... Additional arguments for \code{\link{gcFitModel}}
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
fit_growth_gompertz.exp <- function(df, time, growth, ...)
{
    fit_growth_gompertz.exp_(df, time_col=lazy(time), growth_col=lazy(growth), ...)
}

#' @export
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param growth_col String giving the name of the column in \code{df} that
#' contains growth data
#' @rdname fit_growth_gompertz_exp
#' @importFrom grofit grofit.control
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gompertz.exp_(df=mydata, time_col='Time', growth_col='OD600')}
#'
fit_growth_gompertz.exp_ <- function(df, time_col, growth_col, ...)
{
    fit_growth_parametric_(df, time_col=time_col, growth_col=growth_col,
                           control=grofit.control(model.type='gompertz.exp'), ...)
}
