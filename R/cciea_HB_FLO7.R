#' Streamflow - Annual 7-day minimum flow anomaly
#'
#' Streamflow is measured using active USGS gages (https://waterdata.usgs.gov/nwis/sw) with records that meet or exceed 30 years in duration.Average daily values from 213 gages were used to calculate annual 7-day minimum flows.  These indicators correspond to flow parameters to which salmon populations are most sensitive.  Standardized anomalies of time series from individual gages were then averaged to obtain weighted averages for ecoregions (for which HUC-8 area served as a weighting factor) and for the entire California current (weighted by ecoregion area).
#'
#' @format A data frame with 228 rows and 5 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [3.471552E8, 1.5147648E9]}
#'   \item{flow_anomaly_7_day_min}{Annual 7-day minimum flow anomaly (Annual Anomaly) [-1.13376, 1.862751]}
#'   \item{Seup}{95% credible interval upper bound (Annual Anomaly) [-0.7767891, 2.20623]}
#'   \item{Selo}{95% credible interval lower bound (Annual Anomaly) [-1.495523, 1.521317]}
#'   \item{location}{Location () []}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_HB_FLO7/index.html}
#' @concept dataset_erddap
"cciea_HB_FLO7"
