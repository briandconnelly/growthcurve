#' Fit a Linear Model  to Growth Data
#' 
#' \code{fit_growth_linear} fits a linear model to a tidy growth data set
#' using nonlinear least squares
#'
#' @inheritParams fit_growth
#' @param ... Additional arguments to \code{\link[stats]{lm}}
#'
#' @return A \code{\link{growthcurve}} object with the following fields:
#' \itemize{
#'     \item \code{type}: The type of fit (here "linear")
#'     \item \code{parameters}: Growth parameters from the fitted model. A list
#'     with fields:
#'     \itemize{
#'         \item{TODO}: TODO
#'     }
#'     \item \code{model}: An \code{\link[stats]{nls}} object containing the fit.
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
#' fit_growth_linear(mydata, Time, OD600)}
#'
fit_growth_linear <- function(df, time, data, ...) {
    fit_growth_linear_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_linear
#' @inheritParams fit_growth_
#' @export
#' @examples
#' \dontrun{
#' fit_growth_linear_(mydata, "Time", "OD600")
#' }
fit_growth_linear_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)

    lmodel <- stats::lm(growth_data ~ time_data, data = df, ...)
    yvals <- as.numeric(stats::predict(lmodel))

    growthcurve(
        type = "linear",
        model = lmodel,
        fit = list(x = time_data, y = yvals),
        f = function(x) (stats::coefficients(lmodel)[[2]] * x) + stats::coefficients(lmodel)[[1]],
        parameters = list(
            asymptote = max(yvals),
            max_rate = list(
                time = min(time_data),
                value = min(growth_data),
                rate = lmodel$coefficients[[2]]
            ),
            integral = calculate_auc(time_data, stats::predict(lmodel))
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
