# golem is a toolkit for simplifying the creation, development and deployment of a shiny application

golem::create_golem("golex")

# Listing the files from the `golex` project using {fs}
fs::dir_tree("golex")

# The DESCRIPTION and NAMESPACE are standard package files (i.e. they are not golem-specific). 
# In DESCRIPTION, you will add a series of metadata about your package, for example, who wrote the package, what is the package version, what is its goal, who to complain to if things go wrong, and also information about external dependencies, the license, the encoding, and so forth.

# The NAMESPACE file is the file you will NEVER edit by hand! It defines how to interact with the rest of the package: what functions to import and from which package and what functions to export, i.e. what functions are available to the user when you do library(golex).

# The R/ folder is the standard folder where you will store all your app functions.

#' Access files in the current app
#' 
#' NOTE: If you manually change your package 
#' name in the DESCRIPTION, don't forget to change it here too,
#' and in the config file. For a safer name change mechanism, 
#' use the `golem::set_golem_name()` function.
#' 
#' @param ... character vectors, specifying subdirectory 
#' and file(s) within your package. 
#' The default, none, returns the root of the app.
#' 
#' @noRd
app_sys <- function(...){
  system.file(..., package = "golex")
}


#' Read App Config
#' 
#' @param value Value to retrieve from the config file. 
#' @param config GOLEM_CONFIG_ACTIVE value. 
#' If unset, R_CONFIG_ACTIVE.  If unset, "default".
#' @param use_parent Logical, 
#' scan the parent directory for config file.
#' 
#' @noRd
get_golem_config <- function(
    value, 
    config = Sys.getenv(
      "GOLEM_CONFIG_ACTIVE", 
      Sys.getenv(
        "R_CONFIG_ACTIVE", 
        "default"
      )
    ), 
    use_parent = TRUE
){
  config::get(
    value = value, 
    config = config, 
    # Modify this if your config file is somewhere else:
    file = app_sys("golem-config.yml"), 
    use_parent = use_parent
  )
}

# The app_config.R file contains internal mechanics for golem, notably for referring to values in the inst/ folder, and to get values from the config file in the inst/ folder. 

#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  
}

# The app_server.R file contains the function for the server logic.

#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    fluidPage(
      h1("golex")
    )
  )
}

# This piece of the app_ui.R is designed to receive the counterpart of what you put in your server. 

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js 
#' @importFrom golem favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'cloop'
    )
    # Add here other external resources
    # for example, you can add 
    # shinyalert::useShinyalert() 
  )
}

#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts. 
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options 
run_app <- function(
    onStart = NULL,
    options = list(), 
    enableBookmarking = NULL,
    uiPattern = "/",
    ...
) {
  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options, 
      enableBookmarking = enableBookmarking, 
      uiPattern = uiPattern
    ), 
    golem_opts = list(...)
  )
}

# The run_app() function is the one that you will use to launch the app.

# Inside the R/ folder is the app_config.R file. This file is designed to handle two things:

#   app_sys() is a wrapper around system.file(package = "golex"), and allows you to quickly refer to the files inside the inst/ folder. For example, app_sys("x.txt") points to the inst/x.txt file inside your package.
 
# get_golem_config() helps you manipulate the config file located at inst/golem-config.yml.

# The inst/app/www/ folder contains all files that are made available at application run time.

# The dev/ folder is to be used as a notebook for your development process: you will find here a series of functions that can be used throughout your project.

# The man/ folder includes the package documentation. It is a common folder automatically filled when you document your app, notably when running the dev/run_dev.R script and the document_and_reload() function.
