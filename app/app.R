# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

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

library("tidycwl")
library("biocompute")
library("magrittr")
library("stringr")
library("listviewer")

# the number of failed attempts allowed before a user is locked out
max_lockout <- 4

# number of pages that needs prev/next buttons
num_pages <- 6
num_pages_basic <- 5

ui <- uiOutput("ui")

server <- function(input, output, session) {

  # ui

  output$ui <- renderUI({
    if (user_input$authenticated == FALSE) {
      # login ui
      source(file.path("ui", "login.R"), local = TRUE)$value
    } else {
      # main ui
      source(file.path("ui", "main.R"), local = TRUE)$value
    }
  })

  # server

  # utils for platform options
  source(file.path("server", "utils.R"), local = TRUE)$value

  # api for getting workflows from projects
  source(file.path("server", "api.R"), local = TRUE)$value

  # app logic
  # source(file.path("server", "logic-ui.R"), local = TRUE)$value
  source(file.path("server", "logic-ui-basic.R"), local = TRUE)$value
  source(file.path("server", "logic-import.R"), local = TRUE)$value
  source(file.path("server", "logic-input.R"), local = TRUE)$value
  source(file.path("server", "logic-input-basic.R"), local = TRUE)$value
  source(file.path("server", "logic-export.R"), local = TRUE)$value
  source(file.path("server", "logic-export-basic.R"), local = TRUE)$value
  source(file.path("server", "logic-help.R"), local = TRUE)$value
  source(file.path("server", "pdf-generator.R"), local = TRUE)$value

  # authentication logic
  source(file.path("server", "auth.R"), local = TRUE)$value
}

shinyApp(ui, server)
