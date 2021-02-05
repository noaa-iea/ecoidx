#' Monthly Coastal Upwelling Transport Index (CUTI)
#'
#' CUTI provides estimates of vertical transport near the coast (i.e., upwelling/downwelling). It was developed as a more accurate alternative to the previously available Bakun Index.
#'
#' @format A data frame with 1191 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [5.679936E8, 1.6094592E9]}
#'   \item{cuti}{Coastal Upwelling Transport Index (m^2 s^(-1)) [-1.252, 2.751]}
#'   \item{latitude}{Latitude (degrees_north) [33, 45]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_OC_CUTI/index.html}
#' @concept dataset_erddap
"cciea_OC_CUTI"
