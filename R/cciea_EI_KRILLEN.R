#' Euphausia pacifica (krill) lengths
#'
#' Krill (Euphausia pacifica) data were provided by Dr. Eric Bjorkstedt (eric.bjorkstedt@noaa.gov), NMFS/SWFSC and Humboldt State University (HSU), and R. Robertson, Cooperative Institute for Marine Ecosystems and Climate (CIMEC) at HSU. Krill were collected at monthly intervals from the Trinidad Head Hydrographic Line (https://swfsc.noaa.gov/textblock.aspx?Division=FED&ParentMenuId=54&id=17306). Krill body length (BL) was measured in mm from the back of the eye to base of the telson.
#'
#' @format A data frame with 126 rows and 5 variables:
#' \describe{
#'   \item{time}{Time (seconds since 1970-01-01T00:00:00Z) [1.19448E9, 1.5661728E9]}
#'   \item{mean_length}{Carapace Length (mm) [7.457964, 17.27011]}
#'   \item{std_dev}{Standard Deviation (mm) [0.0, 3.874455]}
#'   \item{Seup}{Confidence Interval, Upper () [8.44838, 19.4095]}
#'   \item{Selo}{Confidence Interval, Lower () [6.331795, 15.25163]}
#' }
#' @source \url{https://oceanview.pfeg.noaa.gov/erddap/info/cciea_EI_KRILLEN/index.html}
#' @concept dataset_erddap
"cciea_EI_KRILLEN"
