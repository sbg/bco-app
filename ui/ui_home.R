# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This document is the property of Seven Bridges Genomics Inc.
# It is considered confidential and proprietary.
#
# This document may not be reproduced or transmitted in any form,
# in whole or in part, without the express written permission of
# Seven Bridges Genomics Inc.

# Add variable to control whether login page will be allowed
source(file.path("ui", "interface_variables.R"), local = TRUE)

# Generate Navigation Page
tabPanel(
  title = title_home, icon = icon("home"),
  tags$head(HTML(
    '<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  <meta name="theme-color" content="#ffffff">')),
  includeCSS(path = "www/custom.css"),
  includeCSS(path = "css/AdminLTE.css"),
  includeCSS(path = "css/shinydashboard.css"),
  includeCSS(path = "css/sbgprogress.css"),

  div(
    class = "jumbotron",

    br(), br(),

    span(h1("Genomics Compliance Suite", style = "color:#FFF; text-shadow: rgba(0, 0, 0, 0.3) 0px 0px 15px; text-align: center; font-weight: 700;") , align = "center"),

    br(),

    span(h2("Generate BioCompute Objects from your workflows"), style = "color:#FFF; text-shadow: rgba(0, 0, 0, 0.7) 0px 0px 15px; text-align: center;", align = "center"),

    br(), br(),

    fluidRow(
      column(
        width = 8, offset = 2,
        p(ui_home_desc_1, style = "color:#FFF; text-shadow: rgba(0, 0, 0, 0.5) 0px 0px 25px; font-size: 14px; font-weight: 400;"),
        p(ui_home_desc_2, style = "color:#FFF; text-shadow: rgba(0, 0, 0, 0.5) 0px 0px 25px; font-size: 14px; font-weight: 400;"),
      )
    ),

    br(), br(),

    div(
      align = "center",
      actionButton(
        "btn_nav_text", "Text Composer",
        icon("arrow-circle-o-right"),
        class = "btn btn-lg", style = "margin-left: 25px; background-color: rgb(28, 121, 96); border-color: rgb(28, 121, 96);"
      ),
      actionButton(
        "btn_nav_file", "File Composer",
        icon("arrow-circle-o-right"),
        class = "btn btn-lg", style = "margin-left: 25px; background-color: rgb(117, 54, 133); border-color: rgb(117, 54, 133);"
      ),
      actionButton(
        "btn_nav_plat", "Platform Composer",
        icon("arrow-circle-o-right"),
        class = "btn btn-lg", style = "margin-left: 25px; background-color: rgb(102, 104, 195); border-color: rgb(102, 104, 195);"
      ),
      actionButton(
        "btn_nav_help", "Need Help?",
        icon("book-open"),
        class = "btn btn-lg", style = "margin-left: 25px; background-color: rgb(3, 111, 173); border-color: rgb(3, 111, 173);"
      )
    )

  ),

  tags$style(
    type = "text/css",
    HTML('.jumbotron {width: 100vw; height: calc(100vh - 43px);
           border-radius:0px !important;
           margin-top:-30px; margin-left:-15px; margin-bottom:0px;
           background-image: url("bg.svg");
           background-size:cover; background-position:center;
           background-repeat:no-repeat;}')
  )
)