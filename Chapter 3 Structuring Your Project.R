# A README file that you will put at the root of your package, which will document how to install the package, and some information about how to use the package.
# Vignettes are longer-form documentation that explains in more depth how to use your app.
# Nothing should go to production without being tested. Nothing.
# That is what modules are made for: creating small namespaces where you can safely define ids without conflicting with other ids in the app. 

library(shiny)
ui <- function() {
  fluidPage(
    # Define a first sliderInput(), 
    # with an id that we will postfix with `1`
    # in order to make it unique
    sliderInput(
      inputId = "choice1", 
      label = "choice 1", 
      min = 1, max = 10, value = 5
    ),
    # Define a first actionButton(), 
    # with an id that we will postfix with `1`
    # in order to make it unique
    actionButton(
      inputId = "validate1",
      label = "Validate choice 1"
    ),
    # We define here a second sliderInput, 
    # and need its id to be unique, so we 
    # postfix it with 2
    sliderInput(
      inputId = "choice2",
      label = "choice 2", 
      min = 1, max = 10, value = 5
    ),
    # We define here a second actionButton, 
    # and need its id to be unique, so we 
    # postfix it with 2
    actionButton(
      inputId = "validate2", 
      label = "Validate choice 2"
    )
  )
}

server <- function(input, output, session) {
  
  # Observing the first series of inputs
  # Whenever the user clicks on the first validate button, 
  # the value of choice1 will be printed to the console
  observeEvent( input$validate1 , {
    print(input$choice1)
  })
  
  # Same as the first observeEvent, except that we are 
  # observing the second series
  observeEvent( input$validate2 , {
    print(input$choice2)
  })
}

shinyApp(ui, server)


# shiny modules aim at three things: simplify “id” namespacing, split the codebase into a series of functions, and allow UI/Server parts of your app to be reused. Most of the time, modules are used to do the two first. In our case, we could say that 90% of the modules we write are never reused;19 they are here to allow us to split the codebase into smaller, more manageable pieces.

# first shiny module

# Re-usable module
choice_ui <- function(id) {
  # This ns <- NS structure creates a 
  # "namespacing" function, that will 
  # prefix all ids with a string
  ns <- NS(id)
  tagList(
    sliderInput(
      # This looks the same as your usual piece of code, 
      # except that the id is wrapped into 
      # the ns() function we defined before
      inputId = ns("choice"), 
      label = "Choice",
      min = 1, max = 10, value = 5
    ),
    actionButton(
      # We need to ns() all ids
      inputId = ns("validate"),
      label = "Validate Choice"
    )
  )
}

choice_server <- function(id) {
  # Calling the moduleServer function
  moduleServer(
    # Setting the id
    id,
    # Defining the module core mechanism
    function(input, output, session) {
      # This part is the same as the code you would put 
      # inside a standard server
      observeEvent( input$validate , {
        print(input$choice)
      })
    }
  )
}


# Main application
library(shiny)
app_ui <- function() {
  fluidPage(
    # Call the UI  function, this is the only place 
    # your ids will need to be unique
    choice_ui(id = "choice_ui1"),
    choice_ui(id = "choice_ui2")
  )
}

app_server <- function(input, output, session) {
  # We are now calling the module server functions 
  # on a given id that matches the one from the UI
  choice_server(id = "choice_ui1")
  choice_server(id = "choice_ui2")
}

shinyApp(app_ui, app_server)

# Defining the id
id <- "mod_ui_1"
# Creating the internal "namespacing" function
ns <- NS(id)
# "namespace" the id
ns("choice")

mod_ui <- function(id, button_label) {
  ns <- NS(id)
  tagList(
    actionButton(ns("validate"), button_label)
  )
}

# Printing the HTML for this piece of UI
mod_ui("mod_ui_1", button_label = "Validate ")
mod_ui("mod_ui_2", button_label = "Validate, again")

# the app_ui contains a series of calls to the mod_ui(unique_id, ...) function, allowing additional arguments like any other function:

# The app_server side contains a series of mod_server(unique_id, ...), also allowing additional parameters, just like any other function.

mod_dataviz_ui <- function(
    id, 
    type = c("point", "hist", "boxplot", "bar")
) {
  # Setting a header with the specified type of graph
  h4(
    sprintf( "Create a geom_%s", type )
  ),
  # [ ... ]
  # We want to allow a coord_flip only with barplots
  if (type == "bar"){
    checkboxInput(
      ns("coord_flip"),
      "coord_flip"
    )
  }, 
  # [ ... ]
  # We want to display the bins input only 
  # when the type is histogram
  if (type == "hist") {
    numericInput(
      ns("bins"), 
      "bins", 
      30, 
      1, 
      150,
      1
    )
  },
  # [ ... ]
  # The title input will be added to the graph 
  # for every type of graph
  textInput(
    ns("title"),
    "Title",
    value = ""
  )
}

mod_dataviz_server <- function(
    input, 
    output, 
    session, 
    type
) {
  # [ ... ]
  if (type == "point") {
    # Defining the server logic when the type is point
    # When the type is point, we have access to input$x, 
    # input$y, input$color, and input$palette, 
    # so we reuse them here
    ggplot(
      big_epa_cars, 
      aes(
        .data[[input$x]], 
        .data[[input$y]], 
        color = .data[[input$color]])
    )  +
      geom_point()+ 
      scale_color_manual(
        values = color_values(
          1:length(
            unique(
              pull(
                big_epa_cars, 
                .data[[input$color]])
            )
          ), 
          palette = input$palette
        )
      )
  } 
  # [ ... ]
  if (type == "hist") {
    # Defining the server logic when the type is hist
    # When the type is point, we have access to input$x, 
    # input$color, input$bins, and input$palette
    # so we reuse them here
    ggplot(
      big_epa_cars, 
      aes(
        .data[[input$x]], 
        fill = .data[[input$color]]
      )
    ) +
      geom_histogram(bins = input$bins)+ 
      scale_fill_manual(
        values = color_values(
          1:length(
            unique(
              pull(
                big_epa_cars, 
                .data[[input$color]]
              )
            )
          ), 
          palette = input$palette
        )
      )
  } 
}

app_ui <- function() {
  # [...]
  tagList(
    fluidRow(
      # Setting the first tab to be of type point
      id = "geom_point", 
      mod_dataviz_ui(
        "dataviz_ui_1", 
        type = "point"
      )
    ), 
    fluidRow(
      # Setting the second tab to be of type point
      id = "geom_hist", 
      mod_dataviz_ui(
        "dataviz_ui_2", 
        type = "hist"
      )
    )
  )
}

app_server <- function(input, output, session) {
  # This app has been built before shiny 1.5.0, 
  # so we use the callModule structure
  # 
  # We here call the server module on their 
  # corresponding id in the UI, and set the 
  # parameter of the server function to 
  # match the correct type of input
  callModule(mod_dataviz_server, "dataviz_ui_1", type = "point")
  callModule(mod_dataviz_server, "dataviz_ui_2", type = "hist")
}

# One of the hardest part of using modules is sharing data across them. There are at least three approaches:
  
  # Returning a reactive function
# The “stratégie du petit r” (to be pronounced with a French accent of course)
# The “stratégie du grand R6”

#returning a reactive function
# Module 1, which will allow to select a number
choice_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Add a slider to select a number
    sliderInput(ns("choice"), "Choice", 1, 10, 5)
  )
}


choice_server <- function(id) {
  moduleServer( id, function(input, output, session) {
    # We return a reactive function from this server, 
    # that can be passed along to other modules
    return(
      reactive({
        input$choice
      })
    )
  }
  )
}

# Module 2, which will display the number
printing_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Insert the number modified in the first module
    verbatimTextOutput(ns("print"))
  )
}

printing_server <- function(id, number) {
  moduleServer(id, function(input, output, session) {
    # We evaluate the reactive function 
    # returned from the other module
    output$print <- renderPrint({
      number()
    })
  }
  )
}

# Application
library(shiny)
app_ui <- function() {
  fluidPage(
    choice_ui("choice_ui_1"),
    printing_ui("printing_ui_2")
  )
}

app_server <- function(input, output, session) {
  # choice_server() returns a value that is then passed to 
  # printing_server()
  number_from_first_mod <- choice_server("choice_ui_1")
  printing_server(
    "printing_ui_2", 
    number = number_from_first_mod
  )
}

shinyApp(app_ui, app_server)

# The “stratégie du petit r”

# In this strategy, we create a global reactiveValues list that is passed along through other modules.

# Module 1, which will allow to select a number
choice_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Add a slider to select a number
    sliderInput(ns("choice"), "Choice", 1, 10, 5)
  )
}

choice_server <- function(id, r) {
  moduleServer(
    id,
    function(input, output, session) {
      # Whenever the choice changes, the value inside r is set
      observeEvent( input$choice , {
        r$number_from_first_mod <- input$choice
      })
      
    }
  )
}

# Module 2, which will display the number
printing_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # Insert the number modified in the first module
    verbatimTextOutput(ns("print"))
  )
}

printing_server <- function(id, r) {
  moduleServer(
    id,
    function(input, output, session) {
      # We evaluate the reactiveValue element modified in the 
      # first module
      output$print <- renderPrint({
        r$number_from_first_mod
      })
    }
  )
}

# Application
library(shiny)
app_ui <- function() {
  fluidPage(
    choice_ui("choice_ui_1"),
    printing_ui("printing_ui_2")
  )
}

app_server <- function(input, output, session) {
  # both servers take a reactiveValue,
  #  which is set in the first module
  # and printed in the second one.
  # The server functions don't return any value per se
  r <- reactiveValues()
  choice_server("choice_ui_1", r = r)
  printing_server("printing_ui_2", r = r)
}

shinyApp(app_ui, app_server)

# The “stratégie du grand R6”

# An R6 object is a data structure that can hold in itself data and functions. Its particularity is that if it’s modified inside a function, this modified value is kept outside the function in which it’s called, making it a powerful tool to manage data across the application

# Application logic is what makes your shiny app interactive: structure, buttons, tables, interactivity, etc. 
# Business logic includes the components with the core algorithms and functions that make your application specific to your area of work. 

library(shiny)
library(dplyr)
# A simple app that returns a table
ui <- function() {
  tagList(
    tableOutput("tbl"), 
    sliderInput("n", "Number of rows", 1, 50, 25)
  )
}

server <- function(input, output, session) {
  output$tbl <- renderTable({
    # Writing all the business logic for the table manipulation 
    # inside the server
    mtcars %>%
      # [...] %>% 
      # [...] %>% 
      # [...] %>% 
      # [...] %>% 
      # [...] %>% 
      top_n(input$n)
  })
}

shinyApp(ui, server)

library(shiny)
library(dplyr)

# Writing all the business logic for the table manipulation 
# inside an external function
top_this <- function(tbl, n) {
  tbl %>%
    # [...] %>% 
    # [...] %>% 
    # [...] %>% 
    # [...] %>% 
    top_n(n)
}

# A simple app that returns a table
ui <- function() {
  tagList(
    tableOutput("tbl"), 
    sliderInput("n", "Number of rows", 1, 50, 25)
  )
}


server <- function(input, output, session) {
  output$tbl <- renderTable({
    # We call the previously declared function inside the server
    # The business logic is thus defined outside the application
    top_this(mtcars, input$n)
  })
}

shinyApp(ui, server)

# Both scripts do the exact same thing. The difference is that the second code can be easily explored without having to relaunch the app. 

# Long scripts are almost always synonymous with complexity when it comes to building software. 



# app_*.R (typically app_ui.R and app_server.R) contain the top-level functions defining your user interface and your server function.

# fct_* files contain the business logic, which are potentially large functions. They are the backbone of the application and may not be specific to a given module. They can be added using golem with the add_fct("name") function.

# mod_* files contain a unique module. Many shiny apps contain a series of tabs, or at least a tab-like pattern, so we suggest that you number them according to their step in the application. Tabs are almost always named in the user interface, so that you can use this tab name as the file name. For example, if you build a dashboard where the first tab is called “Import”, you should name your file mod_01_import.R. You can create this file with a module skeleton using golem::add_module("01_import").

# utils_* are files that contain utilities, which are small helper functions. For example, you might want to have a not_na, which is not_na <- Negate(is.na), a not_null, or small tools that you will be using application-wide. Note that you can also create utils for a specific module.

# *_ui_*, for example utils_ui.R, relates to the user interface.

# *_server_* are files that contain anything related to the application’s back-end. For example, fct_connection_server.R will contain functions that are related to the connection to a database, and are specifically used from the server side.
