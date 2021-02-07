# libraries & variables ----
if (!require(librarian)){
  install.packages("librarian")
  library(librarian)
}
shelf(
  #dplyr, glue, ggplot2, here, readr, tibble, usethis)
  dplyr)

ts1 <- tibble(
  year  = 1985 + 1:30,
  index = c(1.951787,1.631605,3.457652,NA,NA,NA,-1.016788,1.526880,3.908137,4.353510,3.631307,
            4.362584,3.683589,4.665410,2.294414,1.254683,2.647636,2.933235, 4.818184,6.043274,
            2.533987,1.564976,7.850845,9.314683,7.865794,10.216519,7.164671,11.329814,9.385541,10.176562)) %>%
  mutate(
    Y2         = index,
    SElo       = index - 2,
    SEup       = index + 2,
    timeseries = "(a) Trend and recent mean",
    metric     = NA,
    type       = "current.data")
usethis::use_data(ts1, overwrite = T)





plot_theme_iea <- function(
  base_size = 14, base_family = "", base_line_size = base_size/28,
  base_rect_size = base_size/28){
  # derived from theme_classic

  theme_bw(base_size = base_size, base_family = base_family,
           base_line_size = base_line_size, base_rect_size = base_rect_size) %+replace%
    theme(
      panel.border     = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.title       = element_blank(),
      axis.line = element_line(
        colour = "black", size = rel(1)), legend.key = element_blank(),
      plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), "cm"), #top, right, bottom, left
      # strip.background = element_rect(
      #   fill = "white", colour = "black", size = rel(2)), complete = TRUE)
      strip.background = element_blank(), complete = TRUE)
}


PlotTimeSeries(ts1)
PlotTimeSeries(ts1, Y2 = NA, LWD = 0.8, Pt.cex = 0.5)
#legend("topleft","(a)", inset=-0.11, bty='n')

# Y =  Y2 = c(0.8288388,0.3560032,4.3554672,0.3492971,-1.6653125,3.0814942,7.0659828,0.4611352,2.0977700,1.4968837,5.9732167,5.3339023,6.2231723,2.9405107,6.8632977,8.5882587,2.7173843,5.4305515,5.6159417,3.8396360,5.6711355,4.3574772,5.5107925,5.5223462,7.3474867,8.0262139,6.1562065,4.4223551,3.6068412,2.3166955)

Y =  Y2 = c(0.8288388,0.3560032,4.3554672,0.3492971,0.5,1.06,2.2,0.4611352,2.0977700,1.4968837,5.9732167,5.3339023,6.2231723,2.9405107,6.8632977,8.5882587,2.7173843,NA,NA,3.8396360,NA,4.3574772,5.5107925,5.5223462,7.3474867,8.0262139,6.1562065,2.4223551,1.6068412,1.3166955)


se = rnorm(length(X),0,2)
SElo = Y-2
SEup = Y+2
XY = data.frame(cbind(X,Y,Y2,SEup,SElo))
colnames(XY) = cbind('year','index','Y2',"SEup","SElo")
XY$timeseries="(b) Threshold"
XY$metric = NA
XY$type = "current.data"

source("R/PlotTimeSeries.R")
PlotTimeSeries(XY, YLIM = c(0,NA), LWD = 0.8, Pt.cex = 0.7, threshold = 3, threshold.correct = TRUE, threshold.loc = 'below')
#legend("topleft","(b)", inset=-0.11, bty='n')
# reset
SElo = NA
SEup = NA
Y2 = NA
Ylab = NA

x = c(1.3,1.1,0.5, -1.5,-0.6)
y = c(2.1, -0.9, -1.5, 1.4, 0.5)
COL = c('black','grey','red','blue','green')


xerrors=NA; yerrors=NA
QuadPlot_means(D1 = x, D2 = y, style=1, TitleCex = 0.9, PointCex = 1.5, Title = "(c) Sample quadplot", bg.polys=bg.polys, PlotLegend = NA, Lmar = 4.5)
