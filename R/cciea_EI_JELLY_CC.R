#' Jellyfish Biomass, Central Californial
#'
#' Source Data: Dr. John Field (NOAA; john.field@noaa.gov) from the SWFSC Rockfish Recruitment and Ecosystem Assessment Survey (https://swfsc.noaa.gov/textblock.aspx?Division=FED&ParentMenuId=54&id=20615). Additional Calculations: Samples represent catch (individuals) per standard 15 minute trawl (CPUE). Data are log(CPUE+1) transformed; Geometric means calculated on non-zero data.
#'
#' @format A data frame with 52 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [6.31152E8, 1.4200704E9]}
#'   \item{species_group}{Species Group () []}
#'   \item{abundance}{Mean CPUE (ln(catch+1)) [0.0, 1.382158]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_EI_JELLY_CC/index.html}
#' @concept dataset_erddap
"cciea_EI_JELLY_CC"
