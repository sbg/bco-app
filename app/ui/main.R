# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

navbarPage(
  id = "nav_bco",

  windowTitle = "Genomics Compliance Suite - Seven Bridges",

  title = div(
    img(src = "logo.svg", style = "margin:5px 0px 20px 0px;"),
    br(), HTML("&emsp;&emsp;&emsp;&emsp;&emsp;")
  ),

  source(file.path("ui", "ui-home.R"), local = TRUE)$value,
  source(file.path("ui", "ui-creator.R"), local = TRUE)$value,
  source(file.path("ui", "ui-composer.R"), local = TRUE)$value,
  source(file.path("ui", "ui-validator.R"), local = TRUE)$value,
  source(file.path("ui", "ui-browser.R"), local = TRUE)$value,
  source(file.path("ui", "ui-help.R"), local = TRUE)$value
)
