#' Groundfish Stock Status
#'
#' Source Data: Dr. Jason Cope (NOAA; jason.cope@noaa.gov), derived from NMFS stock assessments (https://www.nwfsc.noaa.gov/research/divisions/fram/popeco/assessment.cfm). Additional Calculations: Reference Cope and Haltuch (2014) CCIEA PHASE III REPORT 2013: ECOSYSTEM COMPONENTS - GROUNDFISH report for full explanation of what sources of information were used for each species.
#'
#' @format A data frame with 3857 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [-2.9663712E9, 1.4200704E9]}
#'   \item{species_group}{Species Group () []}
#'   \item{relative_stock_status}{ (relative biomass) [0.0498108, 1.25279]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_GF_STAT/index.html}
#' @concept dataset_erddap
"cciea_GF_STAT"
