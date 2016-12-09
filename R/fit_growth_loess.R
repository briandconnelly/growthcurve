#' Fit a Curve to Growth Data using LOESS
#' 
#' \code{fit_growth_loess} fits curve to a tidy growth data set using LOESS
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments to \code{\link{loess}}
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Local_regression}
#' @return A \code{\link{growthcurve}} object with the following fields:
#' \itemize{
#'     \item \code{type}: The type of fit (here "loess")
#'     \item \code{parameters}: Growth parameters from the fitted model. A list
#'     with fields:
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
#' fit_growth_loess(mydata, Time, OD600)}
#'
fit_growth_loess <- function(df, time, data, ...) {
    fit_growth_loess_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_loess
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
#' @examples
#' \dontrun{
#' fit_growth_loess_(mydata, "Time", "OD600")
#' }
fit_growth_loess_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)
    lmodel <- loess(growth_data ~ time_data, data = df, ...)

    lmodel_y <- predict(lmodel)
    lmodel_dydt <- diff(lmodel_y) / diff(time_data)
    i_max_rate <- which.max(lmodel_dydt)

    growthcurve(
        type = "loess",
        model = lmodel,
        f = NULL,
        parameters = list(
            asymptote = max(lmodel_y),
            max_rate = list(
                time = time_data[i_max_rate],
                value = lmodel_y[i_max_rate],
                rate = lmodel_dydt[i_max_rate]
            ),
            integral = calculate_auc(time_data, predict(lmodel))
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
