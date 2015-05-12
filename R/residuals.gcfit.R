#' Get model residuals from fits
#' 
#' residuals gives the residuals, or the difference between the observed growth
#' data and the fitted values, for a given fit.
#'
#' @param object A fit for some growth data
#'
#' @return A numeric list containing the residuals
#' @importFrom methods S3Class
#' @export
#'
#' @examples
#' \dontrun{
#' # Get a logistic fit for some data and extract its residuals
#' lfit <- fit_growth_logistic(df=mydata, Time, OD600)
#' residuals(lfit)}
#' 
residuals.gcfit <- function(object)
{
    if('gcFitSpline' %in% S3Class(object))
    {
        resid <- residuals(sfit$spline)
    }
    else
    {
        resid <- object$raw.data - object$fit.data
    }
    
    resid
}
