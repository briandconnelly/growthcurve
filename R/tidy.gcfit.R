#' Tidy a fitted growth curve into a summary data.frame
#' 
#' \code{tidy.gcfit} is intended to provide a summary data frame for a growth
#' curve that is compatible with- and follows the naming conventions of
#' \code{\link{broom}}.
#'
#' @param x A fit for some growth data
#' @param ... 
#'
#' @return A data.frame
#' @export tidy.gcfit
#'
#' @examples
#' \dontrun{
#' # Fit the data given in columns Time and OD600
#' myfit <- fit_growth_gompertz(mydata, Time, OD600)
#' tidy(myfit)}
#'
tidy.gcfit <- function(x, ...) {
    if (!requireNamespace("broom", quietly = TRUE)) {
        stop("broom package is required.")
    }
    
    # For now, we can just bootstrap this using broom's tidy for nls
    info <- broom::tidy(x$grofit$nls)
    info[info$term == "A",]$term <- "max_growth"
    info[info$term == "mu",]$term <- "max_rate"
    info[info$term == "lambda",]$term <- "lag_length"
    info
}
