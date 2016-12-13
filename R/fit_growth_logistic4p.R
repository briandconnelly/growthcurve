#' Fit a 4-Parameter Logistic Curve to Growth Data
#' 
#' \code{fit_growth_logistic4p} fits a four-parameter logistic curve to a tidy
#' growth data set using nonlinear least squares
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
#' fit_growth_logistic4p(mydata, Time, OD600)}
#'
fit_growth_logistic4p <- function(df, time, data, ...) {
    fit_growth_logistic4p_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_logistic4p
#' @inheritParams fit_growth_
#' @importFrom stats coef D
#' @export
#' @examples
#' \dontrun{
#' fit_growth_logistic4p_(mydata, "Time", "OD600")
#' }
fit_growth_logistic4p_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)

    nlsmodel <- stats::nls(
        growth_data ~ SSfpl(time_data, A, B, xmid, scal),
        df,
        ...
    )

    expr_logis4p <- expression(A + (B - A) / (1 + exp((xmid - input) / scal)))

    # calculate growth values for a given time point according to the model
    yval <- function(x) {
        eval_env(
            expr_logis4p,
            A = coef(nlsmodel)[["A"]],
            B = coef(nlsmodel)[["B"]],
            xmid = coef(nlsmodel)[["xmid"]],
            scal = coef(nlsmodel)[["scal"]],
            input = x
        )
    }

    growthcurve(
        type = "logistic4p",
        model = nlsmodel,
        fit = list(
            x = time_data,
            y = stats::predict(nlsmodel),
            residuals = stats::residuals(nlsmodel)
        ),
        f = yval,
        parameters = list(
            asymptote = coef(nlsmodel)[["B"]],
            lower_asymptote = coef(nlsmodel)[["A"]],
            max_rate = list(
                time = coef(nlsmodel)[["xmid"]],
                value = yval(coef(nlsmodel)[["xmid"]]),
                rate = eval_env(
                    D(expr = expr_logis4p, name = "input"),
                    A = coef(nlsmodel)[["A"]],
                    B = coef(nlsmodel)[["B"]],
                    xmid = coef(nlsmodel)[["xmid"]],
                    scal = coef(nlsmodel)[["scal"]],
                    input = coef(nlsmodel)[["xmid"]]
                )
            ),
            augc = calculate_augc(time_data, stats::predict(nlsmodel))
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
