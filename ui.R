library(shiny)
library(plotly)
library(car)

shinyUI(fluidPage(
  
  sidebarLayout(
    sidebarPanel(
       h3("User Entered Values"),
       h3("(Model Covariables)"),
       sliderInput("AFR",
                   "Adolescent (ages 15-19) Fertility Rate (# births/1,000 population/year):",
                   min = 2,
                   max = 230,
                   value = 60),
       sliderInput("BR",
                   "Birth Rate (# births/1,000 population/year):",
                   min = 8,
                   max = 55,
                   value = 25),
       sliderInput("POL",
                   "% of children (12-23 months) immunized for polio:",
                   min = 1,
                   max = 99,
                   value = 80),
       sliderInput("SEC",
                   "% of secondary school aged children enrolled:",
                   min = 1,
                   max = 99,
                   value = 70),
       sliderInput("UPG",
                   "Urban population growth (annual %):",
                   min = -3,
                   max = 17,
                   value = 2)
    ),
    mainPanel(
       h3("Model Predicted Life Expectancy (Orange Bar)"),
       h3("Plotted Along with National Averages of Life Expectancy (Blue Bars)"),
       h3("Instructions for Use:"),
       h4("- Using the sliders at left, select desired values for each given population characteristic."),
       h4("- Life Expectancy prediction is shown as an orange bar."),
       h4("- Means of Life Expectancy for each country are shown as blue bars."),
       h4("- More information is available by hovering over the data points."),
       plotlyOutput("distPlot")
    )
  )
))
