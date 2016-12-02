#' Fit a Parametric Model to Growth Data (using grofit)
#' 
#' \code{fit_growth_gfparametric} allows you to fit a parametric model to a
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
#' @seealso For specific parametric models, see \code{\link{fit_growth_gflogistic}}, \code{\link{fit_growth_gfgompertz}}, \code{\link{fit_growth_gfgompertz.exp}}, \code{\link{fit_growth_richards}}
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfparametric(mydata, Time, OD600)}
#'
fit_growth_gfparametric <- function(df, time, data, ...) {
    fit_growth_gfparametric_(df, time_col = lazyeval::lazy(time), data_col = lazyeval::lazy(data),
                             ...)
}


#' @export
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @rdname fit_growth_gfparametric
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfparametric_(mydata, time_col = "Time", data_col = "OD600")}
#'
fit_growth_gfparametric_ <- function(df, time_col, data_col, ...) {
    stop_without_package("grofit")

    ignoreme <- capture.output(
        gres <- grofit::gcFitModel(time = lazyeval::lazy_eval(time_col, df),
                                   data = lazyeval::lazy_eval(data_col, df), ...)
    )
    
    result <- structure(list(type = paste0(c("grofit", gres$model),
                                           collapse="/"),
                             parameters = list(), #TODO
                             model = gres$nls,
                             data = list(df = df,
                                         time_col = as.character(time_col)[1],
                                         data_col = as.character(data_col)[1]),
                             grofit = gres),
                        class = "growthcurve")
    
    result
}
