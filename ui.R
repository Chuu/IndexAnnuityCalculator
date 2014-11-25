library(shiny)
library(ggplot2)

shinyUI(fluidPage(
  titlePanel("Index Annutiy Calculator /w Biennial S&P500 Indexing"),
  sidebarLayout(
    sidebarPanel(
          numericInput("gRate", "Gaurenteed Minimum Interest Rate", 0.0055, min=0, max=NA, step=0.0001),
          numericInput("biRate", "Biennual Interest Rate Cap", 0.08, min=0, max=NA, step=0.001),
          numericInput("bonusRate", "Initial Premium Bonus Percentage", 0.05, min=0, max=NA, step=0.001),
          dateRangeInput("dateRange", "Policy Start Dates", 
                         start="1995-01-01", end="2006-11-23", min="1970-01-01", max="2006-11-23"),
          submitButton()
    ),
    mainPanel(
      textOutput("t1"),
      textOutput("t2"),
      plotOutput("plot"))
    )
  )
)
