library(shiny)
library(shinyAce)

# shinyAce allows us to read in source files and display it in the shiny webapp
sourceCode <- list(
  aceEditor("dataretrieval",
            value = paste(readLines("getData.R"), collapse="\n"),
            mode = "r",
            theme = "ambience",
            height = "400px",
            readOnly = TRUE
  )
)


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
                  h4("Axes"),
                  selectInput("boxxaxis", "Choose X axis:", 
                              choices = c("IMDB rating", "Rotten Tomatoes user rating", "Rotten Tomatoes rating", "Tomatometer", "Year released"))
                ),
                wellPanel(
                  h4("Data"),
                  checkboxInput("trendcheckbox", "Add linear trendline", FALSE)
                ),
                conditionalPanel(
                  condition = "input.trendcheckbox == true",
                  wellPanel(
                    numericInput("uservalue", label ="X value to predict with (on the X scale, selected above)", value = 9.5),
                    "Predicted Y value (earnings) based on the linear model:",
                    verbatimTextOutput("calculatedvalue"),
                    "In US dollars."
                  )
                )
         ),
         
         column(9,
                htmlOutput("boxofficeview")
         )
       )
    ),
  
    tabPanel("Data retrieval",
             "This webapp doesn't use 'live' data but a saved version of the IMDB top250 instead.",
             br(),br(),
             "The reasons for this is 1) because IMDB does not provide a proper API to access data 2) the alternative API, called OMDB is very-very slow at this 
             moment - querying 250 movies can take more than a minute.",
             br(),br(),
             "Below you can find the code used to retrieve the data. First, it reads in the top250 movie CSV file. This data can be accessed via a public IMDB FTP server, 
             where they dump the archives regularly (welcome to the '90s). Once this file is loaded, the algorithm below queries the OMDB API to ge the latest data 
             on these movies and as well to get the Rotten Tomatoes data. Once the query is done, it can be saved into a data.frame or a JSON.",
             br(),br(),
             "Both the code and the data is included with this shiny app's",
             a("GitHub repo", href="https://github.com/Oszkar/developingdataproductsclass"),
             br(),hr(),br(),
             sourceCode
    ),
    
    tabPanel("Data",
             "Below you can find the whole data set (except of the poster link, plot description and Rotten Tomatoe consensus which would clutter the table even more)",
             br(),
             "A global search can be found at the top, a more detailed search at the bottom",
             hr(),
             dataTableOutput(outputId="table")
    ),
  
    tabPanel("Data dowload",
      "By clicking the button below, you can download the IMDB top250 data this webapp uses.",
      br(),br(),
      downloadButton('downloadData', 'Download')
    ),
    
    tabPanel("Help / Manual",
             "asdasdasd"
    )
  )
)