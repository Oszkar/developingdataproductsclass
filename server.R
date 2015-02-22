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
# tomatometer
movies[,20] <- as.numeric(movies[,20])
# tomato rating
movies[,22] <- as.numeric(movies[,22])
# tomato user rating
movies[,28] <- as.numeric(movies[,28])
# number of tomato user rating
movies[,29] <- as.numeric(gsub(",", "", movies[,29]))
# insert 0 instead of NA
movies[is.na(movies[,29]),29] <- 0
# decade
movies[,35] <- movies$Year - movies$Year %% 10
# add a name to the decade variable too
colnames(movies)[35] = "decade"

# second data frame only for the movies that contain Box Office data
movieswithBO <- movies[-which(movies$BoxOffice == "N/A"),]

convertDollarToNumeric <- function(item) {
  # first, remove dollar sign
  item <- sub('\\$','',item) 
  # check the last character
  if(substr(item, nchar(item), nchar(item)) == "M") {
    # then millions
    item <- as.numeric(substr(item, 1, nchar(item)-1)) * 1000000
  } else {
    # else thousands
    item <- as.numeric(substr(item, 1, nchar(item)-1)) * 1000
  }
  return(item)
}

movieswithBO[,35] <- as.numeric(sapply(movieswithBO$BoxOffice, convertDollarToNumeric))

colnames(movieswithBO)[35] = "Earnings"
movieswithBO$Earnings.html.tooltip <- movieswithBO$Title

shinyServer(function(input, output) {
  
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
  
  bubblesize <- reactive({
    switch(input$bubblesize,
           "No. of IMDB votes" = "imdbVotes",
           "No. of Rotten Tomatoes ratings" = "tomatoUserReviews",
           "Metascore" = "Metascore")
  })
  
  colorv <- reactive({
    switch(input$colorv,
           "MPAA rating" = "Rated",
           "Year released" = "Year",
           "Decade released" = "decade"
    )
  })
  
  boxxaxis <- reactive({
    switch(input$boxxaxis,
           "IMDB rating" = 16, 
           "Rotten Tomatoes user rating" = 28, 
           "Rotten Tomatoes rating" = 22, 
           "Tomatometer" = 20, 
           "Year released" = 2)
  })
  
  output$view <- renderGvis({
    # only the selected amount of movies
    data <- movies[1:number(),]

    gvisBubbleChart(data,
                    idvar="Title",
                    xvar=xaxis(),
                    yvar=yaxis(),
                    sizevar=bubblesize(),
                    colorvar=colorv(),
                    options=list(height=950,
                                 fontSize=10))
  })
  
  output$boxofficeview <- renderGvis({
    gvisScatterChart(movieswithBO[,c(boxxaxis(), 35, 36)], options=list(height=950,fontSize=10))
  })
})