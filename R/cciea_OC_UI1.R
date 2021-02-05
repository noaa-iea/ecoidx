#' Upwelling Index, 45N 125W, monthly
#'
#' Upwelling index computed from 1-degree FNMOC sea level pressure 45 degrees of latitude. The coastal Upwelling Index is an index of the strength of the wind forcing on the ocean which has been used in many studies of the effects of ocean variability on the reproductive and recruitment success of many fish and invertebrate species.
#'
#' @format A data frame with 649 rows and 4 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [-9.46944E7, 1.6094592E9]}
#'   \item{upwelling_index}{Upwelling Index, 45N 125W, monthly (m^3/s/100m coastline) [-395.7448, 93.0324]}
#'   \item{nobs}{Number of oberservations in month () [87, 124]}
#'   \item{stdev}{Standard deviation (m^3/s/100m coastline) [23.007, 659.207]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_OC_UI1/index.html}
#' @concept dataset_erddap
"cciea_OC_UI1"
