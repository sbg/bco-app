# fill inputs with info parsed from cwl

# 1. provenance

# name
observeEvent(input$provenance_name_basic, {
  if (nchar(input$provenance_name_basic) >= 3) showFeedbackSuccess("provenance_name_basic") else hideFeedback("provenance_name_basic")
})

# version
observeEvent(input$provenance_version_basic, {
  if (nchar(input$provenance_version_basic) > 0) showFeedbackSuccess("provenance_version_basic") else hideFeedback("provenance_version_basic")
})

# derived_from
observeEvent(input$provenance_derived_from_basic, {
  if (nchar(input$provenance_derived_from_basic) > 0) showFeedbackSuccess("provenance_derived_from_basic") else hideFeedback("provenance_derived_from_basic")
})

# license
observeEvent(input$provenance_license_basic, {
  if (nchar(input$provenance_license_basic) > 0) showFeedbackSuccess("provenance_license_basic") else hideFeedback("provenance_license_basic")
})

# review
df_review_basic <- data.frame(
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
review_fname_basic <- tempfile(fileext = ".rds")

review_basic.insert.callback <- function(data, row) {
  df_review_basic <- data#rbind(data, df_review_basic)
  saveRDS(df_review_basic, file = review_fname_basic)
  return(df_review_basic)
}

review_basic.update.callback <- function(data, olddata, row) {
  df_review_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_review_basic, file = review_fname_basic)
  return(df_review_basic)
}

review_basic.delete.callback <- function(data, row) {
  df_review_basic <- data[-row, ]
  saveRDS(df_review_basic, file = review_fname_basic)
  return(df_review_basic)
}

DTedit::dtedit(
  input, output,
  name = "provenance_review_basic",
  thedata = df_review_basic,
  edit.label.cols = c(
    "Status", "Reviewer Comment", "Date", "Reviewer Name",
    "Affiliation", "Email",
    "Contribution", "ORCID"
  ),
  input.types = c(reviewer_comment = "textAreaInput"),
  callback.insert = review_basic.insert.callback,
  callback.update = review_basic.update.callback,
  callback.delete = review_basic.delete.callback
)

# load the edited df
load_df_review_basic <- reactive(if (file.exists(review_fname_basic)) readRDS(review_fname_basic) else NULL)

# contributors
df_contributors_basic <- data.frame(
  "name" = character(),
  "affiliation" = character(),
  "email" = character(),
  "contribution" = character(),
  "orcid" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
contributors_fname_basic <- tempfile(fileext = ".rds")

contributors_basic.insert.callback <- function(data, row) {
  df_contributors_basic <- data#rbind(data, df_contributors_basic)
  saveRDS(df_contributors_basic, file = contributors_fname_basic)
  return(df_contributors_basic)
}

contributors_basic.update.callback <- function(data, olddata, row) {
  df_contributors_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_contributors_basic, file = contributors_fname_basic)
  return(df_contributors_basic)
}

contributors_basic.delete.callback <- function(data, row) {
  df_contributors_basic <- data[-row, ]
  saveRDS(df_contributors_basic, file = contributors_fname_basic)
  return(df_contributors_basic)
}

DTedit::dtedit(
  input, output,
  name = "provenance_contributors_basic",
  thedata = df_contributors_basic,
  edit.label.cols = c("Name", "Affiliation", "Email", "Contribution", "ORCID"),
  callback.insert = contributors_basic.insert.callback,
  callback.update = contributors_basic.update.callback,
  callback.delete = contributors_basic.delete.callback
)

# load the edited df
load_df_contributors_basic <- reactive(if (file.exists(contributors_fname_basic)) readRDS(contributors_fname_basic) else NULL)

# 2. usability

# 3.1 fhir

# fhir_endpoint
observeEvent(input$fhir_endpoint_basic, {
  if (nchar(input$fhir_endpoint_basic) >= 7) showFeedbackSuccess("fhir_endpoint_basic") else hideFeedback("fhir_endpoint_basic")
})

# fhir_version
observeEvent(input$fhir_version_basic, {
  if (nchar(input$fhir_version_basic) >= 1) showFeedbackSuccess("fhir_version_basic") else hideFeedback("fhir_version_basic")
})

# fhir_resources
df_fhir_resources_basic <- data.frame(
  "id" = character(),
  "resource" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
fhir_resources_fname_basic <- tempfile(fileext = ".rds")

fhir_resources_basic.insert.callback <- function(data, row) {
  df_fhir_resources_basic <- data#rbind(data, df_fhir_resources_basic)
  saveRDS(df_fhir_resources_basic, file = fhir_resources_fname_basic)
  return(df_fhir_resources_basic)
}

fhir_resources_basic.update.callback <- function(data, olddata, row) {
  df_fhir_resources_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_fhir_resources_basic, file = fhir_resources_fname_basic)
  return(df_fhir_resources_basic)
}

fhir_resources_basic.delete.callback <- function(data, row) {
  df_fhir_resources_basic <- data[-row, ]
  saveRDS(df_fhir_resources_basic, file = fhir_resources_fname_basic)
  return(df_fhir_resources_basic)
}

DTedit::dtedit(
  input, output,
  name = "fhir_resources_basic",
  thedata = df_fhir_resources_basic,
  edit.label.cols = c("ID", "Resource"),
  callback.insert = fhir_resources_basic.insert.callback,
  callback.update = fhir_resources_basic.update.callback,
  callback.delete = fhir_resources_basic.delete.callback
)

# load the edited df
load_df_fhir_resources_basic <- reactive(if (file.exists(fhir_resources_fname_basic)) readRDS(fhir_resources_fname_basic) else NULL)

# 4. description

# platform
observeEvent(input$desc_platform_basic, {
  if (nchar(input$desc_platform_basic) >= 3) showFeedbackSuccess("desc_platform_basic") else hideFeedback("desc_platform_basic")
})

# keywords
observeEvent(input$desc_keywords_basic, {
  if (nchar(input$desc_keywords_basic) >= 3) showFeedbackSuccess("desc_keywords_basic") else hideFeedback("desc_keywords_basic")
})

# xref
df_desc_xref_basic <- data.frame(
  "namespace" = character(),
  "name" = character(),
  "ids" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_xref_fname_basic <- tempfile(fileext = ".rds")

desc_xref_basic.insert.callback <- function(data, row) {
  df_desc_xref_basic <- data#rbind(data, df_desc_xref_basic)
  saveRDS(df_desc_xref_basic, file = desc_xref_fname_basic)
  return(df_desc_xref_basic)
}

desc_xref_basic.update.callback <- function(data, olddata, row) {
  df_desc_xref_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_xref_basic, file = desc_xref_fname_basic)
  return(df_desc_xref_basic)
}

desc_xref_basic.delete.callback <- function(data, row) {
  df_desc_xref_basic <- data[-row, ]
  saveRDS(df_desc_xref_basic, file = desc_xref_fname_basic)
  return(df_desc_xref_basic)
}

DTedit::dtedit(
  input, output,
  name = "desc_xref_basic",
  thedata = df_desc_xref_basic,
  edit.label.cols = c("Namespace", "Name", "IDs", "Access Time"),
  callback.insert = desc_xref_basic.insert.callback,
  callback.update = desc_xref_basic.update.callback,
  callback.delete = desc_xref_basic.delete.callback
)

# load the edited df
load_desc_xref_basic <- reactive(if (file.exists(desc_xref_fname_basic)) readRDS(desc_xref_fname_basic) else NULL)

# pipeline_meta
# output$desc_pipeline_meta_basic <- DT::renderDT({
#   data.frame(
#     "step_number" = character(),
#     "name" = character(),
#     "description" = character(),
#     "version" = character(),
#     stringsAsFactors = FALSE
#   )
# })

df_desc_pipeline_meta_basic <- data.frame(
  "step_number" = character(),
  "name" = character(),
  "description" = character(),
  "version" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_meta_fname_basic <- tempfile(fileext = ".rds")

desc_pipeline_meta_basic.insert.callback <- function(data, row) {
  df_desc_pipeline_meta_basic <- data#rbind(data, df_desc_pipeline_meta_basic)
  saveRDS(df_desc_pipeline_meta_basic, file = desc_pipeline_meta_fname_basic)
  return(df_desc_pipeline_meta_basic)
}

desc_pipeline_meta_basic.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_meta_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_meta_basic, file = desc_pipeline_meta_fname_basic)
  return(df_desc_pipeline_meta_basic)
}

desc_pipeline_meta_basic.delete.callback <- function(data, row) {
  df_desc_pipeline_meta_basic <- data[-row, ]
  saveRDS(df_desc_pipeline_meta_basic, file = desc_pipeline_meta_fname_basic)
  return(df_desc_pipeline_meta_basic)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_meta_basic",
  thedata = df_desc_pipeline_meta_basic,
  edit.label.cols = c("Namespace", "Name", "IDs", "Access Time"),
  callback.insert = desc_pipeline_meta_basic.insert.callback,
  callback.update = desc_pipeline_meta_basic.update.callback,
  callback.delete = desc_pipeline_meta_basic.delete.callback
)

# load the edited df
load_desc_pipeline_meta_basic <- reactive(if (file.exists(desc_pipeline_meta_fname_basic)) readRDS(desc_pipeline_meta_fname_basic) else NULL)

# pipeline_prerequisite
df_desc_pipeline_prerequisite_basic <- data.frame(
  "step_number" = character(),
  "name" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_prerequisite_fname_basic <- tempfile(fileext = ".rds")

desc_pipeline_prerequisite_basic.insert.callback <- function(data, row) {
  df_desc_pipeline_prerequisite_basic <- data#rbind(data, df_desc_pipeline_prerequisite_basic)
  saveRDS(df_desc_pipeline_prerequisite_basic, file = desc_pipeline_prerequisite_fname_basic)
  return(df_desc_pipeline_prerequisite_basic)
}

desc_pipeline_prerequisite_basic.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_prerequisite_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_prerequisite_basic, file = desc_pipeline_prerequisite_fname_basic)
  return(df_desc_pipeline_prerequisite_basic)
}

desc_pipeline_prerequisite_basic.delete.callback <- function(data, row) {
  df_desc_pipeline_prerequisite_basic <- data[-row, ]
  saveRDS(df_desc_pipeline_prerequisite_basic, file = desc_pipeline_prerequisite_fname_basic)
  return(df_desc_pipeline_prerequisite_basic)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_prerequisite_basic",
  thedata = df_desc_pipeline_prerequisite_basic,
  edit.label.cols = c("Step Number", "Name", "URI", "Access Time"),
  callback.insert = desc_pipeline_prerequisite_basic.insert.callback,
  callback.update = desc_pipeline_prerequisite_basic.update.callback,
  callback.delete = desc_pipeline_prerequisite_basic.delete.callback
)

# load the edited df
load_desc_pipeline_prerequisite_basic <- reactive(if (file.exists(desc_pipeline_prerequisite_fname_basic)) readRDS(desc_pipeline_prerequisite_fname_basic) else NULL)

# pipeline input
# output$desc_pipeline_input <- DT::renderDT({
#   data.frame(
#     "step_number" = get_taskused()$step_number_input,
#     "uri" = get_taskused()$input,
#     "access_time" = get_taskused()$start_time,
#     stringsAsFactors = FALSE
#   )
# })

# pipeline input
df_desc_pipeline_input_basic <- data.frame(
  "step_number" = as.character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_input_fname_basic <- tempfile(fileext = ".rds")

desc_pipeline_input_basic.insert.callback <- function(data, row) {
  df_desc_pipeline_input_basic <- data#rbind(data, df_desc_pipeline_input_basic)
  saveRDS(df_desc_pipeline_input_basic, file = desc_pipeline_input_fname_basic)
  return(df_desc_pipeline_input_basic)
}

desc_pipeline_input_basic.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_input_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_input_basic, file = desc_pipeline_input_fname_basic)
  return(df_desc_pipeline_input_basic)
}

desc_pipeline_input_basic.delete.callback <- function(data, row) {
  df_desc_pipeline_input_basic <- data[-row, ]
  saveRDS(df_desc_pipeline_input_basic, file = desc_pipeline_input_fname_basic)
  return(df_desc_pipeline_input_basic)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_input_basic",
  thedata = df_desc_pipeline_input_basic,
  edit.label.cols = c("Step Number", "URI", "Access Time"),
  callback.insert = desc_pipeline_input_basic.insert.callback,
  callback.update = desc_pipeline_input_basic.update.callback,
  callback.delete = desc_pipeline_input_basic.delete.callback
)

# load the edited df
load_desc_pipeline_input_basic <- reactive(if (file.exists(desc_pipeline_input_fname_basic)) readRDS(desc_pipeline_input_fname_basic) else NULL)

# pipeline output
# output$desc_pipeline_output <- DT::renderDT({
#   data.frame(
#     "step_number" = get_taskused()$step_number_output,
#     "uri" = get_taskused()$output,
#     "access_time" = get_taskused()$end_time,
#     stringsAsFactors = FALSE
#   )
# })

# pipeline output
df_desc_pipeline_output_basic <- data.frame(
  "step_number" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_output_fname_basic <- tempfile(fileext = ".rds")

desc_pipeline_output_basic.insert.callback <- function(data, row) {
  df_desc_pipeline_output_basic <- data#rbind(data, df_desc_pipeline_output_basic)
  saveRDS(df_desc_pipeline_output_basic, file = desc_pipeline_output_fname_basic)
  return(df_desc_pipeline_output_basic)
}

desc_pipeline_output_basic.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_output_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_output_basic, file = desc_pipeline_output_fname_basic)
  return(df_desc_pipeline_output_basic)
}

desc_pipeline_output_basic.delete.callback <- function(data, row) {
  df_desc_pipeline_output_basic <- data[-row, ]
  saveRDS(df_desc_pipeline_output_basic, file = desc_pipeline_output_fname_basic)
  return(df_desc_pipeline_output_basic)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_output_basic",
  thedata = df_desc_pipeline_output_basic,
  edit.label.cols = c("Step Number", "URI", "Access Time"),
  callback.insert = desc_pipeline_output_basic.insert.callback,
  callback.update = desc_pipeline_output_basic.update.callback,
  callback.delete = desc_pipeline_output_basic.delete.callback
)

# load the edited df
load_desc_pipeline_output_basic <- reactive(if (file.exists(desc_pipeline_output_fname_basic)) readRDS(desc_pipeline_output_fname_basic) else NULL)

# 5. execution

# script
observeEvent(input$execution_script_basic, {
  if (nchar(input$execution_script_basic) >= 7) showFeedbackSuccess("execution_script_basic") else hideFeedback("execution_script_basic")
})

# script_driver
observeEvent(input$execution_script_driver_basic, {
  if (nchar(input$execution_script_driver_basic) >= 2) showFeedbackSuccess("execution_script_driver_basic") else hideFeedback("execution_script_driver_basic")
})

# execution_software_prerequisites
# TODO: Platform URI should be based on the version of the platform that was used for loading the task/app
df_software_prerequisites_basic <- data.frame(
  "name" = "Seven Bridges Platform",
  "version" = as.character(Sys.Date()),
  "uri" = "https://igor.sbgenomics.com/",
  "access_time" = Sys.Date(),
  "sha1_chksum" = c(""),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
software_prerequisites_fname_basic <- tempfile(fileext = ".rds")

software_prerequisites_basic.insert.callback <- function(data, row) {
  df_software_prerequisites_basic <- data#rbind(data, df_software_prerequisites_basic)
  saveRDS(df_software_prerequisites_basic, file = software_prerequisites_fname_basic)
  return(df_software_prerequisites_basic)
}

software_prerequisites_basic.update.callback <- function(data, olddata, row) {
  df_software_prerequisites_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_software_prerequisites_basic, file = software_prerequisites_fname_basic)
  return(df_software_prerequisites_basic)
}

software_prerequisites_basic.delete.callback <- function(data, row) {
  df_software_prerequisites_basic <- data[-row, ]
  saveRDS(df_software_prerequisites_basic, file = software_prerequisites_fname_basic)
  return(df_software_prerequisites_basic)
}

DTedit::dtedit(
  input, output,
  name = "execution_software_prerequisites_basic",
  thedata = df_software_prerequisites_basic,
  edit.label.cols = c(
    "Name", "Version", "URI", "Access Time", "SHA1 Checkksum"
  ),
  callback.insert = software_prerequisites_basic.insert.callback,
  callback.update = software_prerequisites_basic.update.callback,
  callback.delete = software_prerequisites_basic.delete.callback
)

# load the edited df
load_software_prerequisites_basic <- reactive(if (file.exists(software_prerequisites_fname_basic)) readRDS(software_prerequisites_fname_basic) else NULL)

# execution_data_endpoints
df_data_endpoints_basic <- data.frame(
  "name" = character(),
  "url" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
data_endpoints_fname_basic <- tempfile(fileext = ".rds")

data_endpoints_basic.insert.callback <- function(data, row) {
  df_data_endpoints_basic <- data#rbind(data, df_data_endpoints_basic)
  saveRDS(df_data_endpoints_basic, file = data_endpoints_fname_basic)
  return(df_data_endpoints_basic)
}

data_endpoints_basic.update.callback <- function(data, olddata, row) {
  df_data_endpoints_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_data_endpoints_basic, file = data_endpoints_fname_basic)
  return(df_data_endpoints_basic)
}

data_endpoints_basic.delete.callback <- function(data, row) {
  df_data_endpoints_basic <- data[-row, ]
  saveRDS(df_data_endpoints_basic, file = data_endpoints_fname_basic)
  return(df_data_endpoints_basic)
}

DTedit::dtedit(
  input, output,
  name = "execution_data_endpoints_basic",
  thedata = df_data_endpoints_basic,
  edit.label.cols = c("Name", "URL"),
  callback.insert = data_endpoints_basic.insert.callback,
  callback.update = data_endpoints_basic.update.callback,
  callback.delete = data_endpoints_basic.delete.callback
)

# load the edited df
load_data_endpoints_basic <- reactive(if (file.exists(data_endpoints_fname_basic)) readRDS(data_endpoints_fname_basic) else NULL)

# execution_environment_variables
df_environment_variables_basic <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
environment_variables_fname_basic <- tempfile(fileext = ".rds")

environment_variables_basic.insert.callback <- function(data, row) {
  df_environment_variables_basic <- data#rbind(data, df_environment_variables_basic)
  saveRDS(df_environment_variables_basic, file = environment_variables_fname_basic)
  return(df_environment_variables_basic)
}

environment_variables_basic.update.callback <- function(data, olddata, row) {
  df_environment_variables_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_environment_variables_basic, file = environment_variables_fname_basic)
  return(df_environment_variables_basic)
}

environment_variables_basic.delete.callback <- function(data, row) {
  df_environment_variables_basic <- data[-row, ]
  saveRDS(df_environment_variables_basic, file = environment_variables_fname_basic)
  return(df_environment_variables_basic)
}

DTedit::dtedit(
  input, output,
  name = "execution_environment_variables_basic",
  thedata = df_environment_variables_basic,
  edit.label.cols = c("Key", "Value"),
  callback.insert = environment_variables_basic.insert.callback,
  callback.update = environment_variables_basic.update.callback,
  callback.delete = environment_variables_basic.delete.callback
)

# load the edited df
load_environment_variables_basic <- reactive(if (file.exists(environment_variables_fname_basic)) readRDS(environment_variables_fname_basic) else NULL)

# 6. parametric

df_parametric_basic <- data.frame(
  "param" = character(),
  "value" = character(),
  "step" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
parametric_fname_basic <- tempfile(fileext = ".rds")

parametric_basic.insert.callback <- function(data, row) {
  df_parametric_basic <- data#rbind(data, df_parametric_basic)
  saveRDS(df_parametric_basic, file = parametric_fname_basic)
  return(df_parametric_basic)
}

parametric_basic.update.callback <- function(data, olddata, row) {
  df_parametric_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_parametric_basic, file = parametric_fname_basic)
  return(df_parametric_basic)
}

parametric_basic.delete.callback <- function(data, row) {
  df_parametric_basic <- data[-row, ]
  saveRDS(df_parametric_basic, file = parametric_fname_basic)
  return(df_parametric_basic)
}

DTedit::dtedit(
  input, output,
  name = "parametric_basic",
  thedata = df_parametric_basic,
  edit.label.cols = c("Parameter", "Value", "Step Number"),
  callback.insert = parametric_basic.insert.callback,
  callback.update = parametric_basic.update.callback,
  callback.delete = parametric_basic.delete.callback
)

# load the edited df
load_parametric_basic <- reactive(if (file.exists(parametric_fname_basic)) readRDS(parametric_fname_basic) else NULL)

# 7. io
# input
# output$io_input_basic <- DT::renderDT({
#   data.frame(
#     "filename" = character(),
#     "uri" =  character(),
#     "access_time" = character(),
#     stringsAsFactors = FALSE
#   )
# })
# input
df_input_subdomain_basic <- data.frame(
  "filename" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
input_subdomain_fname_basic <- tempfile(fileext = ".rds")

input_subdomain_basic.insert.callback <- function(data, row) {
  df_input_subdomain_basic <- data#rbind(data, df_input_subdomain_basic)
  saveRDS(df_input_subdomain_basic, file = input_subdomain_fname_basic)
  return(df_input_subdomain_basic)
}

input_subdomain_basic.update.callback <- function(data, olddata, row) {
  df_input_subdomain_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_input_subdomain_basic, file = input_subdomain_fname_basic)
  return(df_input_subdomain_basic)
}

input_subdomain_basic.delete.callback <- function(data, row) {
  df_input_subdomain_basic <- data[-row, ]
  saveRDS(df_input_subdomain_basic, file = input_subdomain_fname_basic)
  return(df_input_subdomain_basic)
}

DTedit::dtedit(
  input, output,
  name = "io_input_basic",
  thedata = df_input_subdomain_basic,
  edit.label.cols = c("Filename", "URI", "Access Time"),
  callback.insert = input_subdomain_basic.insert.callback,
  callback.update = input_subdomain_basic.update.callback,
  callback.delete = input_subdomain_basic.delete.callback
)
#
# # load the edited df
load_input_subdomain_basic <- reactive(if (file.exists(input_subdomain_fname_basic)) readRDS(input_subdomain_fname_basic) else NULL)

# output
# output$io_output_basic <- DT::renderDT({
#   data.frame(
#     "mediatype" = character(),
#     "uri" = character(),
#     "access_time" = character(),
#     stringsAsFactors = FALSE
#   )
# })

df_output_subdomain_basic <- data.frame(
  "mediatype" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
output_subdomain_fname_basic <- tempfile(fileext = ".rds")

output_subdomain_basic.insert.callback <- function(data, row) {
  df_output_subdomain_basic <- data#rbind(data, df_output_subdomain_basic)
  saveRDS(df_output_subdomain_basic, file = output_subdomain_fname_basic)
  return(df_output_subdomain_basic)
}

output_subdomain_basic.update.callback <- function(data, olddata, row) {
  df_output_subdomain_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_output_subdomain_basic, file = output_subdomain_fname_basic)
  return(df_output_subdomain_basic)
}

output_subdomain_basic.delete.callback <- function(data, row) {
  df_output_subdomain_basic <- data[-row, ]
  saveRDS(df_output_subdomain_basic, file = output_subdomain_fname_basic)
  return(df_output_subdomain_basic)
}

DTedit::dtedit(
  input, output,
  name = "io_output_basic",
  thedata = df_output_subdomain_basic,
  edit.label.cols = c("Media Type", "URI", "Access Time"),
  callback.insert = output_subdomain_basic.insert.callback,
  callback.update = output_subdomain_basic.update.callback,
  callback.delete = output_subdomain_basic.delete.callback
)

# load the edited df
load_output_subdomain_basic <- reactive(if (file.exists(output_subdomain_fname_basic)) readRDS(output_subdomain_fname_basic) else NULL)

# 8. error

# empirical
df_error_empirical_basic <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
error_empirical_fname_basic <- tempfile(fileext = ".rds")

error_empirical_basic.insert.callback <- function(data, row) {
  df_error_empirical_basic <- data#rbind(data, df_error_empirical_basic)
  saveRDS(df_error_empirical_basic, file = error_empirical_fname_basic)
  return(df_error_empirical_basic)
}

error_empirical_basic.update.callback <- function(data, olddata, row) {
  df_error_empirical_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_error_empirical_basic, file = error_empirical_fname_basic)
  return(df_error_empirical_basic)
}

error_empirical_basic.delete.callback <- function(data, row) {
  df_error_empirical_basic <- data[-row, ]
  saveRDS(df_error_empirical_basic, file = error_empirical_fname_basic)
  return(df_error_empirical_basic)
}

DTedit::dtedit(
  input, output,
  name = "error_empirical_basic",
  thedata = df_error_empirical_basic,
  edit.label.cols = c("Key", "Value"),
  callback.insert = error_empirical_basic.insert.callback,
  callback.update = error_empirical_basic.update.callback,
  callback.delete = error_empirical_basic.delete.callback
)

# load the edited df
load_error_empirical_basic <- reactive(if (file.exists(error_empirical_fname_basic)) readRDS(error_empirical_fname_basic) else NULL)

# algorithmic
df_error_algorithmic_basic <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
error_algorithmic_fname_basic <- tempfile(fileext = ".rds")

error_algorithmic_basic.insert.callback <- function(data, row) {
  df_error_algorithmic_basic <- data#rbind(data, df_error_algorithmic_basic)
  saveRDS(df_error_algorithmic_basic, file = error_algorithmic_fname_basic)
  return(df_error_algorithmic_basic)
}

error_algorithmic_basic.update.callback <- function(data, olddata, row) {
  df_error_algorithmic_basic <- data#[row, ] <- data[1, ]
  saveRDS(df_error_algorithmic_basic, file = error_algorithmic_fname_basic)
  return(df_error_algorithmic_basic)
}

error_algorithmic_basic.delete.callback <- function(data, row) {
  df_error_algorithmic_basic <- data[-row, ]
  saveRDS(df_error_algorithmic_basic, file = error_algorithmic_fname_basic)
  return(df_error_algorithmic_basic)
}

DTedit::dtedit(
  input, output,
  name = "error_algorithmic_basic",
  thedata = df_error_algorithmic_basic,
  edit.label.cols = c("Key", "Value"),
  callback.insert = error_algorithmic_basic.insert.callback,
  callback.update = error_algorithmic_basic.update.callback,
  callback.delete = error_algorithmic_basic.delete.callback
)

# load the edited df
load_error_algorithmic_basic <- reactive(if (file.exists(error_algorithmic_fname_basic)) readRDS(error_algorithmic_fname_basic) else NULL)

# top level fields
observeEvent(input$bco_id_basic, {
  if (nchar(input$bco_id_basic) >= 7) showFeedbackSuccess("bco_id_basic") else hideFeedback("bco_id_basic")
})
