#' Tidy a Fitted Growth Curve into a Summary data.frame
#' 
#' \code{tidy.growthcurve} provides a summary data frame for a growth
#' curve that is compatible with- and follows the naming conventions of
#' \code{\link[broom]{broom-package}}.
#'
#' @param x A fit for some growth data (a \code{growthcurve} object)
#' @param ... Additional arguments (not used)
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
tidy.growthcurve <- function(x, ...) {
    stop_without_package("broom")

    # For now, just wrap broom's tidy for nls
    info <- broom::tidy(x$model)

    # TODO: rename terms. Note that this will depend on the type of model used!
    info[info$term == "Asym", "term"] <- "Asymptote"
    info
}
