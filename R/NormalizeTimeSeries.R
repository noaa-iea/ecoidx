#' Normalize Time Series
#'
#' @param X time as year, year-month or year-month-day
#' @param Y value to plot over time
#' @param Name title of plot
#'
#' @return
#' @export
#'
#' @examples
GetNorm <- function(X,Y,Name){
  #X = x_1  # for testing code
  #Y = y_1  # for testing code
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
#    y1 = Y[match(xeval,x):length(Y)]

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
	results <- data.frame(cbind(name1, mn,stdev, mn5, slope, diff))
	return(results)

	}



