library("tidycwl")
library('tools')
# Test Input File
input.example.1 <- "workflow_examples/broad-best-practices-rna-seq-variant-calling.json"
input.example.2 <- "~/Documents/rnaseq-test.bco.json"

# STEP 1 - BASIC tidycwl TEST

# First, test it basically
flow <- input.example.1 %>%
  tidycwl::read_cwl_yaml()
flow

# Print Class
print(flow$class)
# Print CWL Version
print(flow$cwlVersion)

# STEP 2 - FUNCTION

# Drafted Function, v1
# TODO: test it creafully, Phil
inputcheck <- function(input.filepath) {
  extension <- file_ext(input.filepath)
  flag.ext <- FALSE
  flag.cwl <- FALSE

  if (extension %in% c('json', 'cwl', 'yaml')) {
    print(paste("[INFO] Extention of input filepath:", extension))
    flag.ext <- TRUE

    if (extension == "yaml") {
      flow <- input.filepath %>% tidycwl::read_cwl(format = "yaml")
      cwl.version <- flow$cwlVersion
      if (cwl.version %in% c("sbg:draft-2 ", "v1.0")) {
        flag.cwl <- TRUE
      }
    }

    if (extension %in% c("json", "cwl")) {
      flow <- input.filepath %>% tidycwl::read_cwl(format = "json")
      cwl.version <- flow$cwlVersion
      if(!is.null(cwl.version)){
        if (cwl.version %in% c("sbg:draft-2 ", "v1.0")) {
          flag.cwl <- TRUE
        }
      }else{
        print(paste('While this file has a .json extension, it is not the correct file type.'))
      }
    }

  }else{
    return(shinyalert('Unsupported File Type', "That filetype is not supported by the BCO app. Please select a .cwl, .yaml, or .json file.", type = 'error'))
  }

   if (flag.ext & flag.cwl) {
  return(TRUE)
  }else{
  return(FALSE)
  }
}

# Run function to get T or F flag to use in downstram Shiny staff
inputcheck(input.example.1)







