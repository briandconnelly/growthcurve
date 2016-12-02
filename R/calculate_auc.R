# Calculate the area under the curve
calculate_auc <- function(x, y) {
    sum(diff(x) * na.omit(head(y, -1) + tail(y, -1)) ) / 2
}
