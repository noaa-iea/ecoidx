# file made: 2018-10-23 

# This file will normalize multiple time series and produce the quadplot.
# Your data need three columns: year, index, time series name.
# example command: QuadPlot(MyData$year, MyData$index, MyData$timeseries)


QuadPlot<-function(
  
  ####################
  dframe = NULL,
  X = NA, # year
  Y = NA, # index
  Name = NA, # time series name
  PERIOD=5, # analysis period, usually 5 years.  
  ######
  d1.col = NULL,
  d2.col = NULL,
  rng = NULL,
  Title=NA, 
  plot.type=1, # include sd or not, I think
  style=1, # flip the axes
  flip.colors=NULL,
  bg.polys=FALSE, # turn on and off the yellow, red, green background
  Xlab=NULL, 
  Ylab=NULL, 
  Label=NULL, # orders the legend.  Must match timeseries.  If excluded, uses timesseries.
  # Label = DF$timeseries,
  Symbol=c(21,21,21,21,21,24,24,24,24,24,25,25,25,25,25), 
  bg.color=c('black','white','grey','red','blue'), 
  ol.color="black",
  Xlim = NA,
  Ylim = NA,
  AxisCex=0.9,
  LabelCex=0.9,
  XYLabCex =0.9,
  LegendCex=0.8,
  LegendPointCex=1, 
  TitleCex=1,
  TextCex=0.8,
  PointCex=1, 
  Period.Label="Years", 
  Bmar = NA, # to alter margines
  Lmar = NA,
  Tmar = NA,
  Rmar = NA,
  AltTxt=NA, 
  l.inset = c(0,0), # move legend around a bit 
  TextOffset = 0.5,# to move the High & increasing lables away from the zero axis.
  PlotLegend=NULL ){
  ######### start function ####  
  ################ Normalize Input Data ############################
  
  ########## apply some names 
  if(!is.null(dframe)){
    X = dframe$year
    Y = dframe$index
    Name = dframe$timeseries
  }
  
  ############ load up normalization function 
  GetNormY <- function(X,Y,Name, PERIOD){
    #X = DF$year  # for testing code
    #Y = DF$index  # for testing code 
    #print(paste("Normalizing data for figure", i))
    if(nchar(as.character(X[1]))==10){ x = as.POSIXct(X)}                 # year-month-day
    if(nchar(as.character(X[1]))== 7){ x = as.POSIXct(paste(X,01,sep='-'))}   # year-month
    if(nchar(as.character(X[1]))== 4){ x = as.POSIXct(paste(X,01,01,sep='-'))}# year
    Y[Y %in% c(-999, -9999)]<- NA
    # normalize all data & get mn and stdev
    mn = mean(Y, na.rm=TRUE)
    stdev = sd(Y, na.rm=TRUE)
    Ynorm = (Y-mn)/stdev
    
    # get info for evaluation PERIOD 
    if(is.na(PERIOD[1])==TRUE){PERIOD2 = 5}else{if(length(PERIOD)==1){PERIOD2 = PERIOD}else{PERIOD2 = PERIOD[i]}}
    
    x1 = as.numeric(substring(as.POSIXct(strptime(x, "%Y")),1,4))
    xmin = min(x1)
    xmax = max(x1)
    labrange = c(xmin:xmax)
    atx  = as.POSIXct(paste(labrange,01,01,sep='-'))
    period = PERIOD-1
    # 	xeval = atx[(length(atx)-period)]
    # 	x1 = x[match(xeval,x):length(x)]
    #   y1 = Y[match(xeval,x):length(Y)]
    
    xeval = atx[(length(atx)-period)]
    yloc = length(Y)-period
    y1 = Ynorm[yloc:length(Y)]
    x1 = x[yloc:length(x)]
    # mean of the last 5 years = LONGTERM axix for Quadplot
    mn5 = mean(y1, na.rm=TRUE) 
    mod1 = lm(y1~x1)
    s1 <- summary(mod1)
    slope <- s1$coefficients[2,1]
    pred <- predict(mod1)
    diff <- pred[length(pred)]-pred[1] # predicted change over the last five years. ## short term axis for Quadplot 
    name1 <- as.character(Name)
    n = length(Y)
    results <- data.frame(cbind(name1, mn,stdev, mn5, slope, diff,n))
    return(results)
    
  }
  
  ##### some prelim calculations to decide whether and how to normalize ####
  timeseries = levels(as.factor(as.character(Name)))
  no.ts = length(timeseries)
  df1 = data.frame(cbind(X,Y,as.character(Name)))
  rm(X,Y)
  df1$Y = as.numeric(as.character(df1$Y))
  colnames(df1)<- c('X','Y','Name')
  Qdata = NA
  
  ########### normalize data ###########
  # normalize if the time series length is > 1, which is raw data.
  # if ts.length = 1, data are already normalized
  
   for(i in 1:no.ts){
     df2 = df1[df1$Name==timeseries[i],]
     qd = GetNormY(df2$X, df2$Y, df2$Name[1],PERIOD=PERIOD)
     Qdata = rbind(Qdata,qd)
   }
   DF = Qdata[-1,]
   colnames(DF)[1] <- 'timeseries'
  
  if(is.null(Label)){Label = as.character(DF$timeseries)}
  plot.order = data.frame(Label)
  plot.order$order = 1:length(Label)
  DF$order = plot.order$order[match(DF$timeseries,plot.order$Label)]
  DF = DF[order(DF$order),]
  DF$timeseries = as.character(DF$timeseries)
 
   
  ####################
  
  d1 = as.numeric(as.character(DF$diff))
  d2 = as.numeric(as.character(DF$mn5))
  
  # legend toggle land margins ####
  title.font = 2
  if(is.null(PlotLegend)){PlotLegend=TRUE}
  if(PlotLegend %in% c("Yes",'yes','YES',TRUE)==TRUE){PlotLegend=TRUE}
  if(PlotLegend %in% c("No",'no','NO',NA,FALSE)==TRUE){PlotLegend=FALSE}
  if(PlotLegend==TRUE){
    if(is.na(Bmar)==TRUE){Bmar = 3}else{Bmar = Bmar}
    if(is.na(Lmar)==TRUE){Lmar = 3}else{Lmar = Lmar}
    if(is.na(Tmar)==TRUE){Tmar = 1}else{Tmar = Tmar}
    if(is.na(Rmar)==TRUE){Rmar = 6.25}else{Rmar = Rmar}
    par(pty = "s", ps = 10, cex = 1, cex.axis = AxisCex, cex.main = TitleCex, cex.lab=LabelCex, mar=c(Bmar, Lmar, Tmar, Rmar), xpd=NA)}
    
  if(PlotLegend==FALSE){
    if(is.na(Bmar)==TRUE){Bmar = 4}else{Bmar = Bmar}
    if(is.na(Lmar)==TRUE){Lmar = 3}else{Lmar = Lmar}
    if(is.na(Tmar)==TRUE){Tmar = 1}else{Tmar = Tmar}
    if(is.na(Rmar)==TRUE){Rmar = 1}else{Rmar = Rmar}
    par(pty = "s", ps = 10, cex = 1, cex.axis = AxisCex, cex.main = TitleCex, cex.lab=LabelCex,  mar=c(Bmar, Lmar, Tmar, Rmar), xpd=NA)
  }
  d1 <- as.numeric(as.character(d1))
  d2 <- as.numeric(as.character(d2))
  
  if(is.null(rng)){
    rng = max(ceiling(na.omit(abs(c(d1,d2)))))*1.1 # goes to whole number plus 10%
    if(rng<1.05){rng=1.05}
  }
  
  if(is.na(Xlim[1]) == TRUE){XLIM = c(-rng,rng)}else{XLIM = Xlim}
  if(is.na(Ylim[1]) == TRUE){YLIM = c(-rng,rng)}else{YLIM = Ylim}
 
  # swap plot style ####
  
  if(style==1){
    if(is.null(Xlab)){Xlab = "Recent trend"}
    if(is.null(Ylab)){Ylab = "Recent average"}
    plot(d1,d2, xlim=XLIM, ylim=YLIM,xlab=NA,  ylab=NA, type="n", cex=2, cex.lab=XYLabCex, bty="n")
  }
  if(style==2){
    if(is.null(Xlab)){Xlab = "Recent average"}
    if(is.null(Ylab)){Ylab = "Recent trend"}
    plot(d2,d1, xlim=XLIM, ylim=YLIM, xlab=NA, ylab=NA, type="n", cex=2, cex.lab=XYLabCex, bty="n")
  }
  title(xlab = Xlab, line = 2)
  title(ylab = Ylab, line = 2)
  
  # get dimensions for plotting ####
  xx=par()
  nx = xx$usr[1]
  px = -xx$usr[1]
  ny = xx$usr[3]
  py = xx$usr[4]
  
  # some polygons to color each section differently ####
  if(bg.polys==TRUE){
    if(is.null(flip.colors)){
      polygon(x=c(0,0,px,px),y=c(py,0,0,py), col="#00FF0055") #
      polygon(x=c(0,0,nx,nx),y=c(ny,0,0,ny), col="#FF000055")
      polygon(x=c(0,0,px,px),y=c(ny,0,0,ny), col="#FFFF0055")
      polygon(x=c(0,0,nx,nx),y=c(py,0,0,py), col="#FFFF0055")
    }
    
    if(!is.null(flip.colors)){
      polygon(x=c(0,0,px,px),y=c(py,0,0,py), col="#FF000055")
      polygon(x=c(0,0,nx,nx),y=c(ny,0,0,ny), col="#00FF0055")
      polygon(x=c(0,0,px,px),y=c(ny,0,0,ny), col="#FFFF0055")
      polygon(x=c(0,0,nx,nx),y=c(py,0,0,py), col="#FFFF0055")
    }
  }
  # plot xy if there are no polygons ####
  if(bg.polys==FALSE){
    segments(nx,0,px,0) # X
    segments(0,ny,0,py) # Y
  }
  
  # add mean and 1 SD lines ####
  if(plot.type==1){
    mod = 0.95
    segments(-rng*mod,0,rng*mod,0,lwd=1)
    segments(0,-rng*mod,0,rng*mod, lwd=1)
    segments(-rng*mod,1,rng*mod,1, lty="dotted", lwd=1.5)
    segments(-rng*mod,-1,rng*mod,-1, lty="dotted", lwd=1.5)
    segments(-1,-rng*mod,-1,rng*mod, lty="dotted", lwd=1.5)
    segments(1,-rng*mod,1,rng*mod, lty="dotted",  lwd=1.5)
  }
  
  # plot errors if requested ####
  if(plot.type==2){
    if(!is.null(SE.d1)){ # for symetric errors
      SE.d1.up = d1 + SE.d1
      SE.d1.lo = d1 - SE.d1
    }
    if(!is.null(SE.d2)){# for symetric errors
      SE.d2.up = d2 + SE.d2
      SE.d2.lo = d2 - SE.d2
    } 
    # for asymetric errors
    if(is.null(SE.d1.up)){SE.d1.up = SE.d1.up}
    if(is.null(SE.d1.lo)){SE.d1.lo = SE.d1.lo}
    if(is.null(SE.d2.up)){SE.d2.up = SE.d2.up}
    if(is.null(SE.d2.lo)){SE.d2.lo = SE.d2.lo}
    
    # line colors
    if(!is.null(d1.col)){d1.col=d1.col}else{d1.col='grey30'}
    if(!is.null(d2.col)){d2.col=d2.col}else{d2.col='grey30'}
    d1.col = as.character(d1.col)
    d2.col = as.character(d2.col)
    lwd1 = ifelse(d1.col=="black",3,1)
    lwd2 = ifelse(d2.col=="black",3,1)
    # plot errors
    if(style==1){
      arrows(SE.d1.lo,d2,SE.d1.up,d2, col = d1.col, length=0, lwd=lwd1)
      # arrows(SE.d1.lo,d2,SE.d1.up,d2, col = d1.col, length=0)
      arrows(d1,SE.d2.lo,d1,SE.d2.up, col = d2.col, length=0, lwd=lwd2)
      # arrows(d1,SE.d2.lo,d1,SE.d2.up, col = d2.col, length=0)
    }
    if(style==2){
      arrows(SE.d2.lo,d1,SE.d2.up,d1, col = d2.col, length=0, lwd=lwd2)
      # arrows(SE.d2.lo,d1,SE.d2.up,d1, col = d2.col, length=0)
      arrows(d2, SE.d1.lo,d2,SE.d1.up, col = d1.col, length=0, lwd=lwd1)
      # arrows(d2, SE.d1.lo,d2,SE.d1.up, col = d1.col, length=0)
    }
  }  # end plot errors
  
  # re-graph the points so that they are on top ####
  if(is.na(Symbol[1])==TRUE & style==1){text(d1,d2, Label, cex=1.5)}
  if(is.na(Symbol[1])==TRUE & style==2){text(d2,d1, Label, cex=1.5)}
  # if(is.numeric(Symbol[1])==TRUE){if(max(Symbol)>20){col.1="black"}else{col.1=Color}}
  if(is.numeric(Symbol[1])==TRUE & style==1){points(d1,d2,pch=Symbol, col=ol.color, bg=bg.color, cex=PointCex)}
  if(is.numeric(Symbol[1])==TRUE & style==2){points(d2,d1,pch=Symbol, col=ol.color, bg=bg.color, cex=PointCex)}
  
  if(style==1){
    text(0, rng,"high & increasing", pos=4, cex=TextCex, offset = TextOffset)
    text(0, -rng,"low but increasing", pos=4, cex=TextCex, offset = TextOffset)
    text(0, rng,"high but decreasing", pos=2,cex=TextCex, offset = TextOffset)
    text(0, -rng,"low & decreasing", pos=2, cex=TextCex, offset = TextOffset)
  }
  if(style==2){
    text(0, rng,"high & increasing", pos=4, cex=TextCex, offset = TextOffset)
    text(0, -rng,"high but decreasing", pos=4, cex=TextCex, offset = TextOffset)
    text(0, rng,"low but increasing", pos=2, cex=TextCex, offset = TextOffset)
    text(0, -rng,"low & decreasing", pos=2, cex=TextCex, offset = TextOffset)
  }
  # if(style==1){
  #   text(par()$usr[2], rng,"high & increasing", pos=2, cex=TextCex)
  #   text(par()$usr[2], -rng,"low but increasing", pos=2, cex=TextCex)
  #   text(par()$usr[1], rng,"high but decreasing", pos=4,cex=TextCex)
  #   text(par()$usr[1], -rng,"low & decreasing", pos=4, cex=TextCex)
  # }
  # if(style==2){
  #   text(rng, rng,"high & increasing", pos=2, cex=TextCex)
  #   text(rng, -rng,"high but decreasing", pos=2, cex=TextCex)
  #   text(-rng, rng,"low but increasing", pos=4, cex=TextCex)
  #   text(-rng, -rng,"low & decreasing", pos=4, cex=TextCex)
  # }
  # title and legend ####	
  title(Title, cex.main=TitleCex, line=0.5)
  if(PlotLegend==TRUE){if(is.numeric(Symbol[1])==TRUE){legend(px+l.inset[1],py+l.inset[2],DF$timeseries, pch=Symbol, col=ol.color, pt.bg=bg.color,cex=LegendCex, bty="n", pt.cex=LegendPointCex)}}
  
  # update note on figure ####
  
  if(exists('note.update.status')==TRUE){
    if(note.update.status == TRUE){if(dframe$type[1] != 'current.data'){legend('center',legend='old data', bg='red')}else{
      legend('center',legend='new data', bg='green')}}
  }
 
  ############ PRODUCE ALTERNATE TEXT ###############
 
   if(!is.na(AltTxt)){  
    xy = data.frame(cbind(d1,d2))
    colnames(xy) <- c('x1', 'y1')
    xy$label = Label
    if(style==1){at1 = paste0("The figure shows a quad-plot of summarized time-series data. Each point represents one normalized time series. The x-axis shows whether the mean of the last ",PERIOD," ",Period.Label," was higher or lower than the mean of the full time series.  The y-axis shows whether the trend over the last ",PERIOD," ",Period.Label, " increased or decreased. ")}  
    if(style==2){at1 = paste0("The figure shows a quad-plot of summarized time-series data. Each point represents one normalized time series. The x-axis shows whether the trend over the last ",PERIOD," ",Period.Label," increased or decreased.  The y-axis shows whether the mean of the last ",PERIOD," ",Period.Label, " was higher or lower than the mean of the full time series. ")}
    
    at2 = paste("Both axes range between negative ",rng," and ",rng,". ",sep='')  
    
    # ABOVE text #################
    dfxy = xy[xy$y1>0 & xy$y1<=1,]
    # if(nrow(dfxy)==0){ab = "No time series was"}
    if(nrow(dfxy)==1){ab = dfxy$label}
    if(nrow(dfxy)==2){ab = paste(dfxy$label[1]," and ",dfxy$label[2], sep='')}
    if(nrow(dfxy)>2){
      no.yrs = nrow(dfxy)
      dfxy.first = dfxy$label[1]
      dfxy.last = dfxy$label[no.yrs]
      dfxy1 = dfxy.first
      for(i in 2:(no.yrs-1)){
        dfxy1 = paste(dfxy1,", ",dfxy$label[i], sep='')
      }
      ab = paste(dfxy1," and ",dfxy.last,sep = '')
    }
    if(nrow(dfxy)>0){ab.at = paste("For ",ab,", the mean of the last ",PERIOD," ",Period.Label," was greater than the mean of the full time series but by less than one standard deviation. ", sep='')}else{ab.at=""}
    
    ### ABOVE SD text #############
    dfxy = xy[xy$y1>1,]
    #if(nrow(dfxy)==0){absd = "No time series was"}
    if(nrow(dfxy)==1){absd = dfxy$label}
    if(nrow(dfxy)==2){absd = paste(dfxy$label[1]," and ",dfxy$label[2], sep='')}
    if(nrow(dfxy)>2){
      no.yrs = nrow(dfxy)
      dfxy.first = dfxy$label[1]
      dfxy.last = dfxy$label[no.yrs]
      dfxy1 = dfxy.first
      for(i in 2:(no.yrs-1)){
        dfxy1 = paste(dfxy1,", ",dfxy$label[i], sep='')
      }
      absd = paste(dfxy1," and ",dfxy.last,sep = '')
    }
    if(nrow(dfxy)>0){absd.at = paste("For ", absd,", the mean of the last ",PERIOD," ",Period.Label," was greater than the mean of the full time series by more than one standard deviation. ", sep='')}else{absd.at=""}
    
    # TREND Increase text #################
    dfxy = xy[xy$x1>0 & xy$x1<=1,]
    #if(nrow(dfxy)==0){tr = "No time series "}
    if(nrow(dfxy)==1){tr = dfxy$label}
    if(nrow(dfxy)==2){tr = paste(dfxy$label[1]," and ",dfxy$label[2],sep='')}
    if(nrow(dfxy)>2){
      no.yrs = nrow(dfxy)
      dfxy.first = dfxy$label[1]
      dfxy.last = dfxy$label[no.yrs]
      dfxy1 = dfxy.first
      for(i in 2:(no.yrs-1)){
        dfxy1 = paste(dfxy1,", ",dfxy$label[i], sep='')
      }
      tr = paste(dfxy1," and ",dfxy.last,sep = '')
    }
    if(nrow(dfxy)>0){tru.at = paste("For ", tr,", the trend over the last ",PERIOD," ",Period.Label," increased but by less than one standard deviation of the full time series. ", sep='')}else{tru.at=""}
    
    ### TREND Increase SD text #############
    dfxysd = xy[xy$x1>1,]
    #if(nrow(dfxysd)==0){trsd = "No time series"}
    if(nrow(dfxysd)==1){trsd = dfxy$label}
    if(nrow(dfxysd)==2){trsd = paste(dfxy$label[1]," and ",dfxy$label[2],sep='')}
    if(nrow(dfxysd)>2){
      no.yrs = nrow(dfxysd)
      dfxy.first = dfxysd$label[1]
      dfxy.last = dfxysd$label[no.yrs]
      dfxy1 = dfxy.first
      for(i in 2:(no.yrs-1)){
        dfxy1 = paste(dfxy1,", ",dfxysd$label[i], sep='')
      }
      trsd = paste(dfxy1," and ",dfxy.last,sep = '')
      
    }  
    if(nrow(dfxy)>0){trusd.at = paste("For ", tr,", the trend over the last ",PERIOD," ",Period.Label," increased by more than one standard deviation of the full time series. ", sep='')}else{trusd.at=""}
    
    # BELOW text #################
    dfxy = xy[xy$y1<0 & xy$y1>= -1,]
    #if(nrow(dfxy)==0){ab = "No time series was"}
    if(nrow(dfxy)==1){ab = paste(dfxy$label, "was", sep='')}
    if(nrow(dfxy)==2){ab = paste(dfxy$label[1]," and ",dfxy$label[2], " were ", sep='')}
    if(nrow(dfxy)>2){
      no.yrs = nrow(dfxy)
      dfxy.first = dfxy$label[1]
      dfxy.last = dfxy$label[no.yrs]
      dfxy1 = dfxy.first
      for(i in 2:(no.yrs-1)){
        dfxy1 = paste(dfxy1,", ",dfxy$label[i], sep='')
      }
      ab = paste(dfxy1," and ",dfxy.last,sep = '')
      
    }
    if(nrow(dfxy)>0){bl.at = paste(ab," less the mean of the full time series but by less than one standard deviation. ", sep='')}else{bl.at=""}
    
    ### BELOW SD text #############
    dfxy = xy[xy$y1< (-1),]
    #if(nrow(dfxy)==0){absd = "No time series was"}
    if(nrow(dfxy)==1){blsd = paste(dfxy$label, "was", sep='')}
    if(nrow(dfxy)==2){blsd = paste(dfxy$label[1]," and ",dfxy$label[2], " were ", sep='')}
    if(nrow(dfxy)>2){
      no.yrs = nrow(dfxy)
      dfxy.first = dfxy$label[1]
      dfxy.last = dfxy$label[no.yrs]
      dfxy1 = dfxy.first
      for(i in 2:(no.yrs-1)){
        dfxy1 = paste(dfxy1,", ",dfxy$label[i], sep='')
      }
      blsd = paste(dfxy1," and ",dfxy.last,sep = '')
      
    }
    if(nrow(dfxy)>0){blsd.at = paste(blsd," less than the mean of the full time series by more than one standard deviation. ", sep='')}else{blsd.at=""}
    
    # TREND Decrease text #################
    dfxy = xy[xy$x1<0 & xy$x1>= -1,]
    #if(nrow(dfxy)==0){tr = "No time series "}
    if(nrow(dfxy)==1){tr = dfxy$label}
    if(nrow(dfxy)==2){tr = paste(dfxy$label[1]," and ",dfxy$label[2],sep='')}
    if(nrow(dfxy)>2){
      no.yrs = nrow(dfxy)
      dfxy.first = dfxy$label[1]
      dfxy.last = dfxy$label[no.yrs]
      dfxy1 = dfxy.first
      for(i in 2:(no.yrs-1)){
        dfxy1 = paste(dfxy1,", ",dfxy$label[i], sep='')
      }
      tr = paste(dfxy1," and ",dfxy.last,sep = '')
      
    }
    if(nrow(dfxy)>0){trd.at = paste(tr," decreased over the evaluation period but by less than one standard deviation of the full time series. ", sep='')}else{trd.at=""}
    ### TREND Decrease SD text #############
    dfxy = xy[xy$x1< (-1),]
    #if(nrow(dfxy)==0){trsd = "No time series"}
    if(nrow(dfxy)==1){trsd = dfxy$label}
    if(nrow(dfxy)==2){trsd = paste(dfxy$label[1]," and ",dfxy$label[2],sep='')}
    if(nrow(dfxy)>2){
      no.yrs = nrow(dfxysd)
      dfxy.first = dfxysd$label[1]
      dfxy.last = dfxysd$label[no.yrs]
      dfxy1 = dfxy.first
      for(i in 2:(no.yrs-1)){
        dfxy1 = paste(dfxy1,", ",dfxysd$label[i], sep='')
      }
      trsd = paste(dfxy1," and ",dfxy.last,sep = '')
      
    }  
    if(nrow(dfxy)>0){trdsd.at = paste(trsd," decreased over the evaluation period by more than one standard deviation of the full time series. ", sep='')}else{trdsd.at=""}
    
    ##### put together alt text ####
    
    AltText = paste0(at1, at2, ab.at, absd.at, bl.at, blsd.at, tru.at, trusd.at, trd.at, trdsd.at)
    AltText
    
    prefix= opts_current$get()$label
    if(is.null(prefix)){prefix <- "X"}
    
    file.name = paste(AltTxt,"QuadPlot_",prefix,"_",style,"_",Title,"_alt.txt", sep='')
    fileConn<-file(file.name)
    writeLines(AltText, fileConn)
    close(fileConn)
  } # end AltText
} #end function


###########


