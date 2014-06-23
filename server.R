library(plyr)
library(ggplot2)
library(shiny)

filenames <- list.files(path="names", pattern="yob[[:digit:]]+.txt", full.names=T)
data <- ldply(.data=filenames, 
              .fun=function (fname) {
                t <- read.csv(file=fname, header=F, sep=",", col.names=c('Name', 'Sex', 'Count'), colClasses=c("character", "factor", "numeric"))
                # t <- subset(t, subset=t$Count >= 100)
                t <- ddply(.data=t, .variables=c("Sex"), transform, Rank = rank(-Count, ties.method="min"), Name=tolower(Name))
                y <- as.numeric(regmatches(fname, regexpr("([[:digit:]]{4})", fname)))
                t$Year = rep(y, nrow(t))
                t
              })

shinyServer(function(input, output) {
  
  output$count_plot <- renderPlot({
    
    d <- subset(data, data$Name==tolower(input$name) & data$Year >= input$from_year & data$Year <= input$to_year)
    
    ggplot(d, aes(x=Year, y=Count, fill=Sex)) + 
      geom_area(position = 'stack') + 
      ylab(paste("Babies named", input$name)) + xlab("Year")
    
  })
  
  output$rank_plot <- renderPlot({
    
    d <- subset(data, data$Name==tolower(input$name) & data$Year >= input$from_year & data$Year <= input$to_year)
    
    ggplot(d, aes(x=Year, y=Rank, color=Sex)) + 
      geom_line() + facet_grid(. ~ Sex, scales="free_y") + 
      scale_y_log10(limit=c(1, 10000), breaks=c(1, 10, 100, 1000, 10000, 10000)) + 
      ylab("Rank of name") + xlab("Year")
    
  })
  
})


