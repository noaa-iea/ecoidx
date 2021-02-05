#' Coho Abundance, California
#'
#' Source Data: Various; see Wells et al. 2014, Table S3. Additional Calculations: Abundance indices are calculated as longterm anomalies (observed mean/standard deviation) of annual escapement by natural origin spawners from Huntley Park (Rogue River). Data series for multiple subpopulations were standardized by subtracting the series mean and dividing by the series standard deviation. If a consolidated index for the stock was needed we computed an annual weighted average of the standardized series, with weights proportional to the average abundance for each subpopulation., Source Data: Various; see Wells et al. 2014, Table S3. Additional Calculations: Abundance indices are calculated as longterm anomalies (observed mean/standard deviation) of annual escapement (redd counts) by natural origin spawners in Lagunitas Creek. Data series for multiple subpopulations were standardized by subtracting the series mean and dividing by the series standard deviation. If a consolidated index for the stock was needed we computed an annual weighted average of the standardized series, with weights proportional to the average abundance for each subpopulation.
#'
#' @format A data frame with 52 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [5.364576E8, 1.4516064E9]}
#'   \item{population}{Population () []}
#'   \item{abundance_anomaly}{Abundance anomaly (Abundance anomaly) [-1.571502, 3.820772]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_SM_CA_CO_ABND/index.html}
#' @concept dataset_erddap
"cciea_SM_CA_CO_ABND"
