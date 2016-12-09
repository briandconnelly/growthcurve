#' Fit a Parametric Model to Growth Data (using grofit)
#' 
#' \code{fit_growth_grofit_parametric} allows you to fit a parametric model to a
#' tidy growth data set using \code{\link[grofit]{gcFitModel}} from the
#' \pkg{grofit} package. Several candidate models are fitted, and the model with
#' the best AIC is returned.
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments for \code{\link{gcFitModel}}
#' @return A \code{growthcurve} object with the following fields:
#' \itemize{
#'     \item \code{type}: String describing the type of fit
#'     \item \code{parameters}: Growth parameters from the fitted model. A list
#'     with fields:
#'     \itemize{
#'         \item{TODO}: TODO
#'     }
#'     \item \code{model}: An \code{\link{nls}} object containing the fit.
#'     \item \code{data}: A list containing the input data frame (\code{df}),
#'       the name of the column containing times (\code{time_col}), and the
#'       name of the column containing growth values (\code{data_col}).
#'     \item \code{grofit}: An object of class \code{gcFitModel}
#' }
#' 
#' @seealso For specific parametric models, see \code{\link{fit_growth_grofit_logistic}}, \code{\link{fit_growth_grofit_gompertz}}, \code{\link{fit_growth_grofit_gompertz.exp}}, \code{\link{fit_growth_grofit_richards}}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_grofit_parametric(mydata, Time, OD600)}
#'
fit_growth_grofit_parametric <- function(df, time, data, ...) {
    fit_growth_grofit_parametric_(
        df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @export
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @rdname fit_growth_grofit_parametric
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_grofit_parametric_(mydata, time_col = "Time", data_col = "OD600")}
#'
fit_growth_grofit_parametric_ <- function(df, time_col, data_col, ...) {
    stop_without_package("grofit")
    
    growth_data <- lazyeval::lazy_eval(data_col, df)
    time_data <- lazyeval::lazy_eval(time_col, df)

    ignoreme <- capture.output(
        gres <- grofit::gcFitModel(time = time_data, data = growth_data, ...)
    )

    fit_dydt <- diff(gres$fit.data) / diff(gres$fit.time)
    i_max_rate <- which.max(fit_dydt)

    yvals <- function(x) {
        # TODO: use a switch statement.
        if (identical(gres$model, "logistic")) f <- grofit::logistic
        else if (identical(gres$model, "gompertz")) f <- grofit::gompertz
        else if (identical(gres$model, "gompertz.exp")) f <- grofit::gompertz.exp

        
        # These grofit functions seem to be invisible, so storing value and
        # returning that makes it un-invisible.
        y <- f(
            time = x,
            A = gres$parameters$A[[1]],
            mu = gres$parameters$mu[[1]],
            lambda = gres$parameters$lambda[[1]]
        )
        y
    } 
    
    result <- growthcurve(
        type = paste0(c("grofit", gres$model), collapse = "_"),
        model = gres$nls,
        fit = list(x = gres$fit.time, y = gres$fit.data),
        f = yvals,
        parameters = list(
            asymptote = gres$parameters$A[[1]],
            max_rate = list(
                time = gres$fit.time[i_max_rate],
                value = gres$fit.data[i_max_rate],
                rate = gres$parameters$mu[[1]],
                lambda = gres$parameters$lambda[[1]]
            ),
            integral = gres$parameters$integral
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
    result$grofit <- gres
    result
}
