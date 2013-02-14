library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Stage-structured population model"),
  
  sidebarPanel(
    sliderInput("fc2", "Fecundity: class 2",
                min = 0, max=1000, value=0),
    sliderInput("fc3", "Fecundity: class 3",
                min = 0, max=1000, value=0),
    sliderInput("fc4", "Fecundity: class 4",
                min = 0, max=1000, value=100),
    sliderInput("tp1", "Survival from class 1 to 2",
                min = 0.001, max=1, value=0.1),
    sliderInput("tp2", "Survival from class 2 to 3",
                min = 0.001, max=1, value=0.5),
    sliderInput("tp3", "Survival from class 3 to 4",
                min = 0.001, max=1, value=0.9),
    sliderInput("sp4", "Survival of class 4",
                min = 0.001, max=1, value=0.7),
    sliderInput("timesteps", "Number of time steps",
                min = 2, max=100, value=50)
    ), 
  mainPanel(
    plotOutput("plot"),
    h3("Leslie matrix"),
    tableOutput("Lesliemat"),
    h3("Elasticity matrix"),
    tableOutput("elastTab")
    )
  )
)
