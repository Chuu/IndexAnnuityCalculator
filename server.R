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
      
      iteration <- 1;
      
      withProgress(message = 'Calculating Rates', value = 0, 
      {
        rates <- sapply(dates, function(x) {
            iteration <<- iteration + 1;
            setProgress(iteration/length(dates), detail=paste0(x));
            return(GetEightYearRate(x, bonusRate, gRate, biRate, data));
          });
      });
      
      return(data.frame(date=dates, rate=rates));
    })
  
    
    output$plot <- renderPlot({
        qplot(date, rate, data=dataInput(), xlab="Date of Purchase", ylab="Equivalent Fixed Interest Rate", 
              main="Equivalent Fixed Interest Rate for 8-Year Policy");
      });
    
    output$sortedPlot <- renderPlot({
      sortOrder <- order(dataInput()$rate);
      qplot(seq(length(dataInput()$rate)), dataInput()$rate[sortOrder], xlab="Index", ylab="Equivalent Fixed Interest Rate",
            main="Equivalent Fixed Interest Rates -- Sorted by Rate");
    })
    
    output$mean <- renderText({paste("Average:", sprintf('%.3f%%', 100 * mean(dataInput()$rate)))});
    
    output$min <- renderText({ paste("Min:", sprintf('%.3f%%', 100 * min(dataInput()$rate)))});
    output$ten <- renderText({ paste("10th Qtile:", sprintf('%.3f%%', 100 * quantile(dataInput()$rate, .1)))});
    output$ninty <- renderText({ paste("90th Qtile:", sprintf('%.3f%%', 100 * quantile(dataInput()$rate, .9)))});
    output$max <- renderText({ paste("Max:", sprintf('%.3f%%', 100 * max(dataInput()$rate)))});
    
    output$table <- renderDataTable({
      as.data.table(dataInput());
    });
      
  })