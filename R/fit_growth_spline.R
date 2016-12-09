#' Fit Smooth Splines to Growth Data
#' 
#' \code{fit_growth_spline} fits a smooth spline to a tidy growth data set
#'
#' @inheritParams fit_growth
#' @param ... Additional arguments to \code{\link{smooth.spline}}
#' 
#' @return A \code{growthcurve} object with the following fields:
#' \itemize{
#'     \item \code{type}: The type of fit (here "spline")
#'     \item \code{parameters}: Growth parameters from the fitted model. A list
#'     with fields:
#'     \itemize{
#'         \item{TODO}: TODO
#'     }
#'     \item \code{model}: An \code{\link{smooth.spline}} object containing the "fit".
#'     \item \code{data}: A list containing the input data frame (\code{df}),
#'       the name of the column containing times (\code{time_col}), and the
#'       name of the column containing growth values (\code{data_col}).
#' }
#' @export
#'
#' @examples
#' \dontrun{
#' fit_growth_spline(mydata, Time, OD600)}
#'
fit_growth_spline <- function(df, time, data, ...) {
    fit_growth_spline_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_spline
#' @inheritParams fit_growth_
#' @export
#' @examples
#' \dontrun{
#' fit_growth_spline_(mydata, "Time", "OD600")}
#'
fit_growth_spline_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)

    smodel <- smooth.spline(x = time_data, y = growth_data, ...)
    psmodel <- predict(smodel)

    smodel_dydt <- predict(smodel, deriv = 1)
    i_max_rate <- which.max(smodel_dydt$y)

    growthcurve(
        type = "spline",
        model = smodel,
        fit = list(x = psmodel$x, y = psmodel$y),
        f = function(x) predict(smodel, x)$y,
        # Note: parameters max_rate_time and integral will differ from grofit,
        #       which uses a lowess fit for the former and integrate() for the
        #       latter
        parameters = list(
            asymptote = max(smodel$y),
            asymptote_lower = min(smodel$y),
            max_rate = list(
                time = smodel_dydt$x[i_max_rate],
                value = smodel$y[i_max_rate],
                rate = smodel_dydt$y[i_max_rate]
            ),
            integral = calculate_auc(x = psmodel$x, y = psmodel$y)
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
