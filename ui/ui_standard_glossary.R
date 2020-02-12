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
  title = title_std_glossary,
  icon = icon("info-circle"),

  fluidRow(column(
    width = 10, offset = 1,

    h3("BioCompute Object (BCO) Domains"),
    hr(),

    radioButtons("bco_domain", label = NULL, choices = c(
      "All Domains" = "bco_all", "Mandatory Domains" = "bco_must"
    ), inline = TRUE),

    # Sub tabs of BCO domains
    tabsetPanel(
      id = "domains", type = "tabs",
      tabPanel("Top Level Fields", gt_output("table_top")),
      tabPanel("Provenance Domain", gt_output("table_provenance")),
      tabPanel("Usability Domain", gt_output("table_usability")),
      tabPanel("Extension Domain", gt_output("table_extension")),
      tabPanel("Description Domain", gt_output("table_description")),
      tabPanel("Execution Domain", gt_output("table_execution")),
      tabPanel("Parametric Domain", gt_output("table_parametric")),
      tabPanel("I/O Domain", gt_output("table_io")),
      tabPanel("Error Domain", gt_output("table_error"))
    ),
    br(), hr()
  )),

  br(),

  fluidRow(
    HTML('<p align="center">&copy; 2020 Seven Bridges &nbsp; &middot; &nbsp; <a href="https://www.sevenbridges.com/privacy-policy/" target="_blank">Privacy</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/copyright-policy/" target="_blank">Copyright</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/terms-of-service/" target="_blank">Terms</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/contact/" target="_blank">Contact</a></p>')
  )
)