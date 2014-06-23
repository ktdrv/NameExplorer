shinyUI(fluidPage(
  
  # Application title
  titlePanel("Name Explorer"),
            
  h5("This Shiny application will allow you to explore the popularity of baby names in America, starting in 1880."),
  p("To get started, wait a little for the dataset to be loaded and then enter a name and year range below."),
  p("Note: The initial loading of the dataset takes a little while. Please be patient."),
  
  sidebarLayout(
  
    sidebarPanel(
      
      textInput("name", label = "Name", value = "John"),
      
      #checkboxInput(inputId = "separate_sexes",
      #             label = strong("Separate male and female"),
      #             value = TRUE),
      
      numericInput('from_year', 'Starting from year', 1880, min = 1880, max = 2013, step = 1),
      numericInput('to_year', 'Till year', 2013, min = 1880, max = 2013, step = 1),
      
      submitButton('Go!')
    ),
    
    mainPanel(
      plotOutput(outputId = "count_plot", height = "400px"),
      plotOutput(outputId = "rank_plot", height = "400px")
    )
    
  ),
  
  p("The data comes from the ", a("SSA website", href = "http://www.ssa.gov/oact/babynames"), ".")
  
))

