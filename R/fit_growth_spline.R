#' Fit Smooth Splines to Growth Data
#' 
#' \code{fit_growth_spline} fits a smooth spline to a tidy growth data set
#'
#' @param df A data frame
#' @param time Name of the column in \code{df} that contains time data
#' @param data Name of the column in \code{df} that contains growth data
#' (default: \code{TRUE})
#' @param ... Additional arguments to \link{\code{smooth.spline}}
#' 
#' @return A \code{growthcurve} object with the following fields:
#' \itemize{
#'     \item \code{type}: The type of fit (here "spline")
#'     \item \code{parameters}: Growth parameters from the fitted model. A list
#'     with fields:
#'     \itemize{
#'         \item{TODO}: TODO
#'     }
#'     \item \code{model}: An \code{\link{smooth.spline}} object containing the "fit".
#'     \item \code{data}: A list containing the input data frame (\code{df}),
#'       the name of the column containing times (\code{time_col}), and the
#'       name of the column containing growth values (\code{data_col}).
#' }
#' @export
#'
#' @examples
#' \dontrun{
#' fit_growth_spline(mydata, Time, OD600)}
#'
fit_growth_spline <- function(df, time, data, ...) {
    fit_growth_spline_(
        df = df,
        time_col = lazyeval::lazy(time),
        data_col = lazyeval::lazy(data),
        ...
    )
}


#' @rdname fit_growth_spline
#' @param time_col String giving the name of the column in \code{df} that
#' contains time data
#' @param data_col String giving the name of the column in \code{df} that
#' contains growth data
#' @export
#' @examples
#' \dontrun{
#' fit_growth_spline_(mydata, "Time", "OD600")}
#'
fit_growth_spline_ <- function(df, time_col, data_col, ...) {

    smodel <- smooth.spline(
        x = lazyeval::lazy_eval(data_col, df),
        y = lazyeval::lazy_eval(time_col, df),
        ...
    )

    # TODO get parameters
        
    result <- structure(list(type = "spline",
                             parameters = list(),
                             model = smodel,
                             data = list(df = df,
                                         time_col = as.character(time_col)[1],
                                         data_col = as.character(data_col)[1])),
                        class = "growthcurve")
    
    result
}
