#' Fit a Curve to Growth Data using LOESS
#' 
#' \code{fit_growth_loess} fits curve to a tidy growth data set using LOESS
#'
#' @inheritParams fit_growth
#' @param ... Additional arguments to \code{\link[stats]{loess}}
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Local_regression}
#' @return A \code{\link{growthcurve}} object
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
#' @inheritParams fit_growth_
#' @export
#' @examples
#' \dontrun{
#' fit_growth_loess_(mydata, "Time", "OD600")
#' }
fit_growth_loess_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)

    if (any(is.na(time_data))) stop("NAs in time data")
    if (any(is.na(growth_data))) stop("NAs in growth data")

    lmodel <- stats::loess(growth_data ~ time_data, data = df, ...)

    lmodel_y <- stats::predict(lmodel)
    lmodel_dydt <- diff(lmodel_y) / diff(time_data)
    i_max_rate <- which.max(lmodel_dydt)

    growthcurve(
        type = "loess",
        model = lmodel,
        fit = list(
            x = time_data,
            y = lmodel_y,
            residuals = as.numeric(stats::residuals(lmodel))
        ),
        f = NULL,
        parameters = list(
            asymptote = max(lmodel_y),
            max_rate = list(
                time = time_data[i_max_rate],
                value = lmodel_y[i_max_rate],
                rate = lmodel_dydt[i_max_rate]
            ),
            augc = calculate_augc(time_data, stats::predict(lmodel))
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
