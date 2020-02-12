get_cwl_local <- function(file_path, format=c('cwl', 'json', 'yaml')) {
  # out <- tryCatch({
    format <- match.arg(format)
    if (format == 'cwl') {
      return(read_cwl_yaml(file_path))
    }
    if (format == 'json') {
      return(read_cwl_json(file_path))
    }
    if (format == 'yaml') {
      return(read_cwl_yaml(file_path))
    }
}
# get raw cwl
get_rawcwl_local <- eventReactive(input$upfile_local_composer, {
  cwl_out <- get_cwl_local(input$upfile_local_composer$datapath, format = file_ext(input$upfile_local_composer$datapath))
})

#
# observeEvent(input$upfile_local_composer$datapath, {enable("btn_upfile_local_composer")})