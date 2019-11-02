install.packages(repos = "https://cloud.r-project.org", c(
  "DT", "shinydashboard", "shinyBS", "shinyjs",
  "shinyFeedback", "shinycssloaders", "shinyAce",
  "kableExtra", "visNetwork", "bcrypt",
  "reactR", "listviewer"
))

remotes::install_github("rstudio/gt@f620501")
remotes::install_github("jbryer/DTedit@0c248c0")

BiocManager::install("sevenbridges")
remotes::install_github("sbg/biocompute@447cc2")
remotes::install_github("sbg/tidycwl@e4a431")
