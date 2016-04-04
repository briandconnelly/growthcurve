#' Tidy a fitted growth curve into a summary data.frame
#' 
#' \code{tidy.gcfit} is intended to provide a summary data frame for a growth
#' curve that is compatible with- and follows the naming conventions of
#' \code{\link{broom}}.
#'
#' @importFrom broom tidy
#' @param x A fit for some growth data
#' @param ... 
#'
#' @return A data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' myfit <- fit_growth_gompertz(mydata, Time, OD600)
#' tidy(myfit)}
#'
tidy.gcfit <- function(x, ...) {
    # For now, we can just bootstrap this using broom's tidy for nls
    tidy(x$grofit$nls)
}

#' @export
"tidy"
