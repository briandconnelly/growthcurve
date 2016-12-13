#' Predict method for Growth Curves
#'
#' @param object Object of class inheriting from "growthcurve"
#' @param newdata An optional vector of values with which to predict. If
#' omitted, the fitted values are used.
#' @param ... Additional arguments (not used)
#'
#' @return A numeric vector of predictions
#' @export
#'
#' @examples
#' \dontrun{
#' gc1 <- fit_growth_logistic(mydata, Time, OD600)
#' predict(gc1)
#' }
predict.growthcurve <- function(object, newdata = NULL, ...) {
    #stats::predict(object$model)
    if (is.null(newdata)) object$f(object$fit$x)
    else object$f(newdata)
}
