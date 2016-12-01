#' Fit a Gompertz Curve to Growth Data
#' 
#' \code{fit_growth_gompertz} fits a Gompertz curve to a tidy growth data set
#' using nonlinear least squares
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments (not used)
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Gompertz_function}
#' @return A \code{growthcurve} object with the following fields:
#' \itemize{
#'     \item \code{type}: The type of fit (here "gompertz")
#'     \item \code{parameters}: Parameters for the fitted model. A list with
#'     fields:
#'     \itemize{
#'         \item{TODO}: TODO
#'     }
#'     \item \code{model}: An \code{\link{nls}} object containing the fit.
#'     \item \code{data}: A list containing the input data frame (\code{df}),
#'       the name of the column containing times (\code{time_col}), and the
#'       name of the column containing growth values (\code{data_col}).
#' }
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gompertz(mydata, Time, OD600)}
#'
fit_growth_gompertz <- function(df, time, data, ...) {
    # TODO: should ... be lazy?
    fit_growth_gompertz_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_gompertz
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
#' @examples
#' \dontrun{
#' fit_growth_gompertz_(mydata, "Time", "OD600")
#' }
fit_growth_gompertz_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)
    nlsmodel <- nls(growth_data ~ SSgompertz(time_data, Asym, b2, b3), df, ...)
    
    result <- structure(list(type = "gompertz",
                             parameters = list(),
                             model = nlsmodel,
                             data = list(df = df,
                                         time_col = as.character(time_col)[1],
                                         data_col = as.character(data_col)[1])),
                        class = "growthcurve")
    
    result
}
