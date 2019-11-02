# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

tabPanel(
  title = "Home",
  includeCSS(path = "www/custom.css"),
  includeCSS(path = "css/AdminLTE.css"),
  includeCSS(path = "css/shinydashboard.css"),
  includeCSS(path = "css/sbgprogress.css"),

  div(
    class = "jumbotron",

    br(), br(), br(), br(), br(), br(), br(),

    HTML('<h1 style="color:#FFF; text-shadow: rgba(0, 0, 0, 0.7) 0px 0px 15px;", align = "center">
           Genomics Compliance Suite&trade;</h1>'),

    br(),

    span(h3("Bring Your Bioinformatics Workflows as Standards-Compliant BioCompute Objects"), style = "color:#FFF; text-shadow: rgba(0, 0, 0, 0.7) 0px 0px 15px; text-align: center;", align = "center"),

    br(), br(), br(),

    div(
      align = "center",
      actionButton(
        "btn_start", "Start Here",
        icon("arrow-circle-o-right"),
        class = "btn btn-lg"
      ),
      actionButton(
        "btn_about", "Need Help?",
        icon("sliders"),
        class = "btn-primary btn-lg", style = "margin-left: 20px;"
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
