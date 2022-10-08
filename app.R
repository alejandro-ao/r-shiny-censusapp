#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(maps)
library(mapproj)
source("./helpers.R")

counties <- readRDS("./data/counties.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("US Census 2010: Ethnicity"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          helpText("Create demographic maps with 
               information from the 2010 US Census."),
          selectInput("ethnicity",
                      label = "Choose a variable to display",
                      choices = c("Percent White", 
                                  "Percent Black",
                                  "Percent Hispanic", 
                                  "Percent Asian"),
                      selected = "Percent White"),
          sliderInput("range",
                      label = "Range of interest:",
                      min=0, max=100, value=c(0,100))
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("map")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
    output$map <- renderPlot({
      
      # select the data
      data <- switch(input$ethnicity,
                     "Percent White" = counties$white,
                     "Percent Black" = counties$black,
                     "Percent Hispanic" = counties$hispanic,
                     "Percent Asian" = counties$asian
                     )
      
      color <- switch(input$ethnicity, 
                      "Percent White" = "darkgreen",
                      "Percent Black" = "black",
                      "Percent Hispanic" = "darkorange",
                      "Percent Asian" = "darkviolet"
                      )
      
      legend <- switch(input$ethnicity, 
                       "Percent White" = "% White",
                       "Percent Black" = "% Black",
                       "Percent Hispanic" = "% Hispanic",
                       "Percent Asian" = "% Asian"
                       )
      
      percent_map(data, color, legend, input$range[1], input$range[2])
    })
    
    

    # output$distPlot <- renderPlot({
    #     # generate bins based on input$bins from ui.R
    #     x    <- faithful[, 2]
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white',
    #          xlab = 'Waiting time to next eruption (in mins)',
    #          main = 'Histogram of waiting times')
    # })
}

# Run the application 
shinyApp(ui = ui, server = server)
