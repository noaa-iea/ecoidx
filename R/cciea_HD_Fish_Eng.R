#' Commercial Fishing Engagement Index
#'
#' Commercial fishing engagement data were provided by Dr. Karma Norman (NOAA), and are derived from state reported fish ticket data as maintained by the Pacific Fishery Information Network (PacFIN) (https://pacfin.psmfc.org/).
#'
#' @format A data frame with 455 rows and 4 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [1.1045376E9, 1.4832288E9]}
#'   \item{fishing_engagement}{Commercial fishing engagement index (Index) [-0.19823, 16.83776]}
#'   \item{location}{Location () []}
#'   \item{region}{Region () []}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_HD_Fish_Eng/index.html}
#' @concept dataset_erddap
"cciea_HD_Fish_Eng"
