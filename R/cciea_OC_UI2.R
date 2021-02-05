#' Upwelling Index, 39N 125W, monthly
#'
#' Upwelling index computed from 1-degree FNMOC sea level pressure at 39 degrees of latitude. The coastal Upwelling Index is an index of the strength of the wind forcing on the ocean which has been used in many studies of the effects of ocean variability on the reproductive and recruitment success of many fish and invertebrate species.
#'
#' @format A data frame with 649 rows and 4 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [-9.46944E7, 1.6094592E9]}
#'   \item{upwelling_index}{Upwelling Index, 39N 125W, monthly (m^3/s/100m coastline) [-282.4014, 448.8212]}
#'   \item{nobs}{Number of oberservations in month () [87, 124]}
#'   \item{stdev}{Standard deviation (m^3/s/100m coastline) [39.227, 670.585]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_OC_UI2/index.html}
#' @concept dataset_erddap
"cciea_OC_UI2"
