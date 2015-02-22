library(shiny)
library(ggvis)

shinyUI(
  navbarPage("Movie charts",

  tabPanel("Ratings",
    fluidRow(
    
      column(3,
             wellPanel(
               h4("Filters"),
               sliderInput("movienumber", "Number of movies", 30, 250, 200)
             ),
             wellPanel(
               h4("Axes"),
               selectInput("xaxis", "Choose X axis:", 
                           choices = c("IMDB rating", "Rotten Tomatoes user rating", "Rotten Tomatoes rating", "Tomatometer", "Year released")),
               selectInput("yaxis", "Choose Y axis:", 
                           choices = c("Rotten Tomatoes rating", "Rotten Tomatoes user rating", "Tomatometer", "Year released", "IMDB rating")),
               selectInput("bubblesize", "Choose bubble size", 
                           choices = c("No. of IMDB votes", "No. of Rotten Tomatoes ratings", "Metascore")),
               selectInput("colorv", "Choose coloring method", 
                           choices = c("MPAA rating", "Year released", "Decade released"))
             )
      ),
      
      column(9,
             htmlOutput("view")
      )
    )),
  
    tabPanel("Box office",
       fluidRow(
         
         column(3,
                wellPanel(
                  h4("Filters"),
                  selectInput("boxxaxis", "Choose X axis:", 
                              choices = c("IMDB rating", "Rotten Tomatoes user rating", "Rotten Tomatoes rating", "Tomatometer", "Year released"))
                )
         ),
         
         column(9,
                htmlOutput("boxofficeview")
         )
       )
    )
  )
)