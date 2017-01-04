library(shiny)
library(plotly)
library(car)

shinyServer(function(input, output) {
  output$distPlot <- renderPlotly({
    
    NatMeans <- readRDS("LifeExpMeans.rds")
    NatMeans$Rank <- rank(NatMeans$Life.Exp)

    PredLifeExp <- (69.113829 - 0.021301*input$AFR - 0.428352*input$BR + 
                            0.026001*input$POL + 0.103180*input$SEC + 
                            0.580104*input$UPG)
    
    if(PredLifeExp > max(NatMeans$Life.Exp)) {
            PredLifeExp <- max(NatMeans$Life.Exp)
    }
    
    if(PredLifeExp < min(NatMeans$Life.Exp)) {
            PredLifeExp <- min(NatMeans$Life.Exp)
    }

    FindRank <- mean(NatMeans$Rank[round(NatMeans$Life.Exp)==round(PredLifeExp)])
    
    plot_ly(NatMeans, x = ~Rank, y = ~Life.Exp, text = ~Country.Name, 
                 type = 'bar', name = 'National Mean') %>%
            add_trace(x = FindRank, y = PredLifeExp, 
                      name = 'Prediction', text = "") %>%
            layout(xaxis = list(title = "Rank Among Nations Plotted"), 
                       yaxis = list(title = "Life Expectancy (Years)"))
  })
})