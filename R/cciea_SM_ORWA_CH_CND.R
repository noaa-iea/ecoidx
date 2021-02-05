#' Chinook Condition, Oregon/Washington
#'
#' Source Data: Various; see Wells et al. 2014, Table S6. For Oregon and Washington ESUs, data were obtained from the NWFSC's "Salmon Population Summary" database (https://www.webapps.nwfsc.noaa.gov/sps), with additional data for Oregon Coast coho salmon (Oregon Department of Fish and Wildlife, https://oregonstate.edu/dept/ODFW/spawn/data.htm), and from PFMC (2012) for the Upper Columbia Summer/Fall-run Chinook Salmon. Additional Calculations: Age-structure diversity, computed as Shannon's diversity index of spawner age for each population within each year. The indices were then averaged across populations, weighted by total spawner abundance.
#'
#' @format A data frame with 220 rows and 5 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [0.0, 1.3885344E9]}
#'   \item{population}{Population/Season () []}
#'   \item{cond_pct_nat}{Proportion of natural fish to total fish returning () [0.0, 100.0]}
#'   \item{cond_pop_gr}{Proportional change in abundance between cohorts () [0.4510503, 2.383912]}
#'   \item{cond_age_div}{Age Diversity Shannon-Weaver () [0.1894317, 1.450296]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_SM_ORWA_CH_CND/index.html}
#' @concept dataset_erddap
"cciea_SM_ORWA_CH_CND"
