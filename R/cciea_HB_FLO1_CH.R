#' Streamflow - Annual 1-day maximum flow anomaly, Chinook ESU's
#'
#' Streamflow is measured using active USGS gages (https://waterdata.usgs.gov/nwis/sw) with records that meet or exceed 30 years in duration.Average daily values from 213 gages were used to calculate annual 1-day maximum flows.  These indicators correspond to flow parameters to which salmon populations are most sensitive.  Standardized anomalies of time series from individual gages were then averaged to obtain weighted averages for ecoregions (for which HUC-8 area served as a weighting factor) and for the entire California current (weighted by ecoregion area).
#'
#' @format A data frame with 608 rows and 5 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [3.471552E8, 1.5147648E9]}
#'   \item{flow_anomaly_1_day_max}{Annual 1-day maximum flow anomaly (Annual Anomaly) [-1.926416, 3.357548]}
#'   \item{Seup}{Confidence Interval, Upper (Annual Anomaly) [-1.701417, 3.63615]}
#'   \item{Selo}{Confidence Interval, Lower (Annual Anomaly) [-2.157472, 3.077887]}
#'   \item{location}{Location () []}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_HB_FLO1_CH/index.html}
#' @concept dataset_erddap
"cciea_HB_FLO1_CH"
