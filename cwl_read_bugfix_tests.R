#Try yaml and cwl extensions
#Platform importer
library(tidyverse)

#Attempt to identify where the error is in the visualization
options(error=recover) #Turn on debugging mode
options(NULL) #Turn off debugging mode

#### This section is to troubleshoot the lexical error and files not loading####

#### The solution was to change get_raw_cwl inputcheck(input$upfile_local_composer) to inputcheck(input$upfile_local_composer$datapath) ####
#First I tested the get_cwl_local with the filepath string, then to address the incomplete final line error
file_path <- 'workflow_examples/DE_plus_Salmon.json'

#Test if function will load same object as above
#Function reconfigured from shinyapp inputs to regular inputs
get_cwl_local <- function(file_path, format = c('cwl', 'json', 'yaml')) {

  file.extension <- file_ext(file_path)
  format <- match.arg(file.extension, format)

  if(format == 'cwl' && configr::is.yaml.file(file_path)){
    return(read_cwl_yaml(file_path))
  } else if(format == 'cwl' && configr::is.json.file(file_path)){
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


input <- 'workflow_examples/DE_plus_Salmon.json' #need complete filepath to avoid error

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

inputcheck(input)

# get raw cwl
get_rawcwl_local <- function(x){
  cwl_out <- get_cwl_local(x, format = file_ext(x))
  cwl_out
}




#### This section is to test the visualizations ####
#Manually load cwl
cwl_obj <- read_cwl('workflow_examples/DE_plus_Salmon.json') # uploads and visualizes
cwl_obj_novis <- read_cwl('workflow_examples/encode_chip_seq_pipeline_2.json') # uploads but does not visualize

# Get Visualization - Function taken from logic-input-local.R line 178-200
# Non-working example - encode_chip_seq_pipeline_2.json, separated whats to the right
# of the arrow out of the function to create objects
# that are easier to work with and troubleshoot
novis_inputs <- cwl_obj_novis %>% parse_inputs()
novis_outputs <- cwl_obj_novis %>% parse_outputs()
novis_steps <- cwl_obj_novis %>% parse_steps()

#DE_plus_salmon working visualization
vis_inputs <- cwl_obj %>% parse_inputs()
vis_outputs <- cwl_obj %>% parse_outputs()
vis_steps <- cwl_obj %>% parse_steps()

#Mac - command + click to investigate the get_graph() function
get_graph <- function (inputs, outputs, steps){
  nodes <- get_nodes(inputs, outputs, steps)
  edges <- get_edges(outputs, steps)
  list(nodes = nodes, edges = edges)
  }

#test get_nodes line by line
inputs <- pathway_analysis %>% parse_inputs()
outputs <- pathway_analysis %>% parse_outputs()
steps <- pathway_analysis %>% parse_steps()

#### nested functions of get_nodes tested for error of not matching rows ####
# As I've had to rewrite or add to most of the functions in the tidycwl package for get_graph()
#You will have to add each function below to the global environment for other functions to run.
#They will not just run from the default package since they are all on this same R script.

#get_steps_id nested in get_nodes
get_steps_id <- function (steps) {
  if (is_cwl_dict(steps)) {
    id <- steps$id
  } else if (is_cwl_list(steps)) {
    id <- get_el_from_list(steps, "id")
  } else {
    stop("`steps` is not a proper dict or list")
  }
  id
}

#get_outputs_id nested in get_nodes()
get_outputs_id <- function (outputs) {
  if (is_cwl_dict(outputs)) {
    id <- outputs$id
  } else if (is_cwl_list(outputs)) {
    id <- get_el_from_list(outputs, "id")
  } else {
    stop("`outputs` is not a proper dict or list")
  }
  id
}

#get_inputs_id
get_inputs_id <- function (inputs) {
  if (is_cwl_dict(inputs)) {
    id <- inputs$id
  } else if (is_cwl_list(inputs)) {
    id <- get_el_from_list(inputs, "id")
  } else {
    stop("`inputs` is not a proper dict or list")
  }
  id
}

#get_steps_label
get_steps_label <- function (steps) {
  if (!is.null(steps$run)) {
    run <- steps$run
    if (is_cwl_dict(run)) {
      label <- run$label
    } else if (is_cwl_list(run)) {
      label <- get_el_from_list(run, "label")
    } else {
      stop("`steps$run` is not a proper dict or list")
    }
  } else {
    if (is_cwl_dict(steps)) {
      label <- steps$label
    } else if (is_cwl_list(steps)) {
      label <- get_el_from_list(steps, "label")
    } else {
      stop("`steps` is not a proper dict or list")
    }
  }
  label
}

#get_outputs_label
get_outputs_label <- function (outputs) {
  #Added this if statement in case workflow creators did not add a label column.
  #Without one the rows don't match when creating a data table for nodes of workflow.
  if(is.null(outputs$label)){
    outputs$label <- 'Stand In For BCO Creation - No Label Given In Workflow'
  }

  if (is_cwl_dict(outputs)) {
    label <- outputs$label
  } else if (is_cwl_list(outputs)) {
    label <- get_el_from_list(outputs, "label")
  } else {
    stop("`outputs` is not a proper dict or list")
  }
  label
}

#get_inputs_label
get_inputs_label <- function (inputs) {
  if (is_cwl_dict(inputs)) {
    label <- inputs$label
  } else if (is_cwl_list(inputs)) {
    label <- get_el_from_list(inputs, "label")
  } else {
    stop("`inputs` is not a proper dict or list")
  }
  label
}


#get_nodes() nested within get_graph
get_nodes <- function (inputs, outputs, steps){
  nodes <- data.frame(id = c(get_inputs_id(inputs), get_outputs_id(outputs),
                             get_steps_id(steps)), label = c(get_inputs_label(inputs),
                                                             get_outputs_label(outputs), get_steps_label(steps)),
                      group = c(rep("input", length(get_inputs_id(inputs))),
                                rep("output", length(get_outputs_id(outputs))),
                                rep("step", length(get_steps_id(steps)))), stringsAsFactors = FALSE)
  nodes$id <- remove_hashtag(nodes$id)
  nodes
}

# novis_nodes <- get_nodes(novis_inputs, novis_outputs, novis_steps)
# vis_nodes <- get_nodes(vis_inputs, vis_outputs, vis_steps)
# pathway_nodes <- get_nodes(path_inputs, path_outputs, path_steps)

#### Testing and changes to the get_edges function and its nested functions ####
#nodes table generates for novis fine. This section is to test the edges - Changed to str_detect to fix versioning issue

get_edges <- function (outputs, steps) {
  #changed to str_detect to capture all versions of cwl. This was the reason some workflows weren't visualizing or generating bcos
  #This needs to be done for every nested function and funciton
  #Also need to change if statement for this to ifelse() to vectorize
  ver <- get_cwl_version_steps(steps)

   #changed to %in% instead of == otherwise the function won't proceed cause of 'condition has length > 1 error
    #even if sbg:draft-2 isn't the version - so dumb
  ifelse(str_detect(ver, "v\\d+\\.\\d+") == T,
         source_name <- "outputSource", ifelse("sbg:draft-2" %in% ver, source_name <- "source", source_name)
          )

  #Attempt to account for workflows with more than 1 version found
  if(exists(source_name)){
    if (length(source_name > 1)){
       source_name <- unique(source_name)
        }
      }

  if (is_cwl_dict(outputs)) {
    output_source <- unlist(outputs[[source_name]])
  } else if (is_cwl_list(outputs)) {
    output_source <- unlist(get_el_from_list(outputs, source_name))
  } else {
    stop("`outputs` is not a proper dict or list")
  }

  df_edges_outputs <- read_edges_outputs(output_source, outputs, ver)

    ifelse(str_detect(ver, "v\\d+\\.\\d+") == T,
         in_name <- "in", 'NA')

    #changed to %in% instead of == otherwise the function won't proceed cause of 'condition has length > 1 error
    #even if sbg:draft-2 isn't the version - so dumb
    if ("sbg:draft-2" %in% ver){
    in_name <- "inputs"
    }


  if (is_cwl_dict(steps)) {
    steps_in <- steps[[in_name]]
  } else if (is_cwl_list(steps)) {
    steps_in <- get_el_from_list(steps, in_name)
    for (i in 1:length(steps_in)) steps_in[[i]] <- as.data.frame(dplyr::bind_rows(steps_in[[i]]))
  } else {
    stop("`steps` is not a proper dict or list")
  }

  df_edges_steps <- read_edges_steps(steps_in, steps, ver)
  edges <- rbind(df_edges_steps, df_edges_outputs)
  edges
}

  #get_edges() nested is_cwl_dict() function for testing
  is_cwl_dict <- function (steps) {
    !is.null(names(steps))
  }

  #get_edges() nested is_cwl_list() function
  is_cwl_list <-  function(steps) {
    is.null(names(steps)) & all(!sapply((sapply(steps, "[", "id")),
                                        is.null))
  }

#nest read_edges_output function - changed '==' for version number to str_detect we've been using to capture all
read_edges_outputs <- function (output_source, outputs, cwl_version){
  #changed to str_detect to capture all versions of cwl. This was the reason some workflows weren't visualizing or generating bcos
  #This needs to be done for every nested function and funciton
  #Also need to change if statement for this to ifelse() to vectorize
  ifelse(str_detect(cwl_version, "v\\d+\\.\\d+") == T, sep <- "/", cwl_version)

  if("sbg:draft-2" %in% cwl_version){
    sep <- "\\."
  }

  df <- data.frame(from = character(), to = character(), port_from = character(),
                   port_to = character(), type = character(), stringsAsFactors = FALSE)

  outputs_id <- outputs %>% get_outputs_id()

  for (i in 1:length(outputs_id)) {
    if (grepl(sep, output_source[i])) {
      val_vec <- strsplit(output_source[i], sep)[[1]]
      df[i, "from"] <- val_vec[1]
      df[i, "to"] <- outputs_id[i]
      df[i, "port_from"] <- val_vec[2]
      df[i, "port_to"] <- NA
      df[i, "type"] <- "step_to_output"
    }else{
      df[i, "from"] <- output_source[i]
      df[i, "to"] <- outputs_id[i]
      df[i, "port_from"] <- NA
      df[i, "port_to"] <- NA
      df[i, "type"] <- "step_to_output"
    }
  }

  df %>% remove_hashtag_df()
}

  #remove_hashtag_df nested in read_edges_output
    remove_hashtag_df <- function (df){
          {
            for (i in 1:ncol(df)) df[, i] <- remove_hashtag(df[, i])
            df
          }
        }

      #remove_hashtag nested funciton within remove_hashtag_df....god why?
        remove_hashtag <- function (x){
            idx <- which(substr(x, 1, 1) == "#")
            x[idx] <- substring(x[idx], 2)
            x
          }

  #nested read_edges_steps function within get_edges()
  read_edges_steps <- function (steps_in, steps, cwl_version) {
    #changed to str_detect to capture all versions of cwl. This was the reason some workflows weren't visualizing or generating bcos
    #This needs to be done for every nested function and funciton
    #Also need to change if statement for this to ifelse() to vectorize
    ifelse(str_detect(cwl_version, "v\\d+\\.\\d+") == T, sep <- "/", '')

    if("sbg:draft-2" %in% cwl_version){
      sep <- "\\."
    }

    df <- data.frame(from = character(), to = character(), port_from = character(),
                     port_to = character(), type = character(), stringsAsFactors = FALSE)

    steps_id <- steps %>% get_steps_id()

    for (i in 1:length(steps_in)) {
      steps_in[[i]][sapply(steps_in[[i]]$source, is.null),
                    "source"] <- NA
    }

    for (i in 1:length(steps_id)) {
      for (j in 1:nrow(steps_in[[i]])) {
        key <- steps_in[[i]][j, "id"]
        key_vec <- strsplit(key, sep)[[1]]
        val <- unlist(steps_in[[i]][j, "source"])
        for (k in 1:length(val)) {
          if (!is.na(val[k])) {
            if (grepl(sep, val[k])) {
              val_vec <- strsplit(val[k], sep)[[1]]
              tmp <- data.frame(from = val_vec[1], to = steps_id[i],
                                port_from = val_vec[2], port_to = key_vec[2],
                                type = "step_to_step", stringsAsFactors = FALSE)
              df <- rbind(df, tmp)
            }
            else {
              tmp <- data.frame(from = val[k], to = steps_id[i],
                                port_from = NA, port_to = key_vec[2],
                                type = "input_to_step", stringsAsFactors = FALSE)
              df <- rbind(df, tmp)
            }
          }
        }
      }
    }

    df %>% remove_hashtag_df()
  }

#Function nested within get_edges() - changed to str_detect() to capture all versions
get_cwl_version_steps <- function (steps){

  ver <- NULL

  ifelse(str_detect(steps$run$cwlVersion, "v\\d+\\.\\d+") == T,
         ver <- unique(steps$run$cwlVersion),
         ifelse(str_detect(steps$cwlVersion, "v\\d+\\.\\d+") == T,
                ver <- unique(steps$cwlVersion), ver)
          )

  if ("sbg:draft-2" %in% c(steps$run$cwlVersion, steps$cwlVersion)){
    ver <- "sbg:draft-2"
  }

  if (is.null(ver)) {
    ifelse(str_detect(steps$run$cwlVersion, "v\\d+\\.\\d+"),
           ver <- unique(steps$run$cwlVersion), ver)

    if ("sbg:draft-2" %in% get_el_from_list(get_el_from_list(steps,
                                                             "run"), "cwlVersion")){
      ver <- "sbg:draft-2"
    }
  }

  ver
}

get_cwl_version_steps(novis_steps)

  #get_el_from_list function nested in get_cwl_version_steps
  get_el_from_list <- function (x, name){
    obj <- sapply(x, names)
    obj[sapply(obj, is.null)] <- NA
    obj
  }

  #Finally, all the nested functions within get_edges have been rewritten and it works
  #redefine get_graph function
  get_graph <- function (inputs, outputs, steps){
    nodes <- get_nodes(inputs, outputs, steps)
    edges <- get_edges(outputs, steps)
    list(nodes = nodes, edges = edges)
  }

  #test the outputs
  get_graph(
    novis_inputs,
    novis_outputs,
    novis_steps
  ) %>% visualize_graph()

  #Now let's try the entire original function
  get_graph(
    cwl_obj_novis %>% parse_inputs(),
    cwl_obj_novis %>% parse_outputs(),
    cwl_obj_novis %>% parse_steps()
  ) %>% visualize_graph() %>%
      visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
      visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
      visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
      visLegend(width = 0.1, position = "right", main = "Legend") %>%
      visInteraction(navigationButtons = TRUE)

  #Wunderbar, now lets load up and test the other workflows
  get_graph(
    vis_inputs,
    vis_outputs,
    vis_steps
  ) %>% visualize_graph()

  get_graph(
    cwl_obj %>% parse_inputs(),
    cwl_obj %>% parse_outputs(),
    cwl_obj %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)

####load in other workflows with get_graph ####

  #neoepitode
  neoepitope <- get_rawcwl_local('workflow_examples/neoepitope-analysis-main-published.bco.json')

  get_graph(
    neoepitope %>% parse_inputs(),
    neoepitope %>% parse_outputs(),
    neoepitope %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)

  #pathway_analysis
  pathway_analysis <- read_cwl('workflow_examples/pathway_analysis.json')

  get_graph(
    pathway_analysis %>% parse_inputs(),
    pathway_analysis %>% parse_outputs(),
    pathway_analysis %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)

  #sars_cov
  sars_cov <- read_cwl('workflow_examples/sars_cov_wf.json')

  get_graph(
    sars_cov %>% parse_inputs(),
    sars_cov %>% parse_outputs(),
    sars_cov %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)

  #hisat2
  hisat2 <- read_cwl('workflow_examples/hisat2_stringtie.json')

  get_graph(
    hisat2 %>% parse_inputs(),
    hisat2 %>% parse_outputs(),
    hisat2 %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)

  #graf_germline
  graf_germline <- read_cwl('workflow_examples/graf_germline_variant_detection.json')

  get_graph(
    graf_germline %>% parse_inputs(),
    graf_germline %>% parse_outputs(),
    graf_germline %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)


  #broad preprocessing
  broad_data_preprocess <-  read_cwl('workflow_examples/broad_best_practice_data_pre_processing_workflow_4_1_0_0.json')
  get_graph(
    broad_data_preprocess %>% parse_inputs(),
    broad_data_preprocess %>% parse_outputs(),
    broad_data_preprocess %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)

  #broad rnaseq
  broad_rnaseq <- read_cwl('workflow_examples/broad-best-practices-rna-seq-variant-calling.json')

  get_graph(
    broad_rnaseq %>% parse_inputs(),
    broad_rnaseq %>% parse_outputs(),
    broad_rnaseq %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)

  #encode_chipseq
  encode_chip <- read_cwl('workflow_examples/encode_chip_seq_pipeline_2.json')

  get_graph(
    encode_chip %>% parse_inputs(),
    encode_chip %>% parse_outputs(),
    encode_chip %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)

  #fusion transcript
  fusion_transcript <- get_rawcwl_local('workflow_examples/fusion_transcript_detection_chimerascan.json')

  get_graph(
    get_rawcwl_local('workflow_examples/fusion_transcript_detection_chimerascan.json') %>% parse_inputs(),
    get_rawcwl_local('workflow_examples/fusion_transcript_detection_chimerascan.json') %>% parse_outputs(),
    get_rawcwl_local('workflow_examples/fusion_transcript_detection_chimerascan.json') %>% parse_steps()
  ) %>% visualize_graph() %>%
    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
    visLegend(width = 0.1, position = "right", main = "Legend") %>%
    visInteraction(navigationButtons = TRUE)








  #### line by line function tests ####
#Test inputs for get_edges() function line by line
ver <- get_cwl_version_steps(novis_inputs) #Here is where the Error in FUN(X[[i]], ...) : subscript out of bounds occurs
if (ver == "v1.0")
  source_name <- "outputSource"
if (ver == "sbg:draft-2")
  source_name <- "source"
if (is_cwl_dict(outputs)) {
  output_source <- unlist(outputs[[source_name]])
}
else if (is_cwl_list(outputs)) {
  output_source <- unlist(get_el_from_list(outputs, source_name))
}
else {
  stop("`outputs` is not a proper dict or list")
}
df_edges_outputs <- read_edges_outputs(output_source, outputs,
                                       ver)
if (ver == "v1.0")
  in_name <- "in"
if (ver == "sbg:draft-2")
  in_name <- "inputs"
if (is_cwl_dict(steps)) {
  steps_in <- steps[[in_name]]
}
else if (is_cwl_list(steps)) {
  steps_in <- get_el_from_list(steps, in_name)
  for (i in 1:length(steps_in)) steps_in[[i]] <- as.data.frame(dplyr::bind_rows(steps_in[[i]]))
}
else {
  stop("`steps` is not a proper dict or list")
}
df_edges_steps <- read_edges_steps(steps_in, steps, ver)
edges <- rbind(df_edges_steps, df_edges_outputs)
edges


#get_cwl_version_steps line by line
ver <- NULL
if ("v1.0" %in% c(novis_steps$run$cwlVersion, novis_steps$cwlVersion)){
  ver <- "v1.0"
  }
if ("sbg:draft-2" %in% c(novis_steps$run$cwlVersion, novis_steps$cwlVersion)){
  ver <- "sbg:draft-2"
  }
if (is.null(ver)) {
  if (str_detect(novis_steps$run$cwlVersion, "v\\d+\\.\\d+"){ #Subscript error here even though "run" and "cwlVersion are present
    ver <- unique(novis_steps$run$cwlVersion)
  }
  if ("sbg:draft-2" %in% get_el_from_list(get_el_from_list(steps,
                                                           "run"), "cwlVersion"))
    ver <- "sbg:draft-2"
}

ver

#get_el_from_list line by line
obj <- sapply(novis_steps, names)
obj[sapply(obj, is.null)] <- NA
obj

#Part of the original visualization function. Error message occurs before this so I separated it out for now.
  # %>%
  #         visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
  #         visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
  #         visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
  #         visLegend(width = 0.1, position = "right", main = "Legend") %>%
  #         visInteraction(navigationButtons = TRUE)
  #     }

#Part of the original visualization function. Error message occurs before this so I separated it out for now.
  # %>%
  #         visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
  #         visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
  #         visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
  #         visLegend(width = 0.1, position = "right", main = "Legend") %>%
  #         visInteraction(navigationButtons = TRUE)
  #     }

