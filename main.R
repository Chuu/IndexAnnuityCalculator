
getPositiveRate <- function(from, to, cap, dataSource)
{
  rate <- ((getClose(to, dataSource) - getClose(from, dataSource))
         /getClose(from, dataSource));
  
  if(rate < 0) { return(0); }
  
  return(min(rate, cap));
  
}

getClose <- function(inDate, dataSource)
{
   return(dataSource[date==inDate, price]);
}

GetEightYearRate <- function(startDate, initialBonusPercentage, minRate, cap, dataSource)
{
  currentMultiplier <- initialBonusPercentage;
  startDate = max(as.POSIXlt(dataSource[1, date]), as.POSIXlt(startDate));
    
  for(i in seq(0, 3))
  {
     currentPeriodBeginDate <- startDate;
     currentPeriodBeginDate$year <- currentPeriodBeginDate$year + i*2;
     currentPeriodEndDate <- currentPeriodBeginDate;
     currentPeriodEndDate$year <- currentPeriodEndDate$year + 2;
     
     currentMultiplier <- currentMultiplier * (1 + getPositiveRate(
       as.Date(currentPeriodBeginDate), as.Date(currentPeriodEndDate), cap, dataSource));
  }
  
  currentMultiplier <- max(currentMultiplier, initialBonusPercentage*(1+minRate)^8)
  return(currentMultiplier^(1/8)-1);
}

GetESData <- function(startDate, endDate)
{
  library(quantmod);
  library(data.table);
  getSymbols("^GSPC", src="yahoo", from=startDate, to=endDate);
  
  #If we start on a weekend, extend the date
  startDate <- first(index(GSPC));
  
  dates <- seq(as.Date(startDate), as.Date(endDate), by=1);
  closes <- numeric(length(dates));
  
  for(i in seq(1, length(dates)))
  {
    for(j in seq(0, 100))
    {
      candidate <- as.numeric(GSPC[as.Date(dates[i-j]), 4])
      if(length(candidate) > 0) 
      { 
        closes[i] = candidate;
        break;
      }
    }
  }
  
  returnMe = data.table(date=dates, price=closes);
  setkey(returnMe, date);
  return(returnMe);
}

startDate <- as.Date('1970-01-01');
endDate <- as.Date('2014-11-14');
dates <- as.Date(startDate:endDate);
ES <- GetESData(startDate, Sys.Date());

#rates <- sapply(dates, function(x) { GetEightYearRate(x, 1.025, 0.01, 0.075, ES)})
#rates2 <- sapply(dates, function(x) { GetEightYearRate(x, 1.00, 0.01, 0.095, GSPC)})
