# Helper function for evaluating an expression in a given environment
eval_env <- function(expr, ...) eval(expr = expr, envir = list(...))
