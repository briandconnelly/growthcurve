#' Fit a Parametric Model to Growth Data (using grofit)
#' 
#' \code{fit_growth_grofit_parametric} allows you to fit a parametric model to a
#' tidy growth data set using \code{\link[grofit]{gcFitModel}} from the
#' \pkg{grofit} package. Several candidate models are fitted, and the model with
#' the best AIC is returned.
#'
#' @inheritParams fit_growth
#' @param ... Additional arguments for \code{\link[grofit]{gcFitModel}}
#' @return A \code{\link{growthcurve}} object
#' 
#' @export
#'
#' @seealso \link{grofit_wrappers}
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


# Helper function that fits the model type specified by 'type'
fit_growth_grofit_ptype <- function(df, time, data, type, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = type, suppress.messages = TRUE)
    fit_growth_grofit_parametric(df, time = time, data = data, control = ctl,
                                 ...)
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_logistic <- function(df, time, data, ...) {
    fit_growth_grofit_ptype(
        df = df,
        time = time,
        data = data,
        type = "logistic",
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_gompertz <- function(df, time, data, ...) {
    fit_growth_grofit_ptype(
        df = df,
        time = time,
        data = data,
        type = "gompertz",
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_gompertz.exp <- function(df, time, data, ...) {
    fit_growth_grofit_ptype(
        df = df,
        time = time,
        data = data,
        type = "gompertz.exp",
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_richards <- function(df, time, data, ...) {
    fit_growth_grofit_ptype(
        df = df,
        time = time,
        data = data,
        type = "richards",
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

    if (any(is.na(time_data))) stop("NAs in time data")
    if (any(is.na(growth_data))) stop("NAs in growth data")

    tryCatch(gres <- grofit::gcFitModel(time = time_data,
                                        data = growth_data,
                                        ...),
             warning = function(w) stop(w))
    
    fit_dydt <- diff(gres$fit.data) / diff(gres$fit.time)
    i_max_rate <- which.max(fit_dydt)

    yvals <- function(x = time_data) {
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
        fit = list(
            x = gres$fit.time,
            y = gres$fit.data,
            residuals = stats::residuals(gres$nls)
        ),
        f = yvals,
        parameters = list(
            asymptote = gres$parameters$A[[1]],
            max_rate = list(
                time = gres$fit.time[i_max_rate],
                value = gres$fit.data[i_max_rate],
                rate = gres$parameters$mu[[1]],
                lambda = gres$parameters$lambda[[1]]
            ),
            augc = gres$parameters$integral
        ),
        df = df,
        time_col = as.character(time_col)[1],
        data_col = as.character(data_col)[1]
    )
    result$grofit <- gres
    class(result) <- c(class(result), "grofit")
    result
}


# Helper function that fits the model type specified by 'type'
fit_growth_grofit_ptype_ <- function(df, time_col, data_col, type, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = type, suppress.messages = TRUE)
    fit_growth_grofit_parametric_(df = df, time_col = time_col,
                                  data_col = data_col, control = ctl, ...)
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_logistic_ <- function(df, time_col, data_col, ...) {
    fit_growth_grofit_ptype_(
        df = df,
        time_col = time_col,
        data_col = data_col,
        type = "logistic",
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_gompertz_ <- function(df, time_col, data_col, ...) {
    fit_growth_grofit_ptype_(
        df = df,
        time_col = time_col,
        data_col = data_col,
        type = "gompertz",
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_gompertz.exp_ <- function(df, time_col, data_col, ...) {
    fit_growth_grofit_ptype_(
        df = df,
        time_col = time_col,
        data_col = data_col,
        type = "gompertz.exp",
        ...
    )
}


#' @rdname fit_growth_grofit_parametric
#' @export
fit_growth_grofit_richards_ <- function(df, time_col, data_col, ...) {
    fit_growth_grofit_ptype_(
        df = df,
        time_col = time_col,
        data_col = data_col,
        type = "richards",
        ...
    )
}
