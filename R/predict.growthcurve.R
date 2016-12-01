#' @export
predict.growthcurve <- function(object, ...) {
    predict(object$model)
}
