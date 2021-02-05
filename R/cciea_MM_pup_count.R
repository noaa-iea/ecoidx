#' California sea lion pup survey, San Miguel Island, California.
#'
#' California sea lion pups are counted at San Miguel Island, California. Live pups are counted at the end of July each year, after all pups have been born. Pups are weighed in September or October each year and weights are adjusted using a mixed effects model to a 1 October weighing date. Growth rates are predicted from a longitudinal sample of uniquely marked pups that are captured in October and again the following February. Growth rates are modeled using a mixed effects model and standard errors are estimated using bootstrap
#'
#' @format A data frame with 23 rows and 7 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [8.520768E8, 1.5463008E9]}
#'   \item{live_pup_count}{Sea lion pup count, San Miguel Isl. (count) [9428.0, 27148.0]}
#'   \item{live_pup_count_se}{Sea lion pup count standard error, San Miguel Isl. (count) [51.99038, 719.5551]}
#'   \item{mean_weight}{Female sea lion pup weight index (kg) [11.95362, 20.63407]}
#'   \item{mean_weight_se}{Female sea lion pup weight index standard error (kg) [0.1044493, 0.1937013]}
#'   \item{mean_growth_rate}{Female sea lion pup growth rate (kg/day) [0.01268848, 0.09503055]}
#'   \item{mean_growth_rate_se}{Female sea lion pup growth rate standard error (kg/day) [0.001847422, 0.01116279]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_MM_pup_count/index.html}
#' @concept dataset_erddap
"cciea_MM_pup_count"
