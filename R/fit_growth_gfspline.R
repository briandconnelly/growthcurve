#' Fit Smooth Splines to Growth Data (Using grofit)
#' 
#' \code{fit_growth_gfspline} fits a smooth spline to a tidy growth data set
#' using \code{\link[grofit]{gcFitSpline}} from the \pkg{grofit} package.
#' 
#' @inheritParams fit_growth_gfparametric
#' @param ... Additional arguments for \code{\link[grofit]{gcFitSpline}}
#'
#' @return A \code{growthcurve} object with the following fields:
#' \itemize{
#'     \item \code{type}: String describing the type of fit (here, "grofit/spline")
#'     \item \code{parameters}: Parameters for the fitted model. A list with
#'     fields:
#'     \itemize{
#'         \item{TODO}: TODO
#'     }
#'     \item \code{model}: An \code{\link{smooth.spline}} object containing the fit.
#'     \item \code{data}: A list containing the input data frame (\code{df}),
#'       the name of the column containing times (\code{time_col}), and the
#'       name of the column containing growth values (\code{data_col}).
#'     \item \code{grofit}: An object of class \code{gcFitSpline}
#' }
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfspline(mydata, Time, OD600)}
#'
fit_growth_gfspline <- function(df, time, data, ...) {
    fit_growth_gfspline_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @inheritParams fit_growth_gfparametric_
#' @export
#' @importFrom grofit gcFitSpline
#' @rdname fit_growth_gfspline
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' fit_growth_gfspline_(df=mydata, time_col = "Time", data_col = "OD600")}
#'
fit_growth_gfspline_ <- function(df, time_col, data_col, ...) {

    ignoreme <- capture.output(
        gres <- gcFitSpline(
            time = lazyeval::lazy_eval(time_col, df),
            data = lazyeval::lazy_eval(data_col, df),
            ...
        )
    )

    result <- structure(list(type = paste0(c("grofit", "spline"), collapse="/"),
                             parameters = list(), #TODO
                             model = gres$spline,
                             data = list(df = df,
                                         time_col = as.character(time_col)[1],
                                         data_col = as.character(data_col)[1]),
                             grofit = gres),
                        class = "growthcurve")
    
    result
}
