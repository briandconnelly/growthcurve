#' Augment Growth Data According to a Tidied Model
#' 
#' Add columns to the growth data set such as predictions and residuals.
#' Currently, this just wraps the \code{augment} function for the type of model
#' used, so models fit with \code{\link{fit_growth_logistic}} will differ from
#' \code{\link{fit_growth_linear}}, \code{\link{fit_growth_loess}}, etc.
#'
#' @note This function requires the \pkg{broom} package.
#'
#' @inheritParams tidy.growthcurve 
#' @return an expanded data frame
#' @export
#'
#' @examples
#' \dontrun{
#' myfit <- fit_growth_gompertz(mydata, Time, OD600)
#' augment(myfit)}
#' 
augment.growthcurve <- function(x, ...) {
    stop_without_package("broom")
    broom::augment(x$model)
}
