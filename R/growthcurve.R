#' @title Create \code{growthcurve} Objects
#' @description \code{growthcurve} TODO
#' @param type TODO
#' @param model TODO
#' @param f TODO
#' @param parameters TODO
#' @param df TODO
#' @param time_col TODO
#' @param data_col TODO
#'
#' @return TODO
#' @export
#' 
growthcurve <- function(type, model, f, parameters, df, time_col, data_col) {
    structure(list(
        type = type,
        model = model,
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
