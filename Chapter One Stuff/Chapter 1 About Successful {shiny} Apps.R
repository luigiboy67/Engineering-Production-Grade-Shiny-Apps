library(dplyr, warn.conflicts = FALSE)
# With pipe
iris %>%
  group_by(Species) %>%
  summarize(mean_sl = mean(Sepal.Length))
# Without the pipe
summarize(group_by(iris, Species), mean_sl = mean(Sepal.Length))


# Putting one symbol by line 
iris[
  1
  :
    5, 
  "Species"
]

# Same code but everything is on the same line
iris[1:5, "Species"]

library(cloc)
# Using dplyr to manipulate the results
library(dplyr, warn.conflicts = FALSE)

# Computing the number of lines of code 
# for various CRAN packages
shiny_cloc <- cloc_cran(
  "shiny", 
  .progress = FALSE, 
  repos = "http://cran.irsn.fr/"
)
attempt_cloc <- cloc_cran(
  "attempt", 
  .progress = FALSE, 
  repos = "http://cran.irsn.fr/" 
)

clocs <- bind_rows(
  shiny_cloc, 
  attempt_cloc
)

# Summarizing the number of line of code inside each package
clocs %>%
  group_by(pkg) %>%
  summarise(
    loc = sum(loc)
  )

# Summarizing the number of files inside each package
clocs %>%
  group_by(pkg) %>%
  summarise(
    files = sum(file_count)
  )

# Calling the function on the {hexmake} 
# application Git repository
hexmake_cloc <- cloc_git(
  "https://github.com/ColinFay/hexmake"
)
hexmake_cloc

# Launch the {cyclocomp} package, and compute the 
# cyclomatic complexity of "golex",
# A blank {golem} project with one module skeleton
library(cyclocomp)
cyclocomp_package_dir("golex") %>% 
  head()

# Same metric, but for the application 
# {tidytuesday201942}, available at
# https://engineering-shiny.org/tidytuesday201942.html
cyclocomp_package("tidytuesday201942") %>% 
  head()

# Computing this metric for the {shiny} package
cyclocomp_package("shiny") %>% 
  head()

library(packageMetrics2)
# A function to turn the output of the metrics into a data.frame
frame_metric <- function(pkg){
  metrics <- package_metrics(pkg)
  tibble::tibble(
    n = names(metrics), 
    val = metrics, 
    expl = list_package_metrics()[names(metrics)]
  )
}

# Using this function with{golem}
frame_metric("golem") 

# Using this function with {shiny}
frame_metric("shiny") 

# Get the dependencies from the DESCRIPTION file.
# You can use one of these two functions to list 
# the dependencies of your package, 
# and compute the metric for each dep
desc::desc_get_deps("golex/DESCRIPTION")

# See also 
attachment::att_from_description("golex/DESCRIPTION")
