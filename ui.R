library(shiny)
library(ggplot2)

shinyUI(
  
  navbarPage("Index Annuity Calculator",
    tabPanel("Application", 
      fluidPage(
      titlePanel("8-Year Index Annuity Calculator /w Biennial S&P500 Indexing"),
      sidebarLayout(
        sidebarPanel(
              numericInput("gRate", "Guaranteed Minimum Interest Rate", 0.0055, min=0, max=NA, step=0.0001),
              numericInput("biRate", "Biennial Interest Rate Cap", 0.08, min=0, max=NA, step=0.001),
              numericInput("bonusRate", "Initial Premium Bonus Percentage", 0.05, min=0, max=NA, step=0.001),
              dateRangeInput("dateRange", "Policy Start Dates", 
                             start="1999-12-31", end="2000-12-31", min="1970-01-01", max="2006-11-23",
                             startview="decade"),
              submitButton()
        ),
        mainPanel(
          plotOutput("plot"),
          plotOutput("sortedPlot"),
          textOutput("mean"),
          textOutput("min"),
          textOutput("ten"),
          textOutput("ninty"),
          textOutput("max"),
          textOutput("summary"),
          dataTableOutput("table"))
        )
      )
    ),
    tabPanel("Documentation",
             includeHTML("helpfile.html"))
  )
)
