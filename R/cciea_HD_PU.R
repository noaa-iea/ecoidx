#' Personal use landings data, Washington and California
#'
#' Personal use landings data are from PacFIN (https://pacfin.psmfc.org), and were compiled by Dr. Melissa Poe (NOAA, Washington Sea Grant). Catch of all species retained for personal use  by commercial operators from 1990 - 2014, in tons (2000 lbs). Data are from landings in 139 of 350 ports in Washington and California.
#'
#' @format A data frame with 50 rows and 3 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [6.31152E8, 1.3885344E9]}
#'   \item{personal_catch}{Personal Catch (tons) [22.825, 3579.716]}
#'   \item{use_type}{Use Type () []}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_HD_PU/index.html}
#' @concept dataset_erddap
"cciea_HD_PU"
