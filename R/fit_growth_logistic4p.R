#' Fit a 4-Parameter Logistic Curve to Growth Data
#' 
#' \code{fit_growth_logistic4p} fits a four-parameter logistic curve to a tidy
#' growth data set using nonlinear least squares
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments to \code{\link{nls}}
#'
#' @seealso \url{https://en.wikipedia.org/wiki/Logistic_function}
#' @return A \code{\link{growthcurve}} object with the following fields:
#' \itemize{
#'     \item \code{type}: The type of fit (here "logistic4p")
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
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
#' @examples
#' \dontrun{
#' fit_growth_logistic4p_(mydata, "Time", "OD600")
#' }
fit_growth_logistic4p_ <- function(df, time_col, data_col, ...) {
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)
    
    nlsmodel <- nls(growth_data ~ SSfpl(time_data, A, B, xmid, scal), df, ...)
    
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
            integral = calculate_auc(time_data, predict(nlsmodel))
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
}
