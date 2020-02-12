# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This document is the property of Seven Bridges Genomics Inc.
# It is considered confidential and proprietary.
#
# This document may not be reproduced or transmitted in any form,
# in whole or in part, without the express written permission of
# Seven Bridges Genomics Inc.

# Add variable to control whether login page will be allowed
# source(file.path("ui", "interface_variables.R"), local = TRUE)

# Generate Navigation Page
tabPanel(
  title = title_valid,
  icon = icon("check-circle"),

  fluidRow(column(
    width = 10, offset = 1,

    h1("BioCompute Object Validator"),
    hr(),

    fluidRow(
      column(
        width = 8,
        fileInput("upfile_validate_bco",
                  label = "Upload the BCO file (*.json):",
                  multiple = F,
                  width = '100%',
                  accept = c(".json"))
      ),
      column(
        width = 4,
        actionButton("btn_upfile_validate_bco", "Validate BCO", icon = icon("check-circle"), class = "btn btn-block", style = "margin-left: 10px;")
      ),
      tags$style(type='text/css', "#btn_upfile_validate_bco { width:100%; margin-top: 25px;}")
    ),

    br(),

    h2("Preview"),
    hr(),
    br(),
    fluidRow(
      column(
        width = 12,
        aceEditor(
          "bco_preview_validate",
          value = '"Please Upload the BCO JSON file and click the validate button."',
          height = "320px",
          mode = "json",
          theme = "textmate",
          readOnly = TRUE,
          fontSize = 12
        )
      )
    ),

    h2("Checksum Validation Results"),
    hr(),
    br(),

    fluidRow(
      column(
        width = 10, offset = 1,
        tags$head(tags$style(HTML("pre { white-space: pre-wrap; word-break: keep-all; }"))),
        htmlOutput("val_check_text")
      )
    ),

    h2("Schema Validation Results"),
    hr(),
    br(),

    fluidRow(
      column(
        width = 10, offset = 1,
        tags$head(tags$style(HTML("pre { white-space: pre-wrap; word-break: keep-all; }"))),
        htmlOutput("val_schema_text")
      )
    )
  )),

  br(), br(), br(),

  fluidRow(column(width = 12)),

  fluidRow(column(width = 10, offset = 1, hr())),

  fluidRow(
    HTML('<p align="center">&copy; 2020 Seven Bridges &nbsp; &middot; &nbsp; <a href="https://www.sevenbridges.com/privacy-policy/" target="_blank">Privacy</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/copyright-policy/" target="_blank">Copyright</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/terms-of-service/" target="_blank">Terms</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/contact/" target="_blank">Contact</a></p>')
  )
)
