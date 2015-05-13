#' growthcurve: A package for the analysis of biological growth curves
#' 
#' The growthcurve package provides functions for analyzing biological growth
#' curves. growthcurve is currently a wrapper for the \pkg{grofit} package
#' with a focus on incorporating growth curve analysis into modern R workflows.
#' These functions only work with data stored in data frames or compatible
#' objects. Eventually, this package will become independent of \pkg{grofit},
#' allowing for increased functionality.
#'
#' @docType package
#' @name growthcurve
NULL


#' Growth data for Pseudomonas aeruginosa strains
#' 
#' A dataset containing growth information for two strains of the bacterium
#' \emph{Pseudomonas aeruginosa} grown in a limiting medium for 48 hours.
#' Growth was estimated by counting colonies on LB agar plates.
#' 
#' \describe{
#'     \item{Time}{The time at which growth was measured (hours)}
#'     \item{Replicate}{The replicate population (unitless)}
#'     \item{Strain}{The strain, either PAO1 (Wild type) or Mutant}
#'     \item{CFUmL}{The current yield (colony forming units per mL)}
#' }
#' 
#' @docType data
#' @keywords datasets
#' @name pseudomonas
#' @usage data(pseudomonas)
#' @format A data frame with 180 rows and 4 variables
NULL
