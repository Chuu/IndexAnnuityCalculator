source("import.R")

shinyServer(function(input, output) {  
  
    dataInput <- reactive({
      startDate <- as.Date(input$dateRange[1], origin='1970-01-01');
      endDate <- as.Date(input$dateRange[2], origin='1970-01-01');
      dates <- as.Date(startDate:endDate, origin='1970-01-01');
      
      data <- ES;
      bonusRate <- 1 +input$bonusRate;
      gRate <- input$gRate;
      biRate <- input$biRate;
      
      rates <- sapply(dates, function(x) { GetEightYearRate(x, bonusRate, gRate, biRate, data) });
      return(data.frame(date=dates, rate=rates));
    })
  
    
    output$plot <- renderPlot({
        qplot(date, rate, data=dataInput(), xlab="Date of Purchase", ylab="Equivalent Fixed Interest Rate");
      });
      
  })