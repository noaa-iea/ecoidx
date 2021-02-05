#' Forage Biomass, California Current Central
#'
#' Source Data: Dr. John Field (NOAA; john.field@noaa.gov) from the SWFSC Rockfish Recruitment and Ecosystem Assessment Survey (https://swfsc.noaa.gov/textblock.aspx?Division=FED&ParentMenuId=54&id=20615). Additional Calculations: Samples represent catch (individuals) per standard 15 minute trawl (CPUE). Data are log(CPUE+1) transformed; Geometric means calculated on non-zero data.
#'
#' @format A data frame with 390 rows and 5 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [6.31152E8, 1.5463008E9]}
#'   \item{species_group}{Species Group () []}
#'   \item{mean_cpue}{Mean CPUE (ln(catch+1)) [0.0, 10.85264]}
#'   \item{Seup}{Confidence Interval, Upper () [0.0, 11.18415]}
#'   \item{Selo}{Confidence Interval, Lower () [-4.05304E-10, 10.52114]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_EI_FBC/index.html}
#' @concept dataset_erddap
"cciea_EI_FBC"
