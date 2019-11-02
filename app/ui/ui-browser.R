# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

tabPanel(
  title = "BCO Browser",

  fluidRow(column(
    width = 10, offset = 1,

    h1("Interactive Browser for BioCompute Object"),
    hr(),

    fluidRow(
      column(
        width = 8,
        fileInput(
          "upfile_browser_bco",
          label = "Upload the BCO file (*.json):",
          multiple = F,
          width = "100%",
          accept = c(".json")
        )
      ),
      column(
        width = 4,
        actionButton("btn_upfile_browser_bco", "Explore BCO", icon = icon("check-circle"), class = "btn btn-block", style = "margin-left: 10px;")
      ),
      tags$style(type = "text/css", "#btn_upfile_browser_bco { width:100%; margin-top: 25px;}")
    ),

    br(),

    h2("Interactive BCO Browser"),
    hr(),
    br(),
    fluidRow(
      column(
        width = 12,
        reactjsonOutput("bco_preview_browser"),
        tags$style(type = "text/css", "#bco_preview_browser { border-style: solid; border-width: 1px; border-color: #083050 }")
      )
    )
  )),

  br(), br(), br(),

  fluidRow(column(width = 12)),

  fluidRow(column(width = 10, offset = 1, hr())),

  fluidRow(
    HTML('<p align="center">&copy; 2019 Seven Bridges &nbsp; &middot; &nbsp; <a href="https://www.sevenbridges.com/privacy-policy/" target="_blank">Privacy</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/copyright-policy/" target="_blank">Copyright</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/terms-of-service/" target="_blank">Terms</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/contact/" target="_blank">Contact</a></p>')
  )
)
