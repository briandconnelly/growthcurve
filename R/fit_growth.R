#' Fit a growth curve to the given data
#' 
#' \code{fit_growth} fits a growth curve using either a parametric model or 
#' splines.
#'
#' @param df a data frame
#' @param time column in \code{df} that contains time data
#' @param data column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param model name of the model to fit. One of:
#' \itemize{
#'     \item \code{logistic}: TODO (default)
#'     \item \code{logistic4p}: TODO
#'     \item \code{gompertz}: TODO
#'     \item \code{loess}: TODO
#'     \item \code{linear}: TODO
#'     \item \code{spline}: TODO
#'     \item \code{TODO}: TODO
#' }
#' @param ... Additional arguments for the specific model function
#'
#' @return TODO
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth(mydata, Time, OD600, model = "logistic")}
#'
fit_growth <- function(df, time, data, model = "logistic", ...) {
    fit_growth_(
        df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        model = model,
        ...
    )
}


#' @rdname fit_growth
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
fit_growth_ <- function(df, time_col, data_col, model = "logistic", ...) {
    fns <- list(
        "logistic" = fit_growth_logistic_,
        "logistic4p" = fit_growth_logistic4p_,
        "gompertz" = fit_growth_gompertz_,
        "loess" = fit_growth_loess_,
        "linear" = fit_growth_linear_,
        "spline" = fit_growth_spline_,
        "grofit_logistic" = fit_growth_grofit_logistic_,
        "grofit_gompertz" = fit_growth_grofit_gompertz_,
        "grofit_gompertz.exp" = fit_growth_grofit_gompertz.exp_,
        "grofit_richards" = fit_growth_grofit_richards_,
        "grofit_parametric" = fit_growth_grofit_parametric_,
        "grofit_spline" = fit_growth_grofit_spline_
    )

    model_clean <- tolower(model)

    if (!model_clean %in% names(fns)) {
        msg <- sprintf("'%s' is not a valid model. Supported models include: %s", model, paste0(names(fns), collapse = ", "))
        stop(msg, call. = FALSE)
    }

    fns[[model_clean]](df = df, time_col = time_col, data_col = data_col, ...)
}
