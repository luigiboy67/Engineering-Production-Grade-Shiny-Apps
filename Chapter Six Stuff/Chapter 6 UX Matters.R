# if people cannot understand how to use your application, or if your application front-end does not work at all, your application is not successful no matter how innovative and incredible the computation algorithms in the back-end are.

# by neglecting the UI and the UX, you will make your application less likely to be adopted among your users, which is a good way to fail your application project.

# interfaces should be as self-explanatory as possible

library(shiny)
ui <- function(){
  tagList(
    # Designing an interface that lets the 
    # user select a species from iris, 
    # then display a plot() of this dataset
    selectInput(
      "species", 
      "Choose one or more species",
      choices = unique(iris$Species),
      multiple = TRUE, 
      selected = unique(iris$Species)[1]
    ), 
    plotOutput("plot")
  )
}

server <- function(
    input, 
    output, 
    session
){
  # Taking the species as input, and returning the plot 
  # of the filtered dataset
  output$plot <- renderPlot({
    plot(
      iris[ iris$Species %in% input$species, ]
    )
  })
}

shinyApp(ui, server)

# Adopt a defensive programming mindset

# you should always fail gracefully and informatively

# once the app has failed, there is no easy way to natively get it back to the moment just before it crashed

# wrap all server calls in some form of try-catch

library(shiny)
ui <- function(){
  # Here, we would define the interface
  tagList(
    # [...]
  )
}

server <- function(
    input, 
    output, 
    session
){
  # We are attempting to connect to the database, 
  # using a `connect_db()` connection
  conn <- attempt::attempt({
    connect_db()
  })
  # if ever this connection failed, we notify the user 
  # about this failed connection, so that they can know
  # what has gone wrong
  if (attempt::is_try_error(conn)){
    # Notify the user
    send_notification("Could not connect")
  } else {
    # Continue computing if the connection was successful
    continue_computing()
  }
}

shinyApp(ui, server)

# If there is a progression in your app, you should design a clear pattern of moving forward

# When building your app, you should make sure that if an input is necessary, it is made clear inside the app that it is

with_red_star("Enter your name here")

library(shiny)
library(shinyFeedback)

ui <- function(){
  tagList(
    # Attaching the {shinyFeedback} dependencies
    useShinyFeedback(),
    # Recreating our selectInput + plot from before
    selectInput(
      "species", 
      "Choose one or more species",
      choices = unique(iris$Species),
      multiple = TRUE, 
      selected = unique(iris$Species)[1]
    ), 
    plotOutput("plt")
  )
}

server <- function(
    input, 
    output, 
    session
){
  output$plt <- renderPlot({
    # If the length of the input is 0 
    # (i.e. nothing is selected),we show 
    # a feedback to the user in the form of a text
    # If the length > 0, we remove the feedback.
    if (length(input$species) == 0){
      showFeedbackWarning(
        inputId = "species",
        text = "Select at least one Species"
      )  
    } else {
      hideFeedback("species")
    }
    # req() allows to stop further code execution 
    # if the condition is not a truthy. 
    # Hence if input$species is NULL, the computation 
    # will be stopped here.
    req(input$species)
    plot(
      iris[ iris$Species %in% input$species, ]
    )
  })
}

shinyApp(ui, server)

# Feature-creep is the process of adding features to the app that complicate the usage and the maintenance of the product, to the point that extreme feature-creep can lead to the product being entirely unusable and completely impossible to maintain.

# A large audience means that there is a chance that your app will be used by people with visual, mobility, or maybe cognitive disabilities.

# Adapted from https://github.com/JohnCoene/nter
library(nter)
library(shiny)

ui <- fluidPage(
  # Setting a text input and a button
  textInput("text", ""),
  # This button will be clicked when 'Enter' is pressed in 
  # the textInput text
  actionButton("send", "Do not click hit enter"),
  verbatimTextOutput("typed"),
  # define the rule
  nter("send", "text") 
)

server <- function(input, output) {
  
  r <- reactiveValues()
  
  # Define the behavior on click
  observeEvent( input$send , {
    r$printed <- input$text
  })
  
  # Render the text
  output$typed <- renderPrint({
    r$printed
  })
}

shinyApp(ui, server)

# This function generates a plot for an 
# internal matrix, and takes a palette as
# parameter so that we can display the 
# plot using various palettes, as the
# palette should be a function
with_palette <- function(palette) {
  x <- y <- seq(-8 * pi, 8 * pi, len = 40)
  r <- sqrt(outer(x^2, y^2, "+"))
  z <- cos(r^2) * exp(-r / (2 * pi))
  filled.contour(
    z,
    axes = FALSE,
    color.palette = palette,
    asp = 1
  )
}

with_palette(matlab::jet.colors)

with_palette(viridis::viridis)

library(dichromat)

deutan_jet_color <- function(n){
  cols <- matlab::jet.colors(n)
  dichromat(cols, type = "deutan")
}
with_palette( deutan_jet_color )

deutan_viridis <- function(n){
  cols <- viridis::viridis(n)
  dichromat(cols, type = "deutan")
}
with_palette( deutan_viridis )

protan_jet_color <- function(n){
  cols <- matlab::jet.colors(n)
  dichromat(cols, type = "protan")
}
with_palette( protan_jet_color )

protan_viridis <- function(n){
  cols <- viridis::viridis(n)
  dichromat(cols, type = "protan")
}
with_palette( protan_viridis )

tritan_jet_color <- function(n){
  cols <- matlab::jet.colors(n)
  dichromat(cols, type = "tritan")
}
with_palette( tritan_jet_color )

tritan_viridis <- function(n){
  cols <- viridis::viridis(n)
  dichromat(cols, type = "tritan")
}
with_palette( tritan_viridis )
