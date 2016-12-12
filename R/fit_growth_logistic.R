#' Fit a Logistic Curve to Growth Data
#' 
#' \code{fit_growth_logistic} fits a logistic curve to a tidy growth data set
#' using nonlinear least squares
#'
#' @inheritParams fit_growth
#' @param ... Additional arguments to \code{\link[stats]{nls}}
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Logistic_function}
#' @return A \code{\link{growthcurve}} object
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_logistic(mydata, Time, OD600)}
#'
fit_growth_logistic <- function(df, time, data, ...) {
    fit_growth_logistic_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_logistic
#' @inheritParams fit_growth_
#' @importFrom stats coef D
#' @export
#' @examples
#' \dontrun{
#' fit_growth_logistic_(mydata, "Time", "OD600")
#' }
fit_growth_logistic_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)

    nlsmodel <- stats::nls(growth_data ~ SSlogis(time_data, Asym, xmid, scal), df, ...)

    expr_logis <- expression(Asym / (1 + exp((xmid - input) / scal)))

    # calculate growth values for a given time point according to the model
    yval <- function(x) {
        eval_env(
            expr_logis,
            Asym = coef(nlsmodel)[["Asym"]],
            xmid = coef(nlsmodel)[["xmid"]],
            scal = coef(nlsmodel)[["scal"]],
            input = x
        )
    }

    growthcurve(
        type = "logistic",
        model = nlsmodel,
        fit = list(x = time_data, y = stats::predict(nlsmodel)),
        f = yval,
        parameters = list(
            asymptote = coef(nlsmodel)[["Asym"]],
            max_rate = list(
                time = coef(nlsmodel)[["xmid"]],
                value = yval(coef(nlsmodel)[["xmid"]]),
                rate = eval_env(
                    D(expr = expr_logis, name = "input"),
                    Asym = coef(nlsmodel)[["Asym"]],
                    xmid = coef(nlsmodel)[["xmid"]],
                    scal = coef(nlsmodel)[["scal"]],
                    input = coef(nlsmodel)[["xmid"]]
                )
            ),
            integral = calculate_auc(time_data, stats::predict(nlsmodel))
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
