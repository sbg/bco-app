# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This document is the property of Seven Bridges Genomics Inc.
# It is considered confidential and proprietary.
#
# This document may not be reproduced or transmitted in any form,
# in whole or in part, without the express written permission of
# Seven Bridges Genomics Inc.

set_meta <- function(title, datetime) {
  list("title" = title, "datetime" = datetime)
}

get_meta <- function(meta_vec, field_name) meta_vec[[field_name]]

output$btn_export_pdf <- downloadHandler(
  filename = function() {
    pb <- Sys.time()
    attributes(pb)$tzone <- "America/New_York" # convert to EST
    paste0(input$app_name, ".pdf")
  },
  content = function(file) {
    showModal(modalDialog("Generating report...", footer = NULL))

    meta_vec <- set_meta(
      title = input$provenance_name,
      datetime = format(Sys.Date(), "%B %d, %Y")
    )

    src_rmd <- normalizePath("template/report.Rmd")
    src_tex <- normalizePath("template/bco-report-template.tex")
    src_logo <- normalizePath("template/sbg-logo.pdf")
    src_bco_spec <- normalizePath("template/bco-spec.csv")
    owd <- setwd(tempdir())
    on.exit(setwd(owd))
    file.copy(src_rmd, "report.Rmd")
    file.copy(src_tex, "bco-report-template.tex")
    file.copy(src_logo, "sbg-logo.pdf")
    file.copy(src_bco_spec, "bco-spec.csv")
    out <- rmarkdown::render("report.Rmd", quiet = TRUE)
    file.rename(out, file)

    removeModal()
  }
)

output$btn_export_pdf_local <- downloadHandler(
  filename = function() {
    pb <- Sys.time()
    attributes(pb)$tzone <- "America/New_York" # convert to EST
    paste0(input$provenance_name_local, ".pdf")
  },
  content = function(file) {
    showModal(modalDialog("Generating report...", footer = NULL))

    meta_vec <- set_meta(
      title = input$provenance_name_local,
      datetime = format(Sys.Date(), "%B %d, %Y")
    )

    src_rmd <- normalizePath("template/report-local.Rmd")
    src_tex <- normalizePath("template/bco-report-template.tex")
    src_logo <- normalizePath("template/sbg-logo.pdf")
    src_bco_spec <- normalizePath("template/bco-spec.csv")
    owd <- setwd(tempdir())
    on.exit(setwd(owd))
    file.copy(src_rmd, "report-local.Rmd")
    file.copy(src_tex, "bco-report-template.tex")
    file.copy(src_logo, "sbg-logo.pdf")
    file.copy(src_bco_spec, "bco-spec.csv")
    out <- rmarkdown::render("report-local.Rmd", quiet = TRUE)
    file.rename(out, file)

    removeModal()
  }
)

# TODO: - add visual of workflow to the generated pdf report
