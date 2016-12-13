#' Get Model Residuals from Growth Curve Fits
#' 
#' residuals gives the residuals, or the difference between the observed growth
#' data and the fitted values, for a given fit.
#'
#' @param object A fit for some growth data (a \code{growthcurve} object)
#' @param ... Additional arguments (not used)
#'
#' @return A numeric list containing the fit's residuals
#' @export
#'
#' @examples
#' \dontrun{
#' # Get a logistic fit for some data and extract its residuals
#' lfit <- fit_growth_logistic(mydata, Time, OD600)
#' residuals(lfit)}
#' 
residuals.growthcurve <- function(object, ...) {
    object$fit$residuals
}
