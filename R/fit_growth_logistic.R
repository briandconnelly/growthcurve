#' Fit a Logistic Curve to Growth Data
#' 
#' \code{fit_growth_logistic} fits a logistic curve to a tidy growth data set
#' using nonlinear least squares
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments to \code{\link{nls}}
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Logistic_function}
#' @return A \code{growthcurve} object with the following fields:
#' \itemize{
#'     \item \code{type}: The type of fit (here "logistic")
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
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
#' @examples
#' \dontrun{
#' fit_growth_logistic_(mydata, "Time", "OD600")
#' }
fit_growth_logistic_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)

    nlsmodel <- nls(growth_data ~ SSlogis(time_data, Asym, xmid, scal), df, ...)

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

    result <- structure(
        list(
            type = "logistic",
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
                integral = calculate_auc(time_data, predict(nlsmodel))
            ),
            model = nlsmodel,
            data = list(
                df = df,
                time_col = as.character(time_col)[1],
                data_col = as.character(data_col)[1]
            )
        ),
        class = "growthcurve"
    )

    result
}
