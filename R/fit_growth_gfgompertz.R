#' Fit a Gompertz Growth Curve to Growth Data (using grofit)
#' 
#' \code{fit_growth_gfgompertz} fits a Gompertz curve to a tidy data set using
#' \code{\link[grofit]{gcFitModel}} from the \pkg{grofit} package.
#'
#' @inheritParams fit_growth_gfparametric
#' @return A \code{growthcurve} object with the following fields:
#' \itemize{
#'     \item \code{type}: String describing the type of fit (here, "grofit/gompertz")
#'     \item \code{parameters}: Growth parameters for the fitted model. A list
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
#' @seealso \url{https://en.wikipedia.org/wiki/Gompertz_function}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfgompertz(mydata, Time, OD600)}
fit_growth_gfgompertz <- function(df, time, data, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "gompertz",
                                  suppress.messages = TRUE)
    fit_growth_gfparametric(df, time = time, data = data, control = ctl, ...)
}

#' @export
#' @inheritParams fit_growth_gfparametric_
#' @rdname fit_growth_gfgompertz
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfgompertz_(df=mydata, time_col='Time', data_col='OD600')}
#'
fit_growth_gfgompertz_ <- function(df, time_col, data_col, ...) {
    stop_without_package("grofit")
    ctl <- grofit::grofit.control(model.type = "gompertz",
                                  suppress.messages = TRUE)
    fit_growth_gfparametric_(df = df, time_col = time_col, data_col = data_col,
                             control = ctl, ...)
}
