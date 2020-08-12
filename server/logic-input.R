# fill inputs with info parsed from cwl

# 1. provenance

# name
observeEvent(get_rawcwl(), {
  updateTextInput(session, "provenance_name", value = tidycwl::parse_meta(get_rawcwl())$"label")
})

observeEvent(input$provenance_name, {
  if (nchar(input$provenance_name) >= 3) showFeedbackSuccess("provenance_name") else hideFeedback("provenance_name")
})

# version
observeEvent(get_rawcwl(), {
  updateTextInput(session, "provenance_version", value = paste0("1.0.", tidycwl::parse_meta(get_rawcwl())$"sbg:revision"))
})

observeEvent(input$provenance_version, {
  if (nchar(input$provenance_version) >= 5) showFeedbackSuccess("provenance_version") else hideFeedback("provenance_version")
})

# derived_from
observeEvent(get_rawcwl(), {
  updateTextInput(session, "provenance_derived_from", value = tidycwl::parse_meta(get_rawcwl())$"id")
})

observeEvent(input$provenance_derived_from, {
  if (nchar(input$provenance_derived_from) >= 0) showFeedbackSuccess("provenance_derived_from") else hideFeedback("provenance_derived_from")
})

# license
observeEvent(input$provenance_license, {
  if (nchar(input$provenance_license) >= 2) showFeedbackSuccess("provenance_license") else hideFeedback("provenance_license")
})

# review
df_review <- data.frame(
  "status" = factor(levels = c("unreviewed", "in-review", "approved", "suspended", "rejected")),
  "reviewer_comment" = character(),
  "date" = as.Date(integer(), origin = "1970-01-01"),
  "reviewer_name" = character(),
  "reviewer_affiliation" = character(),
  "reviewer_email" = character(),
  "reviewer_contribution" = character(),
  "reviewer_orcid" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
review_fname <- tempfile(fileext = ".rds")

review.insert.callback <- function(data, row) {
  df_review <- data #rbind(data, df_review)
  saveRDS(df_review, file = review_fname)
  return(df_review)
}

review.update.callback <- function(data, olddata, row) {
  df_review <- data
  saveRDS(df_review, file = review_fname)
  return(df_review)
}

review.delete.callback <- function(data, row) {
  df_review <- data[-row, ]
  saveRDS(df_review, file = review_fname)
  return(df_review)
}

DTedit::dtedit(
  input, output,
  name = "provenance_review",
  thedata = df_review,
  edit.label.cols = c(
    "Status", "Reviewer Comment", "Date", "Reviewer Name",
    "Affiliation", "Email",
    "Contribution", "ORCID"
  ),
  input.types = c(reviewer_comment = "textAreaInput"),
  callback.insert = review.insert.callback,
  callback.update = review.update.callback,
  callback.delete = review.delete.callback
)

# load the edited df
load_df_review <- reactive(if (file.exists(review_fname)) readRDS(review_fname) else NULL)

# contributors
df_contributors <- data.frame(
  "name" = character(),
  "affiliation" = character(),
  "email" = character(),
  "contribution" = character(),
  "orcid" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
contributors_fname <- tempfile(fileext = ".rds")

contributors.insert.callback <- function(data, row) {
  df_contributors <- data#rbind(data, df_contributors)
  saveRDS(df_contributors, file = contributors_fname)
  return(df_contributors)
}

contributors.update.callback <- function(data, olddata, row) {
  df_contributors <- data#[row, ] <- data[1, ]
  saveRDS(df_contributors, file = contributors_fname)
  return(df_contributors)
}

contributors.delete.callback <- function(data, row) {
  df_contributors <- data[-row, ]
  saveRDS(df_contributors, file = contributors_fname)
  return(df_contributors)
}

DTedit::dtedit(
  input, output,
  name = "provenance_contributors",
  thedata = df_contributors,
  edit.label.cols = c("Name", "Affiliation", "Email", "Contribution", "ORCID"),
  callback.insert = contributors.insert.callback,
  callback.update = contributors.update.callback,
  callback.delete = contributors.delete.callback
)

# load the edited df
load_df_contributors <- reactive(if (file.exists(contributors_fname)) readRDS(contributors_fname) else NULL)

# Get Visualization
output$vis_cwl_workflow <- renderVisNetwork({
  if(tidycwl::is_cwl(get_rawcwl()) ) {
    if(!is.null(get_rawcwl() %>% parse_inputs())) {
    tryCatch({get_graph(
              get_rawcwl() %>% parse_inputs(),
              get_rawcwl() %>% parse_outputs(),
              get_rawcwl() %>% parse_steps()
              ) %>% visualize_graph() %>%
                    visGroups(groupname = "input", color = "#E69F00", shadow = list(enabled = TRUE)) %>%
                    visGroups(groupname = "output", color = "#56B4E9", shadow = list(enabled = TRUE)) %>%
                    visGroups(groupname = "step", color = "#009E73", shadow = list(enabled = TRUE)) %>%
                    visLegend(width = 0.1, position = "right", main = "Legend") %>%
                    visInteraction(navigationButtons = TRUE)
            }, error = function(err){
              print("Could not prepare the visualizatoin data!")
              # give warning on the visual
              nodes <- data.frame(id = 1:5, label = c('Not', 'Valid', 'App', 'to', 'Visualize'), shape = c('text'))
              edges <- data.frame(from = c(1,2,3,4), to = c(2,3,4,5))
              visNetwork(nodes, edges) %>% visInteraction(navigationButtons = TRUE)
            })
    }
  }
})
# 2. usability

# text
observeEvent(get_rawcwl(), {
  updateTextAreaInput(session, "usability_text", value = tidycwl::parse_meta(get_rawcwl())$"description")
})

# 3.1 fhir

# fhir_endpoint
observeEvent(input$fhir_endpoint, {
  if (nchar(input$fhir_endpoint) >= 7) showFeedbackSuccess("fhir_endpoint") else hideFeedback("fhir_endpoint")
})

# fhir_version
observeEvent(input$fhir_version, {
  if (nchar(input$fhir_version) >= 1) showFeedbackSuccess("fhir_version") else hideFeedback("fhir_version")
})

# fhir_resources
df_fhir_resources <- data.frame(
  "id" = character(),
  "resource" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
fhir_resources_fname <- tempfile(fileext = ".rds")

fhir_resources.insert.callback <- function(data, row) {
  df_fhir_resources <- data#rbind(data, df_fhir_resources)
  saveRDS(df_fhir_resources, file = fhir_resources_fname)
  return(df_fhir_resources)
}

fhir_resources.update.callback <- function(data, olddata, row) {
  df_fhir_resources <- data#[row, ] <- data[1, ]
  saveRDS(df_fhir_resources, file = fhir_resources_fname)
  return(df_fhir_resources)
}

fhir_resources.delete.callback <- function(data, row) {
  df_fhir_resources <- data[-row, ]
  saveRDS(df_fhir_resources, file = fhir_resources_fname)
  return(df_fhir_resources)
}

DTedit::dtedit(
  input, output,
  name = "fhir_resources",
  thedata = df_fhir_resources,
  edit.label.cols = c("ID", "Resource"),
  callback.insert = fhir_resources.insert.callback,
  callback.update = fhir_resources.update.callback,
  callback.delete = fhir_resources.delete.callback
)

# load the edited df
load_df_fhir_resources <- reactive(if (file.exists(fhir_resources_fname)) readRDS(fhir_resources_fname) else NULL)

# 4. description

# platform
observeEvent(input$desc_platform, {
  if (nchar(input$desc_platform) >= 3) showFeedbackSuccess("desc_platform") else hideFeedback("desc_platform")
})

# keywords
observeEvent(input$desc_keywords, {
  if (nchar(input$desc_keywords) >= 3) showFeedbackSuccess("desc_keywords") else hideFeedback("desc_keywords")
})

# TODO: Fix that, no need to give blank row, added due to error in biocompute package
# xref
df_desc_xref <- data.frame(
  "namespace" = character(),
  "name" = character(),
  "ids" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_xref_fname <- tempfile(fileext = ".rds")

desc_xref.insert.callback <- function(data, row) {
  df_desc_xref <- data#rbind(data, df_desc_xref)
  saveRDS(df_desc_xref, file = desc_xref_fname)
  return(df_desc_xref)
}

desc_xref.update.callback <- function(data, olddata, row) {
  df_desc_xref <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_xref, file = desc_xref_fname)
  return(df_desc_xref)
}

desc_xref.delete.callback <- function(data, row) {
  df_desc_xref <- data[-row, ]
  saveRDS(df_desc_xref, file = desc_xref_fname)
  return(df_desc_xref)
}

DTedit::dtedit(
  input, output,
  name = "desc_xref",
  thedata = df_desc_xref,
  edit.label.cols = c("Namespace", "Name", "IDs", "Access Time"),
  callback.insert = desc_xref.insert.callback,
  callback.update = desc_xref.update.callback,
  callback.delete = desc_xref.delete.callback
)

# load the edited df
load_desc_xref <- reactive(if (file.exists(desc_xref_fname)) readRDS(desc_xref_fname) else NULL)

# pipeline_meta
load_desc_pipeline_meta <- reactive(
  if (!is.null(get_rawcwl() %>% parse_steps())) {
    data.frame(
      "step_number" = as.character(1:length(get_rawcwl() %>% parse_steps() %>% get_steps_id())),
      "name" = get_rawcwl() %>% parse_steps() %>% get_steps_id(),
      "description" = unlist({get_rawcwl() %>% parse_steps() %>% get_steps_doc()}),
      "version" = get_rawcwl() %>% parse_steps() %>% get_steps_version(),
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      "step_number" = character(),
      "name" = character(),
      "description" = character(),
      "version" = character(),
      stringsAsFactors = FALSE
    )
  }
)
output$desc_pipeline_meta <- DT::renderDT({
  load_desc_pipeline_meta()
})

# pipeline_prerequisite
df_desc_pipeline_prerequisite <- data.frame(
  "step_number" = character(),
  "name" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_prerequisite_fname <- tempfile(fileext = ".rds")

desc_pipeline_prerequisite.insert.callback <- function(data, row) {
  df_desc_pipeline_prerequisite <- data#rbind(data, df_desc_pipeline_prerequisite)
  saveRDS(df_desc_pipeline_prerequisite, file = desc_pipeline_prerequisite_fname)
  return(df_desc_pipeline_prerequisite)
}

desc_pipeline_prerequisite.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_prerequisite <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_prerequisite, file = desc_pipeline_prerequisite_fname)
  return(df_desc_pipeline_prerequisite)
}

desc_pipeline_prerequisite.delete.callback <- function(data, row) {
  df_desc_pipeline_prerequisite <- data[-row, ]
  saveRDS(df_desc_pipeline_prerequisite, file = desc_pipeline_prerequisite_fname)
  return(df_desc_pipeline_prerequisite)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_prerequisite",
  thedata = df_desc_pipeline_prerequisite,
  edit.label.cols = c("Step Number", "Name", "URI", "Access Time"),
  callback.insert = desc_pipeline_prerequisite.insert.callback,
  callback.update = desc_pipeline_prerequisite.update.callback,
  callback.delete = desc_pipeline_prerequisite.delete.callback
)

# load the edited df
load_desc_pipeline_prerequisite <- reactive(if (file.exists(desc_pipeline_prerequisite_fname)) readRDS(desc_pipeline_prerequisite_fname) else NULL)

# pipeline input
load_desc_pipeline_input <- reactive(
  if (!is.null(get_taskused()$step_number_input)) {
    data.frame(
      "step_number" = get_taskused()$step_number_input,
      "uri" = get_taskused()$input_path,
      "access_time" = get_taskused()$start_time,
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      "step_number" = character(),
      "uri" = character(),
      "access_time" = character(),
      stringsAsFactors = FALSE
    )
  }
)
output$desc_pipeline_input <- DT::renderDT({
  load_desc_pipeline_input()
})

# TODO: Fix that, no need to give blank row, added due to error in biocompute package
# pipeline input
# df_desc_pipeline_input <- data.frame(
#   "step_number" = as.character(),
#   "uri" = character(),
#   "access_time" = as.Date(integer(), origin = "1970-01-01"),
#   stringsAsFactors = FALSE
# )
#
# # tmp file storing the latest edited df
# desc_pipeline_input_fname <- tempfile(fileext = ".rds")
#
# desc_pipeline_input.insert.callback <- function(data, row) {
#   df_desc_pipeline_input <- data#rbind(data, df_desc_pipeline_input)
#   saveRDS(df_desc_pipeline_input, file = desc_pipeline_input_fname)
#   return(df_desc_pipeline_input)
# }
#
# desc_pipeline_input.update.callback <- function(data, olddata, row) {
#   df_desc_pipeline_input <- data#[row, ] <- data[1, ]
#   saveRDS(df_desc_pipeline_input, file = desc_pipeline_input_fname)
#   return(df_desc_pipeline_input)
# }
#
# desc_pipeline_input.delete.callback <- function(data, row) {
#   df_desc_pipeline_input <- data[-row, ]
#   saveRDS(df_desc_pipeline_input, file = desc_pipeline_input_fname)
#   return(df_desc_pipeline_input)
# }
#
# DTedit::dtedit(
#   input, output,
#   name = "desc_pipeline_input",
#   thedata = df_desc_pipeline_input,
#   edit.label.cols = c("Step Number", "URI", "Access Time"),
#   callback.insert = desc_pipeline_input.insert.callback,
#   callback.update = desc_pipeline_input.update.callback,
#   callback.delete = desc_pipeline_input.delete.callback
# )

# load the edited df
# load_desc_pipeline_input <- reactive(if (file.exists(desc_pipeline_input_fname)) readRDS(desc_pipeline_input_fname) else NULL)

# pipeline output
load_desc_pipeline_output <- reactive(
  if (!is.null(get_taskused()$step_number_output)) {
    data.frame(
      "step_number" = get_taskused()$step_number_output,
      "uri" = get_taskused()$output_path,
      "access_time" = get_taskused()$end_time,
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      "step_number" = character(),
      "uri" = character(),
      "access_time" = character(),
      stringsAsFactors = FALSE
    )
  }
)
output$desc_pipeline_output <- DT::renderDT({
  load_desc_pipeline_output()
})

# TODO: Fix that, no need to give blank row, added due to error in biocompute package
# pipeline output
# df_desc_pipeline_output <- data.frame(
#   "step_number" = character(),
#   "uri" = character(),
#   "access_time" = as.Date(integer(), origin = "1970-01-01"),
#   stringsAsFactors = FALSE
# )

# # tmp file storing the latest edited df
# desc_pipeline_output_fname <- tempfile(fileext = ".rds")
#
# desc_pipeline_output.insert.callback <- function(data, row) {
#   df_desc_pipeline_output <- data#rbind(data, df_desc_pipeline_output)
#   saveRDS(df_desc_pipeline_output, file = desc_pipeline_output_fname)
#   return(df_desc_pipeline_output)
# }
#
# desc_pipeline_output.update.callback <- function(data, olddata, row) {
#   df_desc_pipeline_output <- data#[row, ] <- data[1, ]
#   saveRDS(df_desc_pipeline_output, file = desc_pipeline_output_fname)
#   return(df_desc_pipeline_output)
# }
#
# desc_pipeline_output.delete.callback <- function(data, row) {
#   df_desc_pipeline_output <- data[-row, ]
#   saveRDS(df_desc_pipeline_output, file = desc_pipeline_output_fname)
#   return(df_desc_pipeline_output)
# }
#
# DTedit::dtedit(
#   input, output,
#   name = "desc_pipeline_output",
#   thedata = df_desc_pipeline_output,
#   edit.label.cols = c("Step Number", "URI", "Access Time"),
#   callback.insert = desc_pipeline_output.insert.callback,
#   callback.update = desc_pipeline_output.update.callback,
#   callback.delete = desc_pipeline_output.delete.callback
# )
#
# # load the edited df
# load_desc_pipeline_output <- reactive(if (file.exists(desc_pipeline_output_fname)) readRDS(desc_pipeline_output_fname) else NULL)

# 5. execution

# script
observeEvent(get_rawcwl(), {
  updateTextInput(session, "execution_script", value = tidycwl::parse_meta(get_rawcwl())$"id")
})

observeEvent(input$execution_script, {
  if (nchar(input$execution_script) >= 7) showFeedbackSuccess("execution_script") else hideFeedback("execution_script")
})

# script_driver
observeEvent(input$execution_script_driver, {
  if (nchar(input$execution_script_driver) >= 2) showFeedbackSuccess("execution_script_driver") else hideFeedback("execution_script_driver")
})

# execution_software_prerequisites
df_software_prerequisites <- data.frame(
  "name" = "Seven Bridges Platform",
  "version" = as.character(Sys.Date()),
  "uri" = "https://igor.sbgenomics.com/",
  "access_time" = Sys.Date(),
  "sha1_chksum" = c(""),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
software_prerequisites_fname <- tempfile(fileext = ".rds")

software_prerequisites.insert.callback <- function(data, row) {
  df_software_prerequisites <- data
  saveRDS(df_software_prerequisites, file = software_prerequisites_fname)
  return(df_software_prerequisites)
}

software_prerequisites.update.callback <- function(data, olddata, row) {
  df_software_prerequisites <- data
  saveRDS(df_software_prerequisites, file = software_prerequisites_fname)
  return(df_software_prerequisites)
}

software_prerequisites.delete.callback <- function(data, row) {
  df_software_prerequisites <- data[-row, ]
  saveRDS(df_software_prerequisites, file = software_prerequisites_fname)
  return(df_software_prerequisites)
}

DTedit::dtedit(
  input, output,
  name = "execution_software_prerequisites",
  thedata = df_software_prerequisites,
  edit.label.cols = c(
    "Name", "Version", "URI", "Access Time", "SHA1 Checkksum"
  ),
  callback.insert = software_prerequisites.insert.callback,
  callback.update = software_prerequisites.update.callback,
  callback.delete = software_prerequisites.delete.callback
)

# load the edited df
load_software_prerequisites <- reactive(if (file.exists(software_prerequisites_fname)) readRDS(software_prerequisites_fname) else NULL)

# execution_data_endpoints
df_data_endpoints <- data.frame(
  "name" = character(),
  "url" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
data_endpoints_fname <- tempfile(fileext = ".rds")

data_endpoints.insert.callback <- function(data, row) {
  df_data_endpoints <- data#rbind(data, df_data_endpoints)
  saveRDS(df_data_endpoints, file = data_endpoints_fname)
  return(df_data_endpoints)
}

data_endpoints.update.callback <- function(data, olddata, row) {
  df_data_endpoints <- data#[row, ] <- data[1, ]
  saveRDS(df_data_endpoints, file = data_endpoints_fname)
  return(df_data_endpoints)
}

data_endpoints.delete.callback <- function(data, row) {
  df_data_endpoints <- data[-row, ]
  saveRDS(df_data_endpoints, file = data_endpoints_fname)
  return(df_data_endpoints)
}

DTedit::dtedit(
  input, output,
  name = "execution_data_endpoints",
  thedata = df_data_endpoints,
  edit.label.cols = c("Name", "URL"),
  callback.insert = data_endpoints.insert.callback,
  callback.update = data_endpoints.update.callback,
  callback.delete = data_endpoints.delete.callback
)

# load the edited df
load_data_endpoints <- reactive(if (file.exists(data_endpoints_fname)) readRDS(data_endpoints_fname) else NULL)

# execution_environment_variables
df_environment_variables <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
environment_variables_fname <- tempfile(fileext = ".rds")

environment_variables.insert.callback <- function(data, row) {
  df_environment_variables <- data#rbind(data, df_environment_variables)
  saveRDS(df_environment_variables, file = environment_variables_fname)
  return(df_environment_variables)
}

environment_variables.update.callback <- function(data, olddata, row) {
  df_environment_variables <- data#[row, ] <- data[1, ]
  saveRDS(df_environment_variables, file = environment_variables_fname)
  return(df_environment_variables)
}

environment_variables.delete.callback <- function(data, row) {
  df_environment_variables <- data[-row, ]
  saveRDS(df_environment_variables, file = environment_variables_fname)
  return(df_environment_variables)
}

DTedit::dtedit(
  input, output,
  name = "execution_environment_variables",
  thedata = df_environment_variables,
  edit.label.cols = c("Key", "Value"),
  callback.insert = environment_variables.insert.callback,
  callback.update = environment_variables.update.callback,
  callback.delete = environment_variables.delete.callback
)

# load the edited df
load_environment_variables <- reactive(if (file.exists(environment_variables_fname)) readRDS(environment_variables_fname) else NULL)

# 6. parametric

df_parametric <- data.frame(
  "param" = character(),
  "value" = character(),
  "step" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
parametric_fname <- tempfile(fileext = ".rds")

parametric.insert.callback <- function(data, row) {
  df_parametric <- data
  saveRDS(df_parametric, file = parametric_fname)
  return(df_parametric)
}

parametric.update.callback <- function(data, olddata, row) {
  df_parametric <- data
  saveRDS(df_parametric, file = parametric_fname)
  return(df_parametric)
}

parametric.delete.callback <- function(data, row) {
  df_parametric <- data[-row, ]
  saveRDS(df_parametric, file = parametric_fname)
  return(df_parametric)
}

DTedit::dtedit(
  input, output,
  name = "parametric",
  thedata = df_parametric,
  edit.label.cols = c("Parameter", "Value", "Step Number"),
  callback.insert = parametric.insert.callback,
  callback.update = parametric.update.callback,
  callback.delete = parametric.delete.callback
)

# load the edited df
load_parametric <- reactive(if (file.exists(parametric_fname)) readRDS(parametric_fname) else NULL)
# 7. io
# input
load_input_subdomain <- reactive(
  if (!is.null(get_taskused()$input_name)) {
    data.frame(
      "filename" = get_taskused()$input_name,
      "uri" = get_taskused()$input_path,
      "access_time" = get_taskused()$start_time,
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      "filename" = character(),
      "uri" = character(),
      "access_time" = character(),
      stringsAsFactors = FALSE
    )
  }
)
output$io_input <- DT::renderDT({
  load_input_subdomain()
})
# # input
# df_input_subdomain <- data.frame(
#   "filename" = character(),
#   "uri" = character(),
#   "access_time" = as.Date(integer(), origin = "1970-01-01"),
#   stringsAsFactors = FALSE
# )
#
# # tmp file storing the latest edited df
# input_subdomain_fname <- tempfile(fileext = ".rds")
#
# input_subdomain.insert.callback <- function(data, row) {
#   df_input_subdomain <- rbind(data, df_input_subdomain)
#   saveRDS(df_input_subdomain, file = input_subdomain_fname)
#   return(df_input_subdomain)
# }
#
# input_subdomain.update.callback <- function(data, olddata, row) {
#   df_input_subdomain[row, ] <- data[1, ]
#   saveRDS(df_input_subdomain, file = input_subdomain_fname)
#   return(df_input_subdomain)
# }
#
# input_subdomain.delete.callback <- function(data, row) {
#   df_input_subdomain <- data[-row, ]
#   saveRDS(df_input_subdomain, file = input_subdomain_fname)
#   return(df_input_subdomain)
# }
#
# DTedit::dtedit(
#   input, output,
#   name = "io_input",
#   thedata = df_input_subdomain,
#   edit.label.cols = c("Filename", "URI", "Access Time"),
#   callback.insert = input_subdomain.insert.callback,
#   callback.update = input_subdomain.update.callback,
#   callback.delete = input_subdomain.delete.callback
# )
#
# # load the edited df
# load_input_subdomain <- reactive(if (file.exists(input_subdomain_fname)) readRDS(input_subdomain_fname) else NULL)

# output
load_output_subdomain <- reactive(
  if (!is.null(get_taskused()$output_mediatype)) {
    data.frame(
      "mediatype" = get_taskused()$output_mediatype,
      "uri" = get_taskused()$output_path,
      "access_time" = get_taskused()$end_time,
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      "mediatype" = character(),
      "uri" = character(),
      "access_time" = character(),
      stringsAsFactors = FALSE
    )
  }
)
output$io_output <- DT::renderDT({
  load_output_subdomain()
})

# df_output_subdomain <- data.frame(
#   "mediatype" = character(),
#   "uri" = character(),
#   "access_time" = as.Date(integer(), origin = "1970-01-01"),
#   stringsAsFactors = FALSE
# )
#
# # tmp file storing the latest edited df
# output_subdomain_fname <- tempfile(fileext = ".rds")
#
# output_subdomain.insert.callback <- function(data, row) {
#   df_output_subdomain <- rbind(data, df_output_subdomain)
#   saveRDS(df_output_subdomain, file = output_subdomain_fname)
#   return(df_output_subdomain)
# }
#
# output_subdomain.update.callback <- function(data, olddata, row) {
#   df_output_subdomain[row, ] <- data[1, ]
#   saveRDS(df_output_subdomain, file = output_subdomain_fname)
#   return(df_output_subdomain)
# }
#
# output_subdomain.delete.callback <- function(data, row) {
#   df_output_subdomain <- data[-row, ]
#   saveRDS(df_output_subdomain, file = output_subdomain_fname)
#   return(df_output_subdomain)
# }
#
# DTedit::dtedit(
#   input, output,
#   name = "io_output",
#   thedata = df_output_subdomain,
#   edit.label.cols = c("Media Type", "URI", "Access Time"),
#   callback.insert = output_subdomain.insert.callback,
#   callback.update = output_subdomain.update.callback,
#   callback.delete = output_subdomain.delete.callback
# )
#
# # load the edited df
# load_output_subdomain <- reactive(if (file.exists(output_subdomain_fname)) readRDS(output_subdomain_fname) else NULL)

# 8. error

# empirical
df_error_empirical <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
error_empirical_fname <- tempfile(fileext = ".rds")

error_empirical.insert.callback <- function(data, row) {
  df_error_empirical <- data#rbind(data, df_error_empirical)
  saveRDS(df_error_empirical, file = error_empirical_fname)
  return(df_error_empirical)
}

error_empirical.update.callback <- function(data, olddata, row) {
  df_error_empirical <- data#[row, ] <- data[1, ]
  saveRDS(df_error_empirical, file = error_empirical_fname)
  return(df_error_empirical)
}

error_empirical.delete.callback <- function(data, row) {
  df_error_empirical <- data[-row, ]
  saveRDS(df_error_empirical, file = error_empirical_fname)
  return(df_error_empirical)
}

DTedit::dtedit(
  input, output,
  name = "error_empirical",
  thedata = df_error_empirical,
  edit.label.cols = c("Key", "Value"),
  callback.insert = error_empirical.insert.callback,
  callback.update = error_empirical.update.callback,
  callback.delete = error_empirical.delete.callback
)

# load the edited df
load_error_empirical <- reactive(if (file.exists(error_empirical_fname)) readRDS(error_empirical_fname) else NULL)

# algorithmic
df_error_algorithmic <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
error_algorithmic_fname <- tempfile(fileext = ".rds")

error_algorithmic.insert.callback <- function(data, row) {
  df_error_algorithmic <- data#rbind(data, df_error_algorithmic)
  saveRDS(df_error_algorithmic, file = error_algorithmic_fname)
  return(df_error_algorithmic)
}

error_algorithmic.update.callback <- function(data, olddata, row) {
  df_error_algorithmic <- data#[row, ] <- data[1, ]
  saveRDS(df_error_algorithmic, file = error_algorithmic_fname)
  return(df_error_algorithmic)
}

error_algorithmic.delete.callback <- function(data, row) {
  df_error_algorithmic <- data[-row, ]
  saveRDS(df_error_algorithmic, file = error_algorithmic_fname)
  return(df_error_algorithmic)
}

DTedit::dtedit(
  input, output,
  name = "error_algorithmic",
  thedata = df_error_algorithmic,
  edit.label.cols = c("Key", "Value"),
  callback.insert = error_algorithmic.insert.callback,
  callback.update = error_algorithmic.update.callback,
  callback.delete = error_algorithmic.delete.callback
)

# load the edited df
load_error_algorithmic <- reactive(if (file.exists(error_algorithmic_fname)) readRDS(error_algorithmic_fname) else NULL)

# top level fields
observeEvent(input$bco_id, {
  if (nchar(input$bco_id) >= 7) showFeedbackSuccess("bco_id") else hideFeedback("bco_id")
})

# Git window
observe({
  toggleState(id = "push_yes",
              condition = (str_detect(input$urlRepo, regex("^(?:http(s)?://)?[\\w.-]+(?:\\.[\\w\\.-]+)+")) == TRUE) &
                (nchar(input$userName) > 3) & (nchar(input$passUser) > 5))
})

observeEvent(input$userName, {
  if (nchar(input$userName) > 3) showFeedbackSuccess("userName") else hideFeedback("userName")
})

observeEvent(input$passUser, {
  if (nchar(input$passUser) > 5) showFeedbackSuccess("passUser") else hideFeedback("passUser")
})

observeEvent(push_to_git(), {

  if (is.null(input$userName) || is.null(input$passUser) || is.null(input$repo_name)) {
    updateTextAreaInput(session, "git_text", value = "Please check your Username, password and URL!")
  } else {
    updateTextAreaInput(session, "git_text", value = push_to_git()$"summary")
  }
})
