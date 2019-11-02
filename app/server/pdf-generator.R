# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

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
    src_tex <- normalizePath("template/template.tex")
    src_logo <- normalizePath("template/sevenbridges-logo.png")
    src_bco_spec <- normalizePath("template/bco-spec.csv")
    owd <- setwd(tempdir())
    on.exit(setwd(owd))
    file.copy(src_rmd, "report.Rmd")
    file.copy(src_tex, "template.tex")
    file.copy(src_logo, "sevenbridges-logo.png")
    file.copy(src_bco_spec, "bco-spec.csv")
    out <- rmarkdown::render("report.Rmd", quiet = TRUE)
    file.rename(out, file)

    removeModal()
  }
)
