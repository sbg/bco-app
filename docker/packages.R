install.packages(repos = "https://cloud.r-project.org", c(
  "shiny", "shinydashboard", "shinyBS", "shinyjs",
  "shinyFeedback", "shinycssloaders", "shinyAce",
  "DT",  "kableExtra", "reactR", "listviewer",
  "visNetwork", "bcrypt", "jsonlite",
  "BiocManager", "remotes",
  "tidycwl", "biocompute"
))

BiocManager::install("sevenbridges")

remotes::install_github("rstudio/gt@883df9a")
remotes::install_github("jbryer/DTedit@0c248c0")
