library(data.table);
library(quantmod);

ES <- as.data.table(readRDS("ES.rds"));

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