#library(quantmod)
#getSymbols("^GSPC", src="yahoo", from='1970-01-01')

getPositiveRate <- function(from, to, cap, dataSource)
{
  rate <- ((getClose(to, dataSource) - getClose(from, dataSource))
         /getClose(from, dataSource));
  
  if(rate < 0) { return(0); }
  
  return(min(rate, cap));
  
}

getClose <- function(date, dataSource)
{
   for(i in seq(0, 100))
   {
     candidate <- as.numeric(dataSource[as.Date(date)-i, 4])
     if(length(candidate) > 0) { return(candidate); }
   }
}

GetEightYearRate <- function(startDate, initialBonusPercentage, minRate, cap, dataSource)
{
  currentMultiplier <- initialBonusPercentage;
  startDate = as.POSIXlt(startDate);
    
  for(i in seq(0, 3))
  {
     currentPeriodBeginDate <- startDate;
     currentPeriodBeginDate$year <- currentPeriodBeginDate$year + i*2;
     currentPeriodEndDate <- currentPeriodBeginDate;
     currentPeriodEndDate$year <- currentPeriodEndDate$year + 2;
     
     currentMultiplier <- currentMultiplier * (1 + getPositiveRate(
       currentPeriodBeginDate, currentPeriodEndDate, cap, dataSource));
  }
  
  currentMultiplier <- max(currentMultiplier, initialBonusPercentage*(1+minRate)^8)
  return(currentMultiplier^(1/8)-1);
}

startDate <- as.Date('1970-01-02');
endDate <- as.Date('2006-11-15');
dates <- startDate + (startDate:endDate);

rates <- sapply(dates, function(x) { GetEightYearRate(x, 1.05, 0.01, 0.075, GSPC)})
rates2 <- sapply(dates, function(x) { GetEightYearRate(x, 1.00, 0.01, 0.095, GSPC)})
