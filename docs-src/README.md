This directory (`docs-src/`) contains the source of the documentation of the GCS project. To update it:

1. Modify `contents.Rmd`
2. Run `build.R`

This will regenerate the bookdown website under `docs/` and also regenerate the PDF version there.

Note that no intermediate or log files should be be left over in this directory (`docs-src/`) even after a successful build. If there are any, please remove them and investigate the reason.
