StatGrowthCurve <- ggplot2::ggproto("StatGrowthCurve", ggplot2::Stat,
    required_aes = c("x", "y"),
    compute_group = function(data, scales, model = "logistic") {
        fit <- fit_growth_(df = data, time_col = "x", data_col = "y",
                           model = model)
        data.frame(x = fit$fit$x, y = fit$fit$y)
    }
)

#' ggplot2: Add a fitted growth curve
#' 
#' \code{stat_growthcurve} adds a fitted growth curve got a ggplot2 plot
#' 
#' @inheritParams ggplot2::stat_identity
#' @inheritParams fit_growth
#' @param na.rm a logical value indicating whether \code{NA} values should be
#' stripped before the computation proceeds.
#' @export
stat_growthcurve <- function(mapping = NULL, data = NULL, model = "logistic",
                             geom = "line", position = "identity",
                             na.rm = FALSE, show.legend = NA,
                             inherit.aes = TRUE, ...) {

    stop_without_package("ggplot2")

    ggplot2::layer(
        stat = StatGrowthCurve,
        data = data,
        mapping = mapping,
        geom = geom,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(model = model, na.rm = na.rm, ...)
    )
}
