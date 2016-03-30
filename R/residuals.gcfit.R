#' Get model residuals from fits
#' 
#' residuals gives the residuals, or the difference between the observed growth
#' data and the fitted values, for a given fit.
#'
#' @param object A fit for some growth data
#' @param ... Other arguments (not used)
#'
#' @return A numeric list containing the residuals
#' @note The same information is available as \code{object$residuals}.
#' @export
#'
#' @examples
#' \dontrun{
#' # Get a logistic fit for some data and extract its residuals
#' lfit <- fit_growth_logistic(df=mydata, Time, OD600)
#' residuals(lfit)}
#' 
residuals.gcfit <- function(object, ...) {
    object$residuals
}
