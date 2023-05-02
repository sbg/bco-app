# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This document is the property of Seven Bridges Genomics Inc.
# It is considered confidential and proprietary.
#
# This document may not be reproduced or transmitted in any form,
# in whole or in part, without the express written permission of
# Seven Bridges Genomics Inc.

library("shiny")
library("shinydashboard")
library("bcrypt")
library("shinyBS")
library("shinyjs")
library("shinyFeedback")
library("shinycssloaders")
library("shinyAce")
library("jsonlite")
library("gt")
library("magrittr")
library("stringr")
library("listviewer")
library("visNetwork")
library("tidycwl")
library('dplyr')
library("biocompute")
library("markdown")
library("reactR")
library('tools')
library('shinyalert')
library('BiocManager')

# 24aeb22ed4224a1387ce6ccb31f98684
# install.packages("BiocManager")
# BiocManager::install("sevenbridges")
# devtools::install_github('jbryer/DTedit')
options(repos = BiocManager::repositories())

if (!require("BiocManager", quietly = TRUE)){
  install.packages("BiocManager")
}

# BiocManager::install("BiocGenerics")
# BiocManager::install("sevenbridges")
# devtools::install_github('jbryer/DTedit')


# the number of failed attempts allowed before a user is locked out
max_lockout <- 4

# number of pages that needs prev/next buttons
num_pages <- 6
num_pages_basic <- 5

# add variable to control whether login page will be allowed
source(file.path("ui", "interface_variables.R"), local = TRUE)

# define user interface variable
ui <- uiOutput("ui")

server <- function(input, output, session) {

  # ui
  output$ui <- renderUI({
    if (include_ui_login_page == TRUE) {
      if (user_input$authenticated == FALSE) {
        # login page ui
        source(file.path("ui", "ui_login.R"), local = TRUE)$value
      } else {
        # tabs ui
        source(file.path("ui", "ui_main.R"), local = TRUE)$value
      }
    } else {
      # tabs ui
      source(file.path("ui", "ui_main.R"), local = TRUE)$value
    }
  })

  # server

  # utils for platform options
  source(file.path("server", "utils.R"), local = TRUE)$value
  # source(file.path("server", "override.R"), local = TRUE)$value

  # api for getting workflow from project
  source(file.path("server", "api.R"), local = TRUE)$value

  # app logic - file.path is subfolder, then file.
  source(file.path("server", "logic-new-visualization-and-table-functions.R"), local = TRUE)$value
  source(file.path("server", "logic-ui-basic.R"), local = TRUE)$value
  source(file.path("server", "logic-import.R"), local = TRUE)$value
  source(file.path("server", "logic-import-local.R"), local = TRUE)$value
  source(file.path("server", "logic-input.R"), local = TRUE)$value
  source(file.path("server", "logic-input-basic.R"), local = TRUE)$value
  source(file.path("server", "logic-input-local.R"), local = TRUE)$value
  source(file.path("server", "logic-export.R"), local = TRUE)$value
  source(file.path("server", "logic-export-basic.R"), local = TRUE)$value
  source(file.path("server", "logic-export-local.R"), local = TRUE)$value
  source(file.path("server", "logic-help.R"), local = TRUE)$value
  source(file.path("server", "pdf-generator.R"), local = TRUE)$value

  # authentication logic
  source(file.path("server", "auth.R"), local = TRUE)$value
}

shinyApp(ui, server)
