#' @title Create \code{growthcurve} Objects
#' @description \code{growthcurve} creates \code{growthcurve} objects, which
#' contain information about a function fitted to biological growth data
#' @param type A string describing the fit (e.g., "logistic")
#' @param model A model object, such as a \code{nls} or \code{smooth.spline}
#' @param fit A list containing \code{x} and \code{y} values for the fit
#' @param f A function \code{f(x)} that maps a time value \code{x} to a growth
#' value using the model
#' @param parameters A list containing growth parameters (e.g., asymptote) calculated by the specific model
#' @param df A data frame containing the raw growth data
#' @param time_col A string with the name of the column containing time data
#' @param data_col A string with the name of the column containing the growth
#' data
#'
#' @return A \code{growthcurve} object
#' @export
#' 
growthcurve <- function(type, model, fit, f, parameters, df, time_col,
                        data_col) {
    structure(list(
        type = type,
        model = model,
        fit = fit,
        f = f,
        parameters = parameters,
        data = list(
            df = df,
            time_col = time_col,
            data_col = data_col
        )
    ),
    class = "growthcurve")
}


#' @description \code{is.growthcurve} determines whether or not the given object
#' is a growthcurve
#' @param x A potential \code{growthcurve} object
#' @return \code{is.growthcurve} returns a logical value indicating whether
#' \code{x} is a \code{growthcurve} object (\code{TRUE}) or not (\code{FALSE}).
#' @rdname growthcurve
#' @export
is.growthcurve <- function(x) inherits(x, "growthcurve")
