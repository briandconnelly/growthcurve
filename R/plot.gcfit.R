#' Plot growth data and its fitted growth curve
#'
#' @param object A fit for some growth data
#' @param ... Optional arguments to plot. Note that \pkg{grofit} does not pass these along to the base graphics, so they're mostly useless at the moment.
#'
#' @importFrom grofit plot.gcFitSpline
#' @importFrom grofit plot.gcFitModel
#' @export
#'
#' @examples
#' \dontrun{
#' # Get a logistic fit for some data and extract its residuals
#' lfit <- fit_growth_logistic(df=mydata, Time, OD600)
#' plot(lfit)}
#' 
plot.gcfit <- function(object, ...)
{
    if('gcFitSpline' %in% S3Class(object)) plot.gcFitSpline(object, ...)    
    else if('gcFitModel' %in% S3Class(object)) plot.gcFitModel(object, ...)
    else warning("I don't know how to plot this.")
}
