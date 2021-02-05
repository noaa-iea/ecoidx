#' Chinook Condition, California
#'
#' Source Data: Various; see Wells et al. 2014, Table S4. Additional Calculations: Proportion of natural-origin spawners, computed for a single population as the fraction NN/NT, where NN is the number of naturally-origin spawners, and NT is the total number of spawners. Population fractions were then averaged across the populations within the ESU, weighted by total spawner abundance., Source Data: Various; see Wells et al. 2014, Table S4. Additional Calculations: Population growth rate, estimated as the ratio of the 4-year running mean of spawning escapement in one year to the 4-year running mean for the previous year, Source Data: Various; see Wells et al. 2014, Table S4. Additional Calculations: Age-structure diversity, computed as Shannon's diversity index of spawner age for each population within each year. The indices were then averaged across populations, weighted by total spawner abundance.
#'
#' @format A data frame with 253 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [0.0, 1.4516064E9]}
#'   \item{population}{Population () []}
#'   \item{condition}{ (Population growth rate) [-1.41059, 4.28817]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_SM_CA_CH_CND/index.html}
#' @concept dataset_erddap
"cciea_SM_CA_CH_CND"
