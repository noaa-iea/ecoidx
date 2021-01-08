############ example of file use for CCIEA plotting code ###################

df = data.frame(read.table("ExampleData.csv", header=TRUE, sep=','))
source("PlotTimeSeries.R")
source("QuadPlot_incl_normalize.R")

#plot the time series

par(mfrow=c(2,1))
te = 2
YLIM = c(0.55, 0.75)
PlotTimeSeries(df[df$timeseries=="Simpson diversity - North",], TicsEvery = te, YLIM=YLIM)
PlotTimeSeries(df[df$timeseries=="Simpson diversity - South",], TicsEvery = te, YLIM=YLIM)

# make a quadplot 
par(mfrow=c(1,1))
NormalizeAndQuadPlot(df$year, df$index, df$timeseries, 5, PlotLegend = TRUE)


