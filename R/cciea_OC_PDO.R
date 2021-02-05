#' Pacific Decadal Oscillation Index
#'
#' Updated standardized values for the PDO index, derived as the leading PC of monthly SST anomalies in the North Pacific Ocean, poleward of 20N. The monthly mean global average SST anomalies are removed to separate this pattern of variability from any "global warming" signal that may be present in the data.
#'
#' @format A data frame with 1452 rows and 2 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [-2.2089888E9, 1.6067808E9]}
#'   \item{PDO}{PDO Index () [-3.6, 3.51]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_OC_PDO/index.html}
#' @concept dataset_erddap
"cciea_OC_PDO"
