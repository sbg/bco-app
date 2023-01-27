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

observeEvent(input$upfile_local_composer, {
  if(str_detect(input$upfile_local_composer$name, 'bco.json') == T){
    return(shinyalert('Unsupported File Type', "That filetype is not supported by the BCO app. Please select a .cwl, .yaml, or .json file.", type = 'error'))
  }
}, ignoreNULL = T, ignoreInit = T)

# get raw cwl
get_rawcwl_local <- eventReactive(input$upfile_local_composer, {
  cwl_out <- get_cwl_local(input$upfile_local_composer$datapath, format = file_ext(input$upfile_local_composer$datapath))
})

#
# observeEvent(input$upfile_local_composer$datapath, {enable("btn_upfile_local_composer")})
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

# observeEvent(input$upfile_local_composer, {
#   print(input$upfile_local_composer)
#   # if(!is.null(input$upfile_local_composer) & file_ext(input$upfile_local_composer$datapath) != 'json'){
#   #
#   #        # | file_ext(input$upfile_local_composer) != 'yaml' | file_ext(input$upfile_local_composer) != 'json' | file_ext(input$upfile_local_composer) == 'bco.json',
#   #   return(shinyalert('Unsupported File Type', "That filetype is not supported by the BCO app. Please select a .cwl, .yaml, or .json file.", type = 'error'))
#   # }
#   if (is.null(input$upfile_local_composer)) {
#     return(NULL)
#     }else{
#     if(file_ext(input$upfile_local_composer$datapath) != 'json'){
#       return(shinyalert('Unsupported File Type', "That filetype is not supported by the BCO app. Please select a .cwl, .yaml, or .json file.", type = 'error'))
#     }
#   }
# }, ignoreNULL = F)

# get raw cwl
get_rawcwl_local <- eventReactive(input$upfile_local_composer, {
  cwl_out <- get_cwl_local(input$upfile_local_composer$datapath, format = file_ext(input$upfile_local_composer$datapath))
})

#
# observeEvent(input$upfile_local_composer$datapath, {enable("btn_upfile_local_composer")})
