# This is a script of the updated visualization functions that should fix certain versions of
# cwl not visualizing or creating outputs

#### new_get_nodes() nests ####
#nested new_is_cwl_dict() function for testing
new_is_cwl_dict <- function (steps) {
  !is.null(names(steps))
}

#nested new_get_el_from_list nested in get_cwl_version_steps
new_get_el_from_list <- function (x, name){
  obj <- sapply(x, names)
  obj[sapply(obj, is.null)] <- NA
  obj
}

#new_get_edges() nested new_is_cwl_list() function - Can't seem to open and view default in package
#making assumption based off new_is_cwl_dict
new_is_cwl_list <-  function(steps) {
  is.null(names(steps)) & all(!sapply((sapply(steps, "[", "id")),
                                      is.null))
}

#new_get_steps_id nested in new_get_nodes
new_get_steps_id <- function (steps) {

  if (new_is_cwl_dict(steps)) {
    if(!is.null(steps$id)){
      id <- steps$id
    }else{
      id <- steps$label #added this label subset because not all workflows have id column 4.14.23
    }
  } else if (new_is_cwl_list(steps)) {
    id <- new_get_el_from_list(steps, "label")
  } else {
    stop("`steps` is not a proper dict or list")
  }
  id
}

# new_get_outputs_id nested in new_get_nodes()
new_get_outputs_id <- function (outputs) {
  if (new_is_cwl_dict(outputs)) {
    id <- outputs$id
  } else if (new_is_cwl_list(outputs)) {
    id <- new_get_el_from_list(outputs, "id")
  } else {
    stop("`outputs` is not a proper dict or list")
  }
  id
}

# new_get_inputs_id
new_get_inputs_id <- function (inputs) {
  if (new_is_cwl_dict(inputs)) {
    id <- inputs$id
  } else if (new_is_cwl_list(inputs)) {
    id <- new_get_el_from_list(inputs, "id")
  } else {
    stop("`inputs` is not a proper dict or list")
  }
  id
}

# new_get_steps_label
new_get_steps_label <- function (steps) {
  if (!is.null(steps$run)) {
    run <- steps$run
    if (new_is_cwl_dict(run)) {
      label <- run$label
    } else if (new_is_cwl_list(run)) {
      label <- new_get_el_from_list(run, "label")
    } else {
      stop("`steps$run` is not a proper dict or list")
    }
  } else {
    if (new_is_cwl_dict(steps)) {
      label <- steps$label
    } else if (new_is_cwl_list(steps)) {
      label <- new_get_el_from_list(steps, "label")
    } else {
      stop("`steps` is not a proper dict or list")
    }
  }
  label
}

# new_get_outputs_label
new_get_outputs_label <- function (outputs) {
  #Added this if statement in case workflow creators did not add a label column.
  #Without one the rows don't match when creating a data table for nodes of workflow.
  if(is.null(outputs$label)){
    outputs$label <- 'Stand In For BCO Creation - No Label Given In Workflow'
  }

  if (new_is_cwl_dict(outputs)) {
    label <- outputs$label
  } else if (new_is_cwl_list(outputs)) {
    label <- new_get_el_from_list(outputs, "label")
  } else {
    stop("`outputs` is not a proper dict or list")
  }
  label
}

# new_get_inputs_label
new_get_inputs_label <- function (inputs) {
  if (new_is_cwl_dict(inputs)) {
    label <- inputs$label
  } else if (new_is_cwl_list(inputs)) {
    label <- new_get_el_from_list(inputs, "label")
  } else {
    stop("`inputs` is not a proper dict or list")
  }
  label
}

# new_get_nodes() nested within new_get_graph
new_get_nodes <- function (inputs, outputs, steps){
  nodes <- data.frame(id = c(new_get_inputs_id(inputs), new_get_outputs_id(outputs),
                             new_get_steps_id(steps)), label = c(new_get_inputs_label(inputs),
                                                                 new_get_outputs_label(outputs), new_get_steps_label(steps)),
                      group = c(rep("input", length(new_get_inputs_id(inputs))),
                                rep("output", length(new_get_outputs_id(outputs))),
                                rep("step", length(new_get_steps_id(steps)))), stringsAsFactors = FALSE)
  nodes$id <- new_remove_hashtag(nodes$id)
  nodes
}

#### new_get_edges() nested functions and function ####

#nest read_edges_output function - changed '==' for version number to str_detect we've been using to capture all
new_read_edges_outputs <- function (output_source, outputs, cwl_version){
  #changed to str_detect to capture all versions of cwl. This was the reason some workflows weren't visualizing or generating bcos
  #This needs to be done for every nested function and funciton
  #Also need to change if statement for this to ifelse() to vectorize
  ifelse(str_detect(cwl_version, "v\\d+\\.\\d+") == T, sep <- "/", cwl_version)

  if("sbg:draft-2" %in% cwl_version){
    sep <- "\\."
  }

  df <- data.frame(from = character(), to = character(), port_from = character(),
                   port_to = character(), type = character(), stringsAsFactors = FALSE)

  outputs_id <- outputs %>% new_get_outputs_id()

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

  df %>% new_remove_hashtag_df()
}

#new_remove_hashtag_df nested in read_edges_output
new_remove_hashtag_df <- function (df){
  {
    for (i in 1:ncol(df)) df[, i] <- new_remove_hashtag(df[, i])
    df
  }
}

#new_remove_hashtag nested funciton within new_remove_hashtag_df....god why?
new_remove_hashtag <- function (x){
  idx <- which(substr(x, 1, 1) == "#")
  x[idx] <- substring(x[idx], 2)
  x
}

#nested new_read_edges_steps function within new_get_edges()
new_read_edges_steps <- function (steps_in, steps, cwl_version) {
  #changed to str_detect to capture all versions of cwl. This was the reason some workflows weren't visualizing or generating bcos
  #This needs to be done for every nested function and funciton
  #Also need to change if statement for this to ifelse() to vectorize
  ifelse(str_detect(cwl_version, "v\\d+\\.\\d+") == T, sep <- "/", '')

  if("sbg:draft-2" %in% cwl_version){
    sep <- "\\."
  }

  df <- data.frame(from = character(), to = character(), port_from = character(),
                   port_to = character(), type = character(), stringsAsFactors = FALSE)

  steps_id <- steps %>% new_get_steps_id()

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

  df %>% new_remove_hashtag_df()
}

#Function nested within new_get_edges() - changed to str_detect() to capture all versions
new_get_cwl_version_steps <- function (steps){

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

    if ("sbg:draft-2" %in% new_get_el_from_list(new_get_el_from_list(steps,
                                                                     "run"), "cwlVersion")){
      ver <- "sbg:draft-2"
    }
  }

  ver
}

#new_get_edges()
new_get_edges <- function (outputs, steps) {
  #changed to str_detect to capture all versions of cwl. This was the reason some workflows weren't visualizing or generating bcos
  #This needs to be done for every nested function and funciton
  #Also need to change if statement for this to ifelse() to vectorize
  ver <- new_get_cwl_version_steps(steps)

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

  if (new_is_cwl_dict(outputs)) {
    output_source <- unlist(outputs[[source_name]])
  } else if (new_is_cwl_list(outputs)) {
    output_source <- unlist(new_get_el_from_list(outputs, source_name))
  } else {
    stop("`outputs` is not a proper dict or list")
  }

  df_edges_outputs <- new_read_edges_outputs(output_source, outputs, ver)

  ifelse(str_detect(ver, "v\\d+\\.\\d+") == T,
         in_name <- "in", 'NA')

  #changed to %in% instead of == otherwise the function won't proceed cause of 'condition has length > 1 error
  #even if sbg:draft-2 isn't the version - so dumb
  if ("sbg:draft-2" %in% ver){
    in_name <- "inputs"
  }


  if (new_is_cwl_dict(steps)) {
    steps_in <- steps[[in_name]]
  } else if (new_is_cwl_list(steps)) {
    steps_in <- new_get_el_from_list(steps, in_name)
    for (i in 1:length(steps_in)) steps_in[[i]] <- as.data.frame(dplyr::bind_rows(steps_in[[i]]))
  } else {
    stop("`steps` is not a proper dict or list")
  }

  df_edges_steps <- new_read_edges_steps(steps_in, steps, ver)
  edges <- rbind(df_edges_steps, df_edges_outputs)
  edges
}

#### new_get_graph() ####
new_get_graph <- function (inputs, outputs, steps){
  new_nodes <- new_get_nodes(inputs, outputs, steps)
  new_edges <- new_get_edges(outputs, steps)
  list(nodes = new_nodes, edges = new_edges)
}

#### new_get_steps_doc ####
new_get_steps_doc <- function(steps){

  param <- NULL

  tryCatch(
    if(!is.null(steps$run$cwlVersion)){
      param <- ifelse(str_detect(steps$run$cwlVersion, 'v\\d+\\.\\d+') == T, "doc",
                      ifelse("sbg:draft-2" %in% c(steps$run$cwlVersion, steps$cwlVersion),
                             'description'))
    }else if(!is.null(steps$cwlVersion)){
      param <- ifelse(str_detect(steps$cwlVersion, 'v\\d+\\.\\d+') == T, "doc",
                      ifelse("sbg:draft-2" %in% c(steps$run$cwlVersion, steps$cwlVersion),
                             'description'))
    }
  )

  # if ("sbg:draft-2" %in% c(steps$run$cwlVersion, steps$cwlVersion)){
  #   param <- "description"
  # }

  if (is.null(param)) {
    param <- ifelse(str_detect(steps$run$cwlVersion, "v\\d+\\.\\d+"),
                    "doc", param)

    if ("sbg:draft-2" %in% new_get_el_from_list(new_get_el_from_list(steps,
                                                                     "run"), "cwlVersion"))
      param <- "description"
  }

  if (!is.null(steps$run)) {
    run <- steps$run

    if (new_is_cwl_dict(run)) {
      if(unique(param) %in% colnames(run)){ #Some of the workflow column positions get changed around or are missing. If statement added to change the level of subsetting with [ depending on if it can find param at all.
        desc <- run[param]

        if(is.null(desc)){
          desc <- 'No Description Given'
        }

      }else{ #If param is not in colnames then it is nested deeper in the table so need double [[
        desc <- run[[param]]

        if(is.null(desc)){
          desc <- 'No Description Given'
        }
      }

    }else if (new_is_cwl_list(run)) {
      desc <- new_get_el_from_list(run, param)
    } else {
      stop("`steps$run` is not a proper dict or list")
    }

  }else{

    if (new_is_cwl_dict(steps) == T) {
      desc <- steps[param]
      if(is.null(desc)){
        desc <- 'No Description Given'
      }
    } else if (new_is_cwl_list(steps) == T) {
      desc <- new_get_el_from_list(new_get_el_from_list(steps,
                                                        "run"), param)
    } else {
      stop("`steps` is not a proper dict or list")
    }
  }

  #some of the workflows have completely empty rows and this leads
  #to tables not rendering. This line removes the empty rows.
  desc <- desc[desc != ""]

  desc
}

new_get_steps_version <-  function(steps){
  if (!is.null(steps$run)) {
    run <- steps$run

    if (new_is_cwl_dict(run)) {
      version <- run$"cwlVersion" #was sbg:toolkitVersion - changing for all new_is_cwl_dict()
    } else if (new_is_cwl_list(run)) {
      version <- new_get_el_from_list(run, "sbg:toolkitVersion")
    } else {
      stop("`steps$run` is not a proper dict or list")
    }

  }else{

    if (new_is_cwl_dict(steps)) {
      version <- steps[["run"]][["cwlVersion"]]
    } else if (new_is_cwl_list(steps)) {
      version <- unlist(new_get_el_from_list(new_get_el_from_list(steps,
                                                                  "run"), "sbg:toolkitVersion"))
    } else {
      stop("`steps` is not a proper dict or list")
    }
  }

  version
}

#### Tables ####
#new_get_inputs_doc
new_get_inputs_desc <- function(inputs){

  desc <- NULL

  if (!is.null(inputs$doc)) {
    desc <- inputs$doc
  }else if (!is.null(inputs$description)){
    desc <- inputs$description
  }else{
    desc <- 'No Description For Inputs'
  }

  #some of the workflows have completely empty rows and this leads
  #to tables not rendering. This line removes the empty rows.
  desc <- desc[desc != ""]

  desc
}

#new_get_inputs_type
new_get_inputs_type <- function(inputs){

  if(!is.null(inputs$type)){
    inputs <- inputs %>% mutate(type = sapply(type, toString)) #type column is a nested list. I wanted to turn it to a column of characters or strings, preserving the comma separated input types
    input_type <- inputs$type
  }else{
    input_type <- 'na'
  }

  input_type
}

#get_new_inputs_filetype
get_new_inputs_filetype <- function(inputs){

  if(!is.null(inputs$'sbg:fileTypes')){
    inputs_filetype <- inputs$'sbg:fileTypes'
  }else{
    inputs_filetype <- 'na'
  }

  inputs_filetype
}

#get_new_inputs_default_val
get_new_inputs_default_val <- function(inputs){

  if(!is.null(inputs$'sbg:toolDefaultValue')){
    inputs_default <- inputs$'sbg:toolDefaultValue'
  }else{
    inputs_default <- 'na'
  }

  inputs_default
}

#outputs
#new_get_outputs_doc
new_get_outputs_desc <- function(outputs){

  desc <- NULL

  if (!is.null(outputs$doc)) {
    desc <- outputs$doc
  }else if (!is.null(outputs$description)){
    desc <- outputs$description
  }else{
    desc <- 'No Description For outputs'
  }

  #some of the workflows have completely empty rows and this leads
  #to tables not rendering. This line removes the empty rows.
  desc <- desc[desc != ""]

  desc
}

#new_get_outputs_type
new_get_outputs_type <- function(outputs){

  if(!is.null(outputs$type)){
    outputs <- outputs %>% mutate(type = sapply(type, toString)) #type column is a nested list. I wanted to turn it to a column of characters or strings, preserving the comma separated input types
    input_type <- outputs$type
  }else{
    input_type <- 'na'
  }

  input_type
}

#get_new_outputs_filetype
get_new_outputs_filetype <- function(outputs){

  if(!is.null(outputs$'sbg:fileTypes')){
    outputs_filetype <- outputs$'sbg:fileTypes'
  }else{
    outputs_filetype <- 'na'
  }

  outputs_filetype
}

#get_new_outputs_source
get_new_outputs_source <- function(outputs){

  if(!is.null(outputs$outputSource)){
    outputs_source <- outputs$outputSource
  }else{
    outputs_source <- 'na'
  }

  outputs_source
}
