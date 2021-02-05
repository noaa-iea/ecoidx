#' Seabird Productivity
#'
#' Data from Point Blue Conservation Science collected on Southeast Farallon Island in collaboration with the Farallon Islands National Wildlife Refuge (USFWS); contact Dr. Jaime Jahncke (jjahncke@pointblue.org) before citing or distributing these data. Productivity anomaly is the annual mean number of chicks fledged per breeding pair per species minus the long term mean, which is calculated by averaging all of the annual means prior to the most recent year (for data from 1986 to 2018, the long term mean is calculated including data from 1986-2017.
#'
#' @format A data frame with 229 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [3.1536E7, 1.5463008E9]}
#'   \item{productivity_anomaly}{Productivity Anomaly () [-1.405, 1.425]}
#'   \item{species_cohort}{Species cohort () []}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_B_PR_ANOM/index.html}
#' @concept dataset_erddap
"cciea_B_PR_ANOM"
