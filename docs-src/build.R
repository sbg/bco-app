library("rprojroot")

# clean slate
setwd(find_rstudio_root_file())
unlink("docs/*", recursive = TRUE)

# render bookdown site
setwd(paste0(find_rstudio_root_file(), "/docs-src/"))
system("cp -R assets/ html/assets/")
system("cat html/html.yml html/titlepage.md content.Rmd > html/index.Rmd")

setwd(paste0(find_rstudio_root_file(), "/docs-src/html"))
bookdown::render_book("index.Rmd", output_format = "all", output_dir = "../../docs/", clean = TRUE)

# render pdf
setwd(paste0(find_rstudio_root_file(), "/docs-src/"))
system("cp -R assets/ pdf/assets/")
system("cat pdf/pdf.yml content.Rmd > pdf/gcs-user-manual.Rmd")

rmarkdown::render("pdf/gcs-user-manual.Rmd", clean = TRUE)

# replace pdf in bookdown site
system("mv pdf/gcs-user-manual.pdf ../docs/gcs-user-manual.pdf")

# housekeeping
unlink("html/assets/", recursive = TRUE)
unlink("html/index.Rmd")
unlink("pdf/assets/", recursive = TRUE)
unlink(c("pdf/gcs-user-manual.Rmd", "pdf/gcs-user-manual.tex"))

# preview
browseURL("../docs/index.html")
browseURL("../docs/gcs-user-manual.pdf")

# return to the project root
setwd(find_rstudio_root_file())
