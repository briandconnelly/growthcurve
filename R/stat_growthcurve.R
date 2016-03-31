StatGrowthCurve <- ggplot2::ggproto("GrowthCurve", ggplot2::Stat,
    required_aes = c("x", "y"),

    compute_group = function(data, scales, type = "parametric") {
        fit <- fit_growth(df = data, time = x, data = y, type = type)
        data.frame(x = fit$fit.time, y = fit$fit.data)
    }
)

#' ggplot2: Add a fitted growth curve
#' 
#' \code{stat_growthcurve} adds a fitted growth curve got a ggplot2 plot
#' 
#' @inheritParams ggplot2::stat_identity
#' @inheritParams fit_growth
#' @export
stat_growthcurve <- function(mapping = NULL, data = NULL, type = "parametric",
                             geom = "path", position = "identity",
                             na.rm = FALSE, show.legend = NA,
                             inherit.aes = TRUE, ...) {
    ggplot2::layer(
        stat = StatGrowthCurve, data = data, mapping = mapping, geom = geom,
        position = position, show.legend = show.legend,
        inherit.aes = inherit.aes, params = list(type = type, na.rm = na.rm,
                                                 ...)
    )
}
