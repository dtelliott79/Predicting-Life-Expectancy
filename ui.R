library(shiny)
library(plotly)
library(car)

shinyUI(fluidPage(
  
  sidebarLayout(
    sidebarPanel(
       h3("User Entered Values"),  
       sliderInput("AFR",
                   "Adolescent Fertility Rate (number of live births by women ages 15-19 per 1,000 population per year):",
                   min = 2,
                   max = 230,
                   value = 60),
       sliderInput("BR",
                   "Birth Rate (number of live births per 1,000 population per year):",
                   min = 8,
                   max = 55,
                   value = 25),
       sliderInput("POL",
                   "% of children (12-23 months) immunized for polio:",
                   min = 1,
                   max = 99,
                   value = 80),
       sliderInput("SEC",
                   "% of children enrolled in secondary school to children secondary school aged:",
                   min = 3,
                   max = 160,
                   value = 70),
       sliderInput("UPG",
                   "Urban population growth (annual %):",
                   min = -3,
                   max = 17,
                   value = 2)
    ),
    mainPanel(
       h3("Predicted Life Expectancy Plotted Against National Averages Worldwide"),
       plotlyOutput("distPlot"),
       h4("- Using the sliders, select desired values for each given characteristic."),
       h4("- The resulting Life Expectancy prediction is shown as an orange bar overlayed on means of Life Expectancy for each country."),
       h4("- More information is available by hovering over the data points.")
    )
  )
))
