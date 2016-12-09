#' Fit a Curve to Growth Data using LOWESS
#' 
#' \code{fit_growth_lowess} fits curve to a tidy growth data set using LOWESS
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments to \code{\link{lowess}}
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Local_regression}
#' @return A \code{\link{growthcurve}} object with the following fields:
#' \itemize{
#'     \item \code{type}: The type of fit (here "lowess")
#'     \item \code{parameters}: Growth parameters from the fitted model. A list
#'     with fields:
#'     \itemize{
#'         \item{TODO}: TODO
#'     }
#'     \item \code{model}: An list containing the x and y values from a
#'     \code{\link{lowess}} smooth
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
#' fit_growth_lowess(mydata, Time, OD600)}
#'
fit_growth_lowess <- function(df, time, data, ...) {
    fit_growth_lowess_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_lowess
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
#' @examples
#' \dontrun{
#' fit_growth_lowess_(mydata, "Time", "OD600")
#' }
fit_growth_lowess_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)
    lmodel <- lowess(x = time_data, y = growth_data, ...)
    
    lmodel_dydt <- diff(lmodel$y) / diff(lmodel$x)
    i_max_rate <- which.max(lmodel_dydt)
    
    growthcurve(
        type = "lowess",
        model = lmodel,
        f = NULL,
        parameters = list(
            asymptote = max(lmodel$y),
            max_rate = list(
                time = lmodel$x[i_max_rate],
                value = lmodel$y[i_max_rate],
                rate = lmodel_dydt[i_max_rate]
            ),
            integral = calculate_auc(time_data, lmodel$y)
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
