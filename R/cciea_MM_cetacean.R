#' California Current Cetacean Abundance
#'
#' Bottlenose dolphin abundance CA coastal stock: Estimates from mark-resighting analysis; see Dudzik 1999, Weller et al. 2016. Abundance is calculated from closed population models and averaged over 2 or 3 year intervals. X-axis last year used for each period.  Abundance of short-beaked common dolphin, Dall's porpoise, Fin whale, Blue whale, Humpback whale: Estimates from ship-based line transect surveys; see Barlow 2016. Gray whale abundance: Estimates from shore-based counts using baysian model; see Durban et al. 2015, Durban et al. 2017. Southern resident killer whale abundance: Estimates from vessel and shore-based surveys. No error; counts have no error assoicated with them
#'
#' @format A data frame with 102 rows and 7 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [-9.46944E7, 1.4832288E9]}
#'   \item{abundance}{Abundance () [71.0, 1427576.0]}
#'   \item{Seup}{95% credible interval upper bound () [390.0, 39210.0]}
#'   \item{Selo}{95% credible interval lower bound () [230.0, 24420.0]}
#'   \item{CV}{Coefficient of Variation () [0.044, 0.82]}
#'   \item{common_name}{Common name () []}
#'   \item{scientific_name}{Scientific name () []}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_MM_cetacean/index.html}
#' @concept dataset_erddap
"cciea_MM_cetacean"
