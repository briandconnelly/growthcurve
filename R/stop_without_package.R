# Raise an error if a required package is not installed
stop_without_package <- function(package) {
    if (!requireNamespace(package, quietly = TRUE)) {
        stop(sprintf("This function requires the '%s' package", package),
             call. = FALSE)
    }
}
