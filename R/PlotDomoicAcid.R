#' Plot domoic acid monthly, original
#'
#' @param Data.File ...
#' @param Date ...
#' @param Location ...
#' @param DA ...
#' @param Species ...
#' @param spp ...
#' @param THRESH ...
#' @param COL ...
#' @param Xlim ...
#' @param Ylab ...
#' @param Ymax ...
#' @param Title ...
#' @param LegendLoc ...
#' @param legend.cex ...
#' @param legend.inset ...
#' @param pt.cex ...
#' @param LWD ...
#'
#' @return
#'
#' @export
#' @concept plot_original
Plot_Domoic_Acid_Monthly <- function(
  Data.File = NA,
  Date = "Date",
  Location = "Waterbody",
  DA = "DA.ppm",
  Species = "Species", # this is the column in the data set
  spp = NA, # set this to control the order of plotting.  Otherwise alphabetic
  THRESH = c(30, 20),
  COL = c('black', 'darkgrey'),
  Xlim = NA, #c(1990,2020),
  Ylab = "Monthly max (ppm)",
  Ymax = NA,
  Title  = NA,
  LegendLoc = "topleft",
  legend.cex = 0.8,
  legend.inset = c(0.0),
  pt.cex = 0.1,
  LWD = 1){

  ## rename column names
  cn = colnames(Data.File)
  cn[cn == Date] <- "Date"
  cn[cn == Species] <- "Species"
  cn[cn == Location] <- "Location"
  cn[cn == DA] <- "DA"
  colnames(Data.File) <- cn

  # start calculation and plotting
  # add month-15

  year = as.numeric(substring(Data.File$Date,1,4))
  month = as.numeric(substring(Data.File$Date,6,7))
  Data.File$Date2 = as.POSIXct(paste(year,month,15,sep='-'))

  ########## get monthly max ###########

  MonthlyMax = aggregate(DA  ~ Location + Species + Date2, data = Data.File, FUN = max)
  # head(MonthlyMax)

  # set up file with year-month for all dates
  # to fill with NAs for missing data.
  # for plotting

  y1 = min(year)
  y2 = max(year)
  y3 = y1:y2
  for(i in 1:length(y3)){
    ym = paste(y3[i],1:12,15,sep = '-')
    if(i == 1){YM = ym}else{YM = c(YM, ym)}
  }

  YM = data.frame(as.POSIXct(YM))
  colnames(YM) = 'Date'
  DF = YM

  if(is.na(spp[1]) == TRUE){spp = levels(as.factor(MonthlyMax$Species))}

  # for each spp in file, transfer data to new file, rename
  for(k in 1:length(spp)){
    x = MonthlyMax[MonthlyMax$Species == spp[k],]
    DF$Species = spp[k]
    DF$Location =x$Location[1]
    DF$DA = x$DA[match(DF$Date, x$Date2)]
    if(k == 1){DA_Monthly_Max = DF}else{DA_Monthly_Max = rbind(DA_Monthly_Max, DF)}
  } # end k

  ####### begin function
  # set x axis
  # set y max-
  if(is.na(Ymax[1]) == TRUE){ymax = max(DA_Monthly_Max$DA,na.rm = TRUE)}else{ymax = Ymax}

  # set xlim
  if(is.na(Xlim[1]) == TRUE){
    xmin = min(DA_Monthly_Max$Date, na.rm = TRUE)
    xmax = max(DA_Monthly_Max$Date, na.rm = TRUE)
  }else{
    if(nchar(as.character(Xlim[1]))>10){  xmin = substring(Xlim[1],1,10)}
    if(nchar(as.character(Xlim[1]))==10){ xmin = as.POSIXct(Xlim[1])}                 # year-month-day
    if(nchar(as.character(Xlim[1]))== 7){ xmin = as.POSIXct(paste(Xlim[1],15,sep='-'))}   # year-month
    if(nchar(as.character(Xlim[1]))== 4){ xmin = as.POSIXct(paste(Xlim[1],01,15,sep='-'))}# year

    if(nchar(as.character(Xlim[2]))>10){  xmax = substring(Xlim[2],1,10)}
    if(nchar(as.character(Xlim[2]))==10){ xmax = as.POSIXct(Xlim[2])}                 # year-month-day
    if(nchar(as.character(Xlim[2]))== 7){ xmax = as.POSIXct(paste(Xlim[2],15,sep='-'))}   # year-month
    if(nchar(as.character(Xlim[2]))== 4){ xmax = as.POSIXct(paste(Xlim[2],01,15,sep='-'))}# year
  }

  XLIM = c(xmin, xmax)

  # some info

  # spp set above

  Nspp = length(spp)

  #### plot spp 1 - alphabetic order ####

  spp1 = DA_Monthly_Max[DA_Monthly_Max$Species == spp[1],]
  Title = if(is.na(Title)==TRUE){Title = spp1$Location[1]}else{Title = Title}


  plot(spp1$Date, spp1$DA, bty = 'n',
       xlab = NA, ylab = Ylab,
       type = 'o', pch = 19, cex = pt.cex, lwd = LWD,
       xlim = XLIM, ylim = c(0,ymax),
       col = COL[1],
       main = Title)
  segments(XLIM[1], THRESH[1], XLIM[2], THRESH[1], col = COL[1], lty = 'dashed', lwd=1)
  ##### plot spp 2

  for(k in 1:Nspp){
    spp2 = DA_Monthly_Max[DA_Monthly_Max$Species == spp[k],]
    lines(spp2$Date, spp2$DA, col = COL[k], type = 'o', pch = 19, cex = pt.cex)
    segments(XLIM[1], THRESH[k], XLIM[k], THRESH[k], col = COL[k], lty = 'dashed', lwd = LWD)

  } # end if

  # set minor tics
  x1 = as.numeric(substring(XLIM[1],1,4))
  x2 = as.numeric(substring(XLIM[2],1,4))
  x3 = x1:x2
  x4 = as.POSIXct(paste(x3,01,01,sep="-"))
  axis(side = 1, at = x4, labels = FALSE, tcl = -0.25)

  legend(LegendLoc, legend = spp, col = COL[1:Nspp], lty='solid',
         pch=19, cex=legend.cex, bty='n', inset = legend.inset)

} # end Function
