#' Monthly Biologically Effective Upwelling Transport Index (BEUTI)
#'
#' BEUTI provides estimates of vertical nitrate flux near the coast (i.e., the amount of nitrate upwelled/downwelled), which may be more relevant than upwelling strength when considering some biological responses.
#'
#' @format A data frame with 1191 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [5.679936E8, 1.6094592E9]}
#'   \item{beuti}{Biologically Effective Upwelling Transport Index (mmol s^-1 m^-1) [-22.082, 50.279]}
#'   \item{latitude}{Latitude (degrees_north) [33, 45]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_OC_BEUTI/index.html}
#' @concept dataset_erddap
"cciea_OC_BEUTI"
