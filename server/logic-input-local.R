# fill inputs with info parsed from cwl

# 1. provenance

# name
observeEvent(get_rawcwl_local(), {
  updateTextInput(session, "provenance_name_local", value = tidycwl::parse_meta(get_rawcwl_local())$"label")
})

observeEvent(input$provenance_name_local, {
  if (nchar(input$provenance_name_local) >= 3) showFeedbackSuccess("provenance_name_local") else hideFeedback("provenance_name_local")
})

# version
observeEvent(get_rawcwl_local(), {
  updateTextInput(session, "provenance_version_local", value = paste0("1.0.", tidycwl::parse_meta(get_rawcwl_local())$"sbg:revision"))
})

observeEvent(input$provenance_version_local, {
  if (nchar(input$provenance_version_local) >= 5) showFeedbackSuccess("provenance_version_local") else hideFeedback("provenance_version_local")
})

# derived_from
observeEvent(get_rawcwl_local(), {
  updateTextInput(session, "provenance_derived_from_local", value = tidycwl::parse_meta(get_rawcwl_local())$"id")
})

observeEvent(input$provenance_derived_from_local, {
  if (nchar(input$provenance_derived_from_local) >= 0) showFeedbackSuccess("provenance_derived_from_local") else hideFeedback("provenance_derived_from_local")
})

# license
observeEvent(input$provenance_license_local, {
  if (nchar(input$provenance_license_local) >= 2) showFeedbackSuccess("provenance_license_local") else hideFeedback("provenance_license_local")
})

# review
df_review_local <- data.frame(
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
review_fname_local <- tempfile(fileext = ".rds")

review_local.insert.callback <- function(data, row) {
  df_review_local <- data#rbind(data, df_review_local)
  saveRDS(df_review_local, file = review_fname_local)
  return(df_review_local)
}

review_local.update.callback <- function(data, olddata, row) {
  df_review_local <- data#[row, ] <- data[1, ]
  saveRDS(df_review_local, file = review_fname_local)
  return(df_review_local)
}

review_local.delete.callback <- function(data, row) {
  df_review_local <- data[-row, ]
  saveRDS(df_review_local, file = review_fname_local)
  return(df_review_local)
}

DTedit::dtedit(
  input, output,
  name = "provenance_review_local",
  thedata = df_review_local,
  edit.label.cols = c(
    "Status", "Reviewer Comment", "Date", "Reviewer Name",
    "Affiliation", "Email",
    "Contribution", "ORCID"
  ),
  input.types = c(reviewer_comment = "textAreaInput"),
  callback.insert = review_local.insert.callback,
  callback.update = review_local.update.callback,
  callback.delete = review_local.delete.callback
)

# load the edited df
load_df_review_local <- reactive(if (file.exists(review_fname_local)) readRDS(review_fname_local) else NULL)

# contributors
df_contributors_local <- data.frame(
  "name" = character(),
  "affiliation" = character(),
  "email" = character(),
  "contribution" = character(),
  "orcid" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
contributors_fname_local <- tempfile(fileext = ".rds")

contributors_local.insert.callback <- function(data, row) {
  df_contributors_local <- data#rbind(data, df_contributors_local)
  saveRDS(df_contributors_local, file = contributors_fname_local)
  return(df_contributors_local)
}

contributors_local.update.callback <- function(data, olddata, row) {
  df_contributors_local[row, ] <- data
  saveRDS(df_contributors_local, file = contributors_fname_local)
  return(df_contributors_local)
}

contributors_local.delete.callback <- function(data, row) {
  df_contributors_local <- data[-row, ]
  saveRDS(df_contributors_local, file = contributors_fname_local)
  return(df_contributors_local)
}

DTedit::dtedit(
  input, output,
  name = "provenance_contributors_local",
  thedata = df_contributors_local,
  edit.label.cols = c("Name", "Affiliation", "Email", "Contribution", "ORCID"),
  callback.insert = contributors_local.insert.callback,
  callback.update = contributors_local.update.callback,
  callback.delete = contributors_local.delete.callback
)

# load the edited df
load_df_contributors_local <- reactive(if (file.exists(contributors_fname_local)) readRDS(contributors_fname_local) else NULL)

# contributors
df_contributors_local <- data.frame(
  "name" = character(),
  "affiliation" = character(),
  "email" = character(),
  "contribution" = character(),
  "orcid" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
contributors_fname_local <- tempfile(fileext = ".rds")

contributors_local.insert.callback <- function(data, row) {
  df_contributors <- data#rbind(data, df_contributors)
  saveRDS(df_contributors, file = contributors_fname)
  return(df_contributors)
}

contributors_local.update.callback <- function(data, olddata, row) {
  df_contributors <- data#[row, ] <- data[1, ]
  saveRDS(df_contributors, file = contributors_fname)
  return(df_contributors)
}

contributors_local.delete.callback <- function(data, row) {
  df_contributors <- data[-row, ]
  saveRDS(df_contributors, file = contributors_fname)
  return(df_contributors)
}

DTedit::dtedit(
  input, output,
  name = "provenance_contributors_local",
  thedata = df_contributors,
  edit.label.cols = c("Name", "Affiliation", "Email", "Contribution", "ORCID"),
  callback.insert = contributors_local.insert.callback,
  callback.update = contributors_local.update.callback,
  callback.delete = contributors_local.delete.callback
)

# load the edited df
load_df_contributors_local <- reactive(if (file.exists(contributors_fname)) readRDS(contributors_fname) else NULL)

# Get Visualization
output$vis_cwl_workflow_local <- renderVisNetwork({
  if(tidycwl::is_cwl(get_rawcwl_local())) {
    if(!is.null(get_rawcwl_local() %>% parse_inputs())) {
      tryCatch({get_graph(
        get_rawcwl_local() %>% parse_inputs(),
        get_rawcwl_local() %>% parse_outputs(),
        get_rawcwl_local() %>% parse_steps()
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
observeEvent(get_rawcwl_local(), {
  updateTextAreaInput(session, "usability_text_local", value = tidycwl::parse_meta(get_rawcwl_local())$"description")
})

# 3.1 fhir

# fhir_endpoint
observeEvent(input$fhir_endpoint_local, {
  if (nchar(input$fhir_endpoint_local) >= 7) showFeedbackSuccess("fhir_endpoint_local") else hideFeedback("fhir_endpoint_local")
})

# fhir_version
observeEvent(input$fhir_version_local, {
  if (nchar(input$fhir_version_local) >= 1) showFeedbackSuccess("fhir_version_local") else hideFeedback("fhir_version_local")
})

# fhir_resources
df_fhir_resources_local <- data.frame(
  "id" = character(),
  "resource" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
fhir_resources_fname_local <- tempfile(fileext = ".rds")

fhir_resources_local.insert.callback <- function(data, row) {
  df_fhir_resources_local <- data#rbind(data, df_fhir_resources_local)
  saveRDS(df_fhir_resources_local, file = fhir_resources_fname_local)
  return(df_fhir_resources_local)
}

fhir_resources_local.update.callback <- function(data, olddata, row) {
  df_fhir_resources_local <- data#[row, ] <- data[1, ]
  saveRDS(df_fhir_resources_local, file = fhir_resources_fname_local)
  return(df_fhir_resources_local)
}

fhir_resources_local.delete.callback <- function(data, row) {
  df_fhir_resources_local <- data[-row, ]
  saveRDS(df_fhir_resources_local, file = fhir_resources_fname_local)
  return(df_fhir_resources_local)
}

DTedit::dtedit(
  input, output,
  name = "fhir_resources_local",
  thedata = df_fhir_resources_local,
  edit.label.cols = c("ID", "Resource"),
  callback.insert = fhir_resources_local.insert.callback,
  callback.update = fhir_resources_local.update.callback,
  callback.delete = fhir_resources_local.delete.callback
)

# load the edited df
load_df_fhir_resources_local <- reactive(if (file.exists(fhir_resources_fname_local)) readRDS(fhir_resources_fname_local) else NULL)

# 4. description

# platform
observeEvent(input$desc_platform_local, {
  if (nchar(input$desc_platform_local) >= 3) showFeedbackSuccess("desc_platform_local") else hideFeedback("desc_platform_local")
})

# keywords
observeEvent(input$desc_keywords_local, {
  if (nchar(input$desc_keywords_local) >= 3) showFeedbackSuccess("desc_keywords_local") else hideFeedback("desc_keywords_local")
})

# xref
df_desc_xref_local <- data.frame(
  "namespace" = character(),
  "name" = character(),
  "ids" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_xref_fname_local <- tempfile(fileext = ".rds")

desc_xref_local.insert.callback <- function(data, row) {
  df_desc_xref_local <- data#rbind(data, df_desc_xref_local)
  saveRDS(df_desc_xref_local, file = desc_xref_fname_local)
  return(df_desc_xref_local)
}

desc_xref_local.update.callback <- function(data, olddata, row) {
  df_desc_xref_local[row, ] <- data#data[1, ]
  saveRDS(df_desc_xref_local, file = desc_xref_fname_local)
  return(df_desc_xref_local)
}

desc_xref_local.delete.callback <- function(data, row) {
  df_desc_xref_local <- data[-row, ]
  saveRDS(df_desc_xref_local, file = desc_xref_fname_local)
  return(df_desc_xref_local)
}

DTedit::dtedit(
  input, output,
  name = "desc_xref_local",
  thedata = df_desc_xref_local,
  edit.label.cols = c("Namespace", "Name", "IDs", "Access Time"),
  callback.insert = desc_xref_local.insert.callback,
  callback.update = desc_xref_local.update.callback,
  callback.delete = desc_xref_local.delete.callback
)

# load the edited df
load_desc_xref_local <- reactive(if (file.exists(desc_xref_fname_local)) readRDS(desc_xref_fname_local) else NULL)

# pipeline_meta
load_desc_pipeline_meta_local <- reactive(
  if (!is.null(get_rawcwl_local() %>% parse_steps())) {
    data.frame(
      "step_number" = as.character(1:length(get_rawcwl_local() %>% parse_steps() %>% get_steps_id())),
      "name" = get_rawcwl_local() %>% parse_steps() %>% get_steps_id(),
      "description" = unlist(get_rawcwl_local() %>% parse_steps() %>% get_steps_doc()),
      "version" = get_rawcwl_local() %>% parse_steps() %>% get_steps_version(),
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
output$desc_pipeline_meta_local <- DT::renderDT({
  load_desc_pipeline_meta_local()
})

# df_desc_pipeline_meta_local <- data.frame(
#   "step_number" = character(),
#   "name" = character(),
#   "description" = character(),
#   "version" = character(),
#   stringsAsFactors = FALSE
# )

# # tmp file storing the latest edited df
# desc_pipeline_meta_fname_local <- tempfile(fileext = ".rds")
#
# desc_pipeline_meta_local.insert.callback <- function(data, row) {
#   df_desc_pipeline_meta_local <- rbind(data, df_desc_pipeline_meta_local)
#   saveRDS(df_desc_pipeline_meta_local, file = desc_pipeline_meta_fname_local)
#   return(df_desc_pipeline_meta_local)
# }
#
# desc_pipeline_meta_local.update.callback <- function(data, olddata, row) {
#   df_desc_pipeline_meta_local[row, ] <- data[1, ]
#   saveRDS(df_desc_pipeline_meta_local, file = desc_pipeline_meta_fname_local)
#   return(df_desc_pipeline_meta_local)
# }
#
# desc_pipeline_meta_local.delete.callback <- function(data, row) {
#   df_desc_pipeline_meta_local <- df_desc_pipeline_meta_local[-row, ]
#   saveRDS(df_desc_pipeline_meta_local, file = desc_pipeline_meta_fname_local)
#   return(df_desc_pipeline_meta_local)
# }
#
# DTedit::dtedit(
#   input, output,
#   name = "desc_pipeline_meta_local",
#   thedata = df_desc_pipeline_meta_local,
#   edit.label.cols = c("Namespace", "Name", "IDs", "Access Time"),
#   callback.insert = desc_pipeline_meta_local.insert.callback,
#   callback.update = desc_pipeline_meta_local.update.callback,
#   callback.delete = desc_pipeline_meta_local.delete.callback
# )
#
# # load the edited df
# load_desc_pipeline_meta_local <- reactive(if (file.exists(desc_pipeline_meta_fname_local)) readRDS(desc_pipeline_meta_fname_local) else NULL)

# pipeline_prerequisite
df_desc_pipeline_prerequisite_local <- data.frame(
  "step_number" = character(),
  "name" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_prerequisite_fname_local <- tempfile(fileext = ".rds")

desc_pipeline_prerequisite_local.insert.callback <- function(data, row) {
  df_desc_pipeline_prerequisite_local <- data#rbind(data, df_desc_pipeline_prerequisite_local)
  saveRDS(df_desc_pipeline_prerequisite_local, file = desc_pipeline_prerequisite_fname_local)
  return(df_desc_pipeline_prerequisite_local)
}

desc_pipeline_prerequisite_local.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_prerequisite_local <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_prerequisite_local, file = desc_pipeline_prerequisite_fname_local)
  return(df_desc_pipeline_prerequisite_local)
}

desc_pipeline_prerequisite_local.delete.callback <- function(data, row) {
  df_desc_pipeline_prerequisite_local <- data[-row, ]
  saveRDS(df_desc_pipeline_prerequisite_local, file = desc_pipeline_prerequisite_fname_local)
  return(df_desc_pipeline_prerequisite_local)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_prerequisite_local",
  thedata = df_desc_pipeline_prerequisite_local,
  edit.label.cols = c("Step Number", "Name", "URI", "Access Time"),
  callback.insert = desc_pipeline_prerequisite_local.insert.callback,
  callback.update = desc_pipeline_prerequisite_local.update.callback,
  callback.delete = desc_pipeline_prerequisite_local.delete.callback
)

# load the edited df
load_desc_pipeline_prerequisite_local <- reactive(if (file.exists(desc_pipeline_prerequisite_fname_local)) readRDS(desc_pipeline_prerequisite_fname_local) else NULL)

# pipeline input
df_desc_pipeline_input_local <- data.frame(
  "step_number" = as.character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_input_fname_local <- tempfile(fileext = ".rds")

desc_pipeline_input_local.insert.callback <- function(data, row) {
  df_desc_pipeline_input_local <- data#rbind(data, df_desc_pipeline_input_local)
  saveRDS(df_desc_pipeline_input_local, file = desc_pipeline_input_fname_local)
  return(df_desc_pipeline_input_local)
}

desc_pipeline_input_local.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_input_local <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_input_local, file = desc_pipeline_input_fname_local)
  return(df_desc_pipeline_input_local)
}

desc_pipeline_input_local.delete.callback <- function(data, row) {
  df_desc_pipeline_input_local <- data[-row, ]
  saveRDS(df_desc_pipeline_input_local, file = desc_pipeline_input_fname_local)
  return(df_desc_pipeline_input_local)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_input_local",
  thedata = df_desc_pipeline_input_local,
  edit.label.cols = c("Step Number", "URI", "Access Time"),
  callback.insert = desc_pipeline_input_local.insert.callback,
  callback.update = desc_pipeline_input_local.update.callback,
  callback.delete = desc_pipeline_input_local.delete.callback
)

# load the edited df
load_desc_pipeline_input_local <- reactive(if (file.exists(desc_pipeline_input_fname_local)) readRDS(desc_pipeline_input_fname_local) else NULL)


# pipeline output
df_desc_pipeline_output_local <- data.frame(
  "step_number" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_output_fname_local <- tempfile(fileext = ".rds")

desc_pipeline_output_local.insert.callback <- function(data, row) {
  df_desc_pipeline_output_local <- data#rbind(data, df_desc_pipeline_output_local)
  saveRDS(df_desc_pipeline_output_local, file = desc_pipeline_output_fname_local)
  return(df_desc_pipeline_output_local)
}

desc_pipeline_output_local.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_output_local <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_output_local, file = desc_pipeline_output_fname_local)
  return(df_desc_pipeline_output_local)
}

desc_pipeline_output_local.delete.callback <- function(data, row) {
  df_desc_pipeline_output_local <- data[-row, ]
  saveRDS(df_desc_pipeline_output_local, file = desc_pipeline_output_fname_local)
  return(df_desc_pipeline_output_local)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_output_local",
  thedata = df_desc_pipeline_output_local,
  edit.label.cols = c("Step Number", "URI", "Access Time"),
  callback.insert = desc_pipeline_output_local.insert.callback,
  callback.update = desc_pipeline_output_local.update.callback,
  callback.delete = desc_pipeline_output_local.delete.callback
)

# load the edited df
load_desc_pipeline_output_local <- reactive(if (file.exists(desc_pipeline_output_fname_local)) readRDS(desc_pipeline_output_fname_local) else NULL)

# 5. execution

# script
observeEvent(get_rawcwl_local(), {
  updateTextInput(session, "execution_script_local", value = tidycwl::parse_meta(get_rawcwl_local())$"id")
})

observeEvent(input$execution_script_local, {
  if (nchar(input$execution_script_local) >= 7) showFeedbackSuccess("execution_script_local") else hideFeedback("execution_script_local")
})

# script_driver
observeEvent(input$execution_script_driver_local, {
  if (nchar(input$execution_script_driver_local) >= 2) showFeedbackSuccess("execution_script_driver_local") else hideFeedback("execution_script_driver_local")
})

# execution_software_prerequisites
df_software_prerequisites_local <- data.frame(
  "name" = "Seven Bridges Platform",
  "version" = as.character(Sys.Date()),
  "uri" = "https://igor.sbgenomics.com/",
  "access_time" = Sys.Date(),
  "sha1_chksum" = c(""),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
software_prerequisites_fname_local <- tempfile(fileext = ".rds")

software_prerequisites_local.insert.callback <- function(data, row) {
  df_software_prerequisites_local <- data#rbind(data, df_software_prerequisites_local)
  saveRDS(df_software_prerequisites_local, file = software_prerequisites_fname_local)
  return(df_software_prerequisites_local)
}

software_prerequisites_local.update.callback <- function(data, olddata, row) {
  df_software_prerequisites_local <- data#[row, ] <- data[1, ]
  saveRDS(df_software_prerequisites_local, file = software_prerequisites_fname_local)
  return(df_software_prerequisites_local)
}

software_prerequisites_local.delete.callback <- function(data, row) {
  df_software_prerequisites_local <- data[-row, ]
  saveRDS(df_software_prerequisites_local, file = software_prerequisites_fname_local)
  return(df_software_prerequisites_local)
}

DTedit::dtedit(
  input, output,
  name = "execution_software_prerequisites_local",
  thedata = df_software_prerequisites_local,
  edit.label.cols = c(
    "Name", "Version", "URI", "Access Time", "SHA1 Checkksum"
  ),
  callback.insert = software_prerequisites_local.insert.callback,
  callback.update = software_prerequisites_local.update.callback,
  callback.delete = software_prerequisites_local.delete.callback
)

# load the edited df
load_software_prereq_local <- reactive(if (file.exists(software_prerequisites_fname_local)) readRDS(software_prerequisites_fname_local) else NULL)

# execution_data_endpoints
df_data_endpoints_local <- data.frame(
  "name" = character(),
  "url" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
data_endpoints_fname_local <- tempfile(fileext = ".rds")

data_endpoints_local.insert.callback <- function(data, row) {
  df_data_endpoints_local <- data#rbind(data, df_data_endpoints_local)
  saveRDS(df_data_endpoints_local, file = data_endpoints_fname_local)
  return(df_data_endpoints_local)
}

data_endpoints_local.update.callback <- function(data, olddata, row) {
  df_data_endpoints_local <- data#[row, ] <- data[1, ]
  saveRDS(df_data_endpoints_local, file = data_endpoints_fname_local)
  return(df_data_endpoints_local)
}

data_endpoints_local.delete.callback <- function(data, row) {
  df_data_endpoints_local <- data[-row, ]
  saveRDS(df_data_endpoints_local, file = data_endpoints_fname_local)
  return(df_data_endpoints_local)
}

DTedit::dtedit(
  input, output,
  name = "execution_data_endpoints_local",
  thedata = df_data_endpoints_local,
  edit.label.cols = c("Name", "URL"),
  callback.insert = data_endpoints_local.insert.callback,
  callback.update = data_endpoints_local.update.callback,
  callback.delete = data_endpoints_local.delete.callback
)

# load the edited df
load_data_endps_local <- reactive(if (file.exists(data_endpoints_fname_local)) readRDS(data_endpoints_fname_local) else NULL)

# execution_environment_variables
df_environment_variables_local <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
environment_variables_fname_local <- tempfile(fileext = ".rds")

environment_variables_local.insert.callback <- function(data, row) {
  df_environment_variables_local <- data#rbind(data, df_environment_variables_local)
  saveRDS(df_environment_variables_local, file = environment_variables_fname_local)
  return(df_environment_variables_local)
}

environment_variables_local.update.callback <- function(data, olddata, row) {
  df_environment_variables_local <- data#[row, ] <- data[1, ]
  saveRDS(df_environment_variables_local, file = environment_variables_fname_local)
  return(df_environment_variables_local)
}

environment_variables_local.delete.callback <- function(data, row) {
  df_environment_variables_local <- data[-row, ]
  saveRDS(df_environment_variables_local, file = environment_variables_fname_local)
  return(df_environment_variables_local)
}

DTedit::dtedit(
  input, output,
  name = "execution_environment_variables_local",
  thedata = df_environment_variables_local,
  edit.label.cols = c("Key", "Value"),
  callback.insert = environment_variables_local.insert.callback,
  callback.update = environment_variables_local.update.callback,
  callback.delete = environment_variables_local.delete.callback
)

# load the edited df
load_env_vars_local <- reactive(if (file.exists(environment_variables_fname_local)) readRDS(environment_variables_fname_local) else NULL)

# 6. parametric

df_parametric_local <- data.frame(
  "param" = character(),
  "value" = character(),
  "step" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
parametric_fname_local <- tempfile(fileext = ".rds")

parametric_local.insert.callback <- function(data, row) {
  df_parametric_local <- data#rbind(data, df_parametric_local)
  saveRDS(df_parametric_local, file = parametric_fname_local)
  return(df_parametric_local)
}

parametric_local.update.callback <- function(data, olddata, row) {
  df_parametric_local <- data#[row, ] <- data[1, ]
  saveRDS(df_parametric_local, file = parametric_fname_local)
  return(df_parametric_local)
}

parametric_local.delete.callback <- function(data, row) {
  df_parametric_local <- data[-row, ]
  saveRDS(df_parametric_local, file = parametric_fname_local)
  return(df_parametric_local)
}

DTedit::dtedit(
  input, output,
  name = "parametric_local",
  thedata = df_parametric_local,
  edit.label.cols = c("Parameter", "Value", "Step Number"),
  callback.insert = parametric_local.insert.callback,
  callback.update = parametric_local.update.callback,
  callback.delete = parametric_local.delete.callback
)

# load the edited df
load_parametric_local <- reactive(if (file.exists(parametric_fname_local)) readRDS(parametric_fname_local) else NULL)

# 7. io
# input
# output$io_input_local <- DT::renderDT({
#   data.frame(
#     "filename" = character(),
#     "uri" =  character(),
#     "access_time" = character(),
#     stringsAsFactors = FALSE
#   )
# })
# input
df_input_subdomain_local <- data.frame(
  "filename" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
input_subdomain_fname_local <- tempfile(fileext = ".rds")

input_subdomain_local.insert.callback <- function(data, row) {
  df_input_subdomain_local <- data#rbind(data, df_input_subdomain_local)
  saveRDS(df_input_subdomain_local, file = input_subdomain_fname_local)
  return(df_input_subdomain_local)
}

input_subdomain_local.update.callback <- function(data, olddata, row) {
  df_input_subdomain_local <- data#[row, ] <- data[1, ]
  saveRDS(df_input_subdomain_local, file = input_subdomain_fname_local)
  return(df_input_subdomain_local)
}

input_subdomain_local.delete.callback <- function(data, row) {
  df_input_subdomain_local <- data[-row, ]
  saveRDS(df_input_subdomain_local, file = input_subdomain_fname_local)
  return(df_input_subdomain_local)
}

DTedit::dtedit(
  input, output,
  name = "io_input_local",
  thedata = df_input_subdomain_local,
  edit.label.cols = c("Filename", "URI", "Access Time"),
  callback.insert = input_subdomain_local.insert.callback,
  callback.update = input_subdomain_local.update.callback,
  callback.delete = input_subdomain_local.delete.callback
)
#
# # load the edited df
load_input_subdomain_local <- reactive(if (file.exists(input_subdomain_fname_local)) readRDS(input_subdomain_fname_local) else NULL)

# output
# output$io_output_local <- DT::renderDT({
#   data.frame(
#     "mediatype" = character(),
#     "uri" = character(),
#     "access_time" = character(),
#     stringsAsFactors = FALSE
#   )
# })

df_output_subdomain_local <- data.frame(
  "mediatype" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
output_subdomain_fname_local <- tempfile(fileext = ".rds")

output_subdomain_local.insert.callback <- function(data, row) {
  df_output_subdomain_local <- data#rbind(data, df_output_subdomain_local)
  saveRDS(df_output_subdomain_local, file = output_subdomain_fname_local)
  return(df_output_subdomain_local)
}

output_subdomain_local.update.callback <- function(data, olddata, row) {
  df_output_subdomain_local <- data#[row, ] <- data[1, ]
  saveRDS(df_output_subdomain_local, file = output_subdomain_fname_local)
  return(df_output_subdomain_local)
}

output_subdomain_local.delete.callback <- function(data, row) {
  df_output_subdomain_local <- data[-row, ]
  saveRDS(df_output_subdomain_local, file = output_subdomain_fname_local)
  return(df_output_subdomain_local)
}

DTedit::dtedit(
  input, output,
  name = "io_output_local",
  thedata = df_output_subdomain_local,
  edit.label.cols = c("Media Type", "URI", "Access Time"),
  callback.insert = output_subdomain_local.insert.callback,
  callback.update = output_subdomain_local.update.callback,
  callback.delete = output_subdomain_local.delete.callback
)

# load the edited df
load_output_subdomain_local <- reactive(if (file.exists(output_subdomain_fname_local)) readRDS(output_subdomain_fname_local) else NULL)

# 8. error

# empirical
df_error_empirical_local <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
error_empirical_fname_local <- tempfile(fileext = ".rds")

error_empirical_local.insert.callback <- function(data, row) {
  df_error_empirical_local <- data#rbind(data, df_error_empirical_local)
  saveRDS(df_error_empirical_local, file = error_empirical_fname_local)
  return(df_error_empirical_local)
}

error_empirical_local.update.callback <- function(data, olddata, row) {
  df_error_empirical_local <- data#[row, ] <- data[1, ]
  saveRDS(df_error_empirical_local, file = error_empirical_fname_local)
  return(df_error_empirical_local)
}

error_empirical_local.delete.callback <- function(data, row) {
  df_error_empirical_local <- data[-row, ]
  saveRDS(df_error_empirical_local, file = error_empirical_fname_local)
  return(df_error_empirical_local)
}

DTedit::dtedit(
  input, output,
  name = "error_empirical_local",
  thedata = df_error_empirical_local,
  edit.label.cols = c("Key", "Value"),
  callback.insert = error_empirical_local.insert.callback,
  callback.update = error_empirical_local.update.callback,
  callback.delete = error_empirical_local.delete.callback
)

# load the edited df
load_error_empr_local <- reactive(if (file.exists(error_empirical_fname_local)) readRDS(error_empirical_fname_local) else NULL)

# algorithmic
df_error_algorithmic_local <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
error_algorithmic_fname_local <- tempfile(fileext = ".rds")

error_algorithmic_local.insert.callback <- function(data, row) {
  df_error_algorithmic_local <- data#rbind(data, df_error_algorithmic_local)
  saveRDS(df_error_algorithmic_local, file = error_algorithmic_fname_local)
  return(df_error_algorithmic_local)
}

error_algorithmic_local.update.callback <- function(data, olddata, row) {
  df_error_algorithmic_local <- data#[row, ] <- data[1, ]
  saveRDS(df_error_algorithmic_local, file = error_algorithmic_fname_local)
  return(df_error_algorithmic_local)
}

error_algorithmic_local.delete.callback <- function(data, row) {
  df_error_algorithmic_local <- data[-row, ]
  saveRDS(df_error_algorithmic_local, file = error_algorithmic_fname_local)
  return(df_error_algorithmic_local)
}

DTedit::dtedit(
  input, output,
  name = "error_algorithmic_local",
  thedata = df_error_algorithmic_local,
  edit.label.cols = c("Key", "Value"),
  callback.insert = error_algorithmic_local.insert.callback,
  callback.update = error_algorithmic_local.update.callback,
  callback.delete = error_algorithmic_local.delete.callback
)

# load the edited df
load_error_algo_local <- reactive(if (file.exists(error_algorithmic_fname_local)) readRDS(error_algorithmic_fname_local) else NULL)

# top level fields
observeEvent(input$bco_id_local, {
  if (nchar(input$bco_id_local) >= 7) showFeedbackSuccess("bco_id_local") else hideFeedback("bco_id_local")
})
