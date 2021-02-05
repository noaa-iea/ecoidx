#' Forage Biomass, California Current South
#'
#' Source Data: Dr. Andrew Thompson (NOAA; andrew.thompson@noaa.gov); derived from spring CalCOFI surveys (https://calcofi.org/) Additional Calculations: Larval fish data summed across all stations of the CalCOFI survey in spring (units are in number under 10 sq. m of surface area; ln(abundance+1)).
#'
#' @format A data frame with 350 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [2.524608E8, 1.5463008E9]}
#'   \item{species_group}{Species Group () []}
#'   \item{relative_abundance}{Relative abundance (ln(abundance+1)) [0.0, 4.627175]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_EI_FBS/index.html}
#' @concept dataset_erddap
"cciea_EI_FBS"
