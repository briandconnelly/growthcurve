# Calculate the area under the curve
calculate_auc <- function(x, y) {
    sum(diff(x) * stats::na.omit(utils::head(y, -1) + utils::tail(y, -1)) ) / 2
}
