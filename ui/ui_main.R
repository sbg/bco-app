# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This document is the property of Seven Bridges Genomics Inc.
# It is considered confidential and proprietary.
#
# This document may not be reproduced or transmitted in any form,
# in whole or in part, without the express written permission of
# Seven Bridges Genomics Inc.

navbarPage(
  id = nav_id,

  windowTitle = "Genomics Compliance Suite - Seven Bridges",

  title = div(
    img(src = "logo.svg", style = "margin:5px 0px 20px 0px;"),
    br(), HTML("&emsp;&emsp;&emsp;&emsp;&emsp;")
  ),

  source(file.path("ui", "ui_home.R"), local = TRUE)$value,

  navbarMenu(
    "Generators",
    icon = icon("server"),
    source(file.path("ui", "ui_composer_text.R"), local = TRUE)$value,
    "----",
    source(file.path("ui", "ui_composer_file.R"), local = TRUE)$value,
    "----",
    source(file.path("ui", "ui_composer_plat.R"), local = TRUE)$value
  ),

  navbarMenu(
    "Utilities",
    icon = icon("toolbox"),
    source(file.path("ui", "ui_browser.R"), local = TRUE)$value,
    "----",
    source(file.path("ui", "ui_validator.R"), local = TRUE)$value,
    "----",
    source(file.path("ui", "ui_standard_glossary.R"), local = TRUE)$value
  ),

  source(file.path("ui", "ui_help.R"), local = TRUE)$value
)
