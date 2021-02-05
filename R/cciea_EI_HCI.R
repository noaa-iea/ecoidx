#' Habitat Compression Index
#'
#' In eastern boundary upwelling ecosystems the spatial footprint of cool upwelled water is regularly demarcated by the differential boundary of warmer oceanic water offshore from cooler coastal water, with upwelling conditions varying with latitude.   Therefore, the goal of the habitat compression index (HCI) is to track the area of cool surface waters as an index of potential 'upwelling habitat' for assessing the spatio-temporal aspects of upwelling.  Upwelling patterns of cold nutrient-rich water are clearly assessed by models and satellite observations and classified spatially by monitoring SST values less than and equal to a monthly resolved temperature threshold.  The HCI tracks the amount of area, determined by the number of grid cells in the model with 2 m surface temperature values less than the monthly temperature threshold, therefore the time series reflects the area of cool water adjacent to the coastline and provides a measure for how compressed cool surface temperatures may be in a particular month.  In this study, we extracted modeled 2 m temperature fields over the domain of each of four regions for each month and tracked the amount of area with temperature values less than and equal to a monthly temperature threshold, resulting in monthly time series starting January 1980.  Monthly temperature thresholds for a given month is the spatial average of 2 m temperature grid cells between the indicated latitude boundaries for each region and from shore out to 75 km for the time period 1980-2010. Cool expansion periods are defined as months with areas exceeding +1 standard deviation (SD) of the full time series, limited cool habitat where area of cool water is less than -1 SD, and periods of habitat compression when the area of cool water falls between the long-term monthly mean and -1 SD.
#'
#' @format A data frame with 492 rows and 5 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [3.155328E8, 1.6067808E9]}
#'   \item{hci_regn1}{Habitat Compression Index, 43.5-48N (fraction below monthly threshold) [0.0, 1.0]}
#'   \item{hci_regn2}{Habitat Compression Index, 40-43.5N (fraction below monthly threshold) [0.0, 1.0]}
#'   \item{hci_regn3}{Habitat Compression Index, 35.5-40N (fraction below monthly threshold) [0.0, 1.0]}
#'   \item{hci_regn4}{Habitat Compression Index, 30-35.5N (fraction below monthly threshold) [0.0, 0.9744409]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_EI_HCI/index.html}
#' @concept dataset_erddap
"cciea_EI_HCI"
