#' Fit a Gompertz Curve to Growth Data
#' 
#' \code{fit_growth_gompertz} fits a Gompertz curve to a tidy growth data set
#' using nonlinear least squares
#'
#' @inheritParams fit_growth
#' @param ... Additional arguments to \code{\link[stats]{nls}}
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Gompertz_function}
#' @return A \code{\link{growthcurve}} object
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gompertz(mydata, Time, OD600)}
#'
fit_growth_gompertz <- function(df, time, data, ...) {
    fit_growth_gompertz_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_gompertz
#' @inheritParams fit_growth_
#' @importFrom stats coef D
#' @export
#' @examples
#' \dontrun{
#' fit_growth_gompertz_(mydata, "Time", "OD600")
#' }
fit_growth_gompertz_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)

    nlsmodel <- stats::nls(
        growth_data ~ SSgompertz(time_data, Asym, b2, b3),
        ...
    )

    expr_gompertz <- expression(Asym * exp(-b2 * b3 ^ x))
    yval <- function(x = time_data) {
        eval_env(
            expr_gompertz,
            Asym = coef(nlsmodel)[["Asym"]],
            b2 = coef(nlsmodel)[["b2"]],
            b3 = coef(nlsmodel)[["b3"]],
            x = x
        )
    }

    # Find the time of maximum growth using the second derivative
    fgompertzd2 <- function(x, Asym, b2, b3) -(Asym * (exp(-b2 * b3^x) * (b2 * (b3^x * log(b3) * log(b3))) - exp(-b2 * b3^x) * (b2 * (b3^x * log(b3))) * (b2 * (b3^x * log(b3)))))
    max_rate_time <- stats::uniroot(
        f = fgompertzd2,
        interval = range(time_data),
        Asym = coef(nlsmodel)[["Asym"]],
        b2 = coef(nlsmodel)[["b2"]],
        b3 = coef(nlsmodel)[["b3"]]
    )$root

    growthcurve(
        type = "gompertz",
        model = nlsmodel,
        fit = list(
            x = time_data,
            y = stats::predict(nlsmodel),
            residuals = stats::residuals(nlsmodel)
        ),
        f = yval,
        parameters = list(
            asymptote = coef(nlsmodel)[["Asym"]],
            max_rate = list(
                time = max_rate_time,
                value = yval(max_rate_time),
                rate = eval_env(
                    D(expr = expr_gompertz, name = "x"),
                    Asym = coef(nlsmodel)[["Asym"]],
                    b2 = coef(nlsmodel)[["b2"]],
                    b3 = coef(nlsmodel)[["b3"]],
                    x = max_rate_time
                )
            ),
            augc = calculate_augc(time_data,
                                     stats::predict(nlsmodel))
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
