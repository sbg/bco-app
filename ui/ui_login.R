# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This document is the property of Seven Bridges Genomics Inc.
# It is considered confidential and proprietary.
#
# This document may not be reproduced or transmitted in any form,
# in whole or in part, without the express written permission of
# Seven Bridges Genomics Inc.

fluidPage(

  tags$head(tags$link(rel = "shortcut icon", href = "favicon.ico")),
  tags$head(tags$meta(name = "theme-color", content = "#083050")),
  theme = "custom.css",
  title = "BCO App - Seven Bridges",

  fluidRow(
    column(
      width = 4, offset = 4,
      br(), br(), br(), br(),
      img(src = "logo.svg", width = "200px", class = "center-block"),
      br(), br(),
      uiOutput("uiLogin"),
      uiOutput("pass"),
      tags$style(type = "text/css", "body { background-color: rgb(8, 48, 79); }")
    ),
    HTML('<div class="footer"><p><small>&copy; 2020 Seven Bridges &nbsp; &middot; &nbsp; <a href="https://docs.sevenbridges.com/" target="_blank"><b>Knowledge Center</b></a> &nbsp;&nbsp; <a href="https://igor.sbgenomics.com/developer" target="_blank">Developer</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/privacy-policy/" target="_blank">Privacy</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/copyright-policy/" target="_blank">Copyright</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/terms-of-service/" target="_blank">Terms</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/contact/" target="_blank">Contact</a> </small></p></div>'),
    tags$style(type = "text/css", ".footer { position: fixed; left: 0; bottom: 0; width: 100%; color: white; text-align: center;}"),
    tags$style(type = "text/css", ".footer a { color: #FFF; }")
  )
)
