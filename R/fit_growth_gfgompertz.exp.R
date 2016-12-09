#' Fit a Modified Gompertz Growth Curve to Growth Data (using grofit)
#' 
#' \code{fit_growth_gfgompertz.exp} fits a modified Gompertz curve to a tidy
#' data set using \code{\link[grofit]{gcFitModel}} from the \pkg{grofit}
#' package.
#'
#' @inheritParams fit_growth_grofit_parametric
#' @return A \code{growthcurve} object with the following fields:
#' \itemize{
#'     \item \code{type}: String describing the type of fit (here, "grofit/gompertz.exp")
#'     \item \code{parameters}: Growtn parameters from the fitted model. A list
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
#' @seealso \code{\link{fit_growth_gompertz}}, growthcurve's native function
#' for fitting Gompertz curves
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfgompertz(mydata, Time, OD600)}
fit_growth_gfgompertz.exp <- function(df, time, data, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "gompertz.exp",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric(df, time = time, data = data, control = ctl, ...)
}


#' @rdname fit_growth_gfgompertz.exp
#' @inheritParams fit_growth_grofit_parametric_
#' @export
fit_growth_gfgompertz.exp_ <- function(df, time_col, data_col, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "gompertz.exp",
                                  suppress.messages = TRUE)
    fit_growth_grofit_parametric_(df = df, time_col = time_col, data_col = data_col,
                                  control = ctl, ...)
}
