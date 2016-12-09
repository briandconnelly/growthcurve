#' Fit a Parametric Model to Growth Data (using grofit)
#' 
#' \code{fit_growth_grofit_parametric} allows you to fit a parametric model to a
#' tidy growth data set using \code{\link[grofit]{gcFitModel}} from the
#' \pkg{grofit} package. Several candidate models are fitted, and the model with
#' the best AIC is returned.
#'
#' @inheritParams fit_growth
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
#' @inheritParams fit_growth_
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
        f <- switch(gres$model,
                    logistic = grofit::logistic,
                    gompertz = grofit::gompertz,
                    gompertz.exp = grofit::gompertz.exp,
                    richards = grofit::richards)

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


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_logistic <- function(df, time, data, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "logistic",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric(df, time = time, data = data, control = ctl,
                                 ...)
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_logistic_ <- function(df, time_col, data_col, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "logistic",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric_(df = df, time_col = time_col,
                                  data_col = data_col, control = ctl, ...)
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_gompertz <- function(df, time, data, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "gompertz",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric(df, time = time, data = data, control = ctl, ...)
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_gompertz_ <- function(df, time_col, data_col, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "gompertz",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric_(df = df, time_col = time_col, data_col = data_col,
                                  control = ctl, ...)
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_gompertz.exp <- function(df, time, data, ...) {
    stop_without_package("grofit")
    
    ctl <- grofit::grofit.control(model.type = "gompertz.exp",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric(
        df = df,
        time = time,
        data = data,
        control = ctl,
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_gompertz.exp_ <- function(df, time_col, data_col, ...) {
    stop_without_package("grofit")
    
    ctl <- grofit::grofit.control(model.type = "gompertz.exp",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric_(
        df = df,
        time_col = time_col,
        data_col = data_col,
        control = ctl,
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_richards <- function(df, time, data, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "richards",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric(
        df = df,
        time = time,
        data = data,
        control = ctl,
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_richards_ <- function(df, time_col, data_col, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "richards",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric_(
        df = df,
        time_col = time_col,
        data_col = data_col,
        control = ctl,
        ...
    )
}
