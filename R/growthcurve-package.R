#' growthcurve: Analysis of Biological Growth
#' 
#' \pkg{growthcurve} provides functions for analyzing biological growth.
#' 
#' Growth parameters such as maximum rate and yield are determined by fitting
#' curves to tidy data sets.
#' 
#' growthcurve also provides wrappers that allow tidy growth data to be analyzed
#' using the popular, but no-longer-maintained \pkg{grofit} package, if
#' installed. See \link{grofit_wrappers} for details.
#'
#' @docType package
#' @name growthcurve-package
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
#'     \item{CFUmL}{The density of the population (colony forming units per mL)}
#' }
#' 
#' @docType data
#' @keywords datasets
#' @name pseudomonas
#' @usage data(pseudomonas)
#' @format A data frame with 180 rows and 4 variables
NULL


#' Phage growth data
#' 
#' \emph{Escherichia coli} grown for 24 hours with and without phage.
#' Growth was measured using optical density at 420 nm.
#' 
#' \describe{
#'     \item{Strain}{The strain of \emph{E. coli}, either WT (REL606) or malT}
#'     \item{Phage}{Logical value indicating whether or not phage were present}
#'     \item{Well}{The microtiter plate well in which the population was grown (A1-H12)}
#'     \item{Time}{The time at which the reading was taken (seconds)}
#'     \item{OD420}{The density of the population, measured at 420 nm (absorbance units)}
#' }
#' 
#' @seealso GenBank information about REL606: \url{http://www.ncbi.nlm.nih.gov/nuccore/NC_012967}
#' 
#' @docType data
#' @author Luis Zaman (data)
#' @author Brian Connelly (formatting)
#' @keywords datasets
#' @name phage
#' @usage data(phage)
#' @format A data frame with 46176 rows and 6 variables
NULL


#' Bacterial growth in a microtiter plate
#'
#' \describe{
#'     \item{Time}{The time at which the reading was taken (seconds)}
#'     \item{Well}{The microtiter plate well in which the population was grown (A1-H12)}
#'     \item{OD600}{The density of the population, measured at 600 nm (absorbance units)}
#'     \item{Strain}{The strain of bacteria. \code{control} indicates a well without bacteria.}
#'     \item{Environment}{The environment in which cells were cultured}
#' }
#' 
#' @docType data
#' @author Katrina van Raay (data)
#' @author Brian Connelly (formatting)
#' @name kvr
#' @usage data(kvr)
#' @format A data frame with 115320 rows and 5 variables
NULL
