#' @export
predict.growthcurve <- function(object, ...) {
    stats::predict(object$model)
}
