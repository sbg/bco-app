#Try yaml and cwl extensions
#Platform importer

#Manually load cwl
cwl_obj <- read_cwl('workflow_examples/DE_plus_Salmon.json') #works correctly

#First I tested the get_cwl_local with the filepath string, then to address the incomplete final line error
file_path <- 'workflow_examples/DE_plus_Salmon.json'

#Test if function will load same object as above
get_cwl_local <- function(file_path, format = c('cwl', 'json', 'yaml')) {

  file.extension <- file_ext(file_path)
  format <- match.arg(file.extension)

  if(format == 'cwl' & configr::is.yaml.file(file_path)){
    return(read_cwl_yaml(file_path))
  }

  if(format == 'cwl' & configr::is.json.file(file_path)){
     return(read_cwl_json(file_path))
  }

  if(format == 'json'){
    return(read_cwl_json(file_path))
  }else if(format == 'yaml'){
    return(read_cwl_yaml(file_path))
  }
}

get_cwl_local('workflow_examples/DE_plus_Salmon.json') #There is an error here that reads as message in next line

#Warning message:
# In (function (con = stdin(), n = -1L, ok = TRUE, warn = TRUE, encoding = "unknown",  :
#                 incomplete final line found on 'workflow_examples/DE_plus_Salmon.json'

#Going to test the input_check funciton with cwl_obj I created on line 5

  cwl_out <- get_cwl_local("workflow_examples/DE_plus_Salmon.json", format = file_ext("DE_plus_Salmon.json"))


input.filepath <- 'workflow_examples/DE_plus_Salmon.json' #need complete filepath to avoid error

inputcheck <- function(input.filepath) {
  extension <- file_ext(input.filepath)
  flag.ext <- FALSE
  flag.cwl <- FALSE

  if (str_detect(extension,'json|cwl|yaml')) {
    print(paste("[INFO] Extention of input filepath:", extension))
    flag.ext <- TRUE

    if (extension == "yaml") {
      flow <- input.filepath %>% tidycwl::read_cwl(format = "yaml")
      cwl.version <- flow$cwlVersion
      if(str_detect(cwl.version, "v1\\.\\d*|sbg:draft-2")){
        flag.cwl <- TRUE
      }
    }
      if (extension %in% c("json", "cwl")) {
        flow <- input.filepath %>% tidycwl::read_cwl(format = "json")
        cwl.version <- flow$cwlVersion
        if(!is.null(cwl.version)){
          if(str_detect(cwl.version, "v1\\.\\d*|sbg:draft-2")){
            flag.cwl <- TRUE
          }
        }
      }

  }else{
    return(shinyalert('Unsupported File Type', "That filetype is not supported by the BCO app. Please select a .cwl, .yaml, or .json file.", type = 'error'))
  }

  if (flag.ext & flag.cwl == T) {
    return(TRUE)
  }else{
    return(FALSE)
  }
}

inputcheck(cwl_out)
