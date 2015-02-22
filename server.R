library(jsonlite)
library(googleVis)
library(shiny)

movies <- fromJSON(txt="movies.json")

# year
movies[,2] <- as.numeric(movies[,2])
# metascore
movies[,15] <- as.numeric(movies[,15])
# imdb rating
movies[,16] <- as.numeric(movies[,16])
# imdb votes
movies[,17] <- as.numeric(gsub(",", "", movies[,17]))
size <- (movies[,17] - min(movies[,17])) / max(movies[,17])
size <- round(size * 20 + 3)
movies[,35] <- size
# tomatometer
movies[,20] <- as.numeric(movies[,20])
# tomato rating
movies[,22] <- as.numeric(movies[,22])
# tomato user rating
movies[,28] <- as.numeric(movies[,28])

shinyServer(function(input, output) {
  
  datasetInput <- reactive({
    switch(input$dataset,
           "imdb" = movies[,c(2,16)],
           "meta" = movies[,c(2,15)])
  })
  
  number <- reactive({
    input$movienumber
  })
  
  xaxis <- reactive({
    switch(input$xaxis,
           "IMDB rating" = "imdbRating", 
           "Rotten Tomatoes user rating" = "tomatoUserRating", 
           "Rotten Tomatoes rating" = "tomatoRating", 
           "Tomatometer" = "tomatoMeter", 
           "Year released" = "Year")
  })
  
  yaxis <- reactive({
    switch(input$yaxis,
           "IMDB rating" = "imdbRating", 
           "Rotten Tomatoes user rating" = "tomatoUserRating", 
           "Rotten Tomatoes rating" = "tomatoRating", 
           "Tomatometer" = "tomatoMeter", 
           "Year released" = "Year")
  })
  
  output$view <- renderGvis({
    # only the selected amount of movies
    data <- movies[1:number(),]

    gvisBubbleChart(data,
                    idvar="Title",
                    xvar=xaxis(),
                    yvar=yaxis(),
                    sizevar="V35",
                    colorvar="Rated",
                    options=list(height=950,
                                 fontSize=10))
  })
})