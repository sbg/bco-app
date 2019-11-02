# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

# 1. provenance

# name

observeEvent(input$provenance_name_2, {
  feedbackSuccess(
    inputId = "provenance_name_2",
    condition = nchar(input$provenance_name_2) >= 3
  )
})

# version
observeEvent(input$provenance_version_2, {
  feedbackSuccess(
    inputId = "provenance_version_2",
    condition = nchar(input$provenance_version_2) >= 5
  )
})

# derived_from
observeEvent(input$provenance_derived_from_2, {
  feedbackSuccess(
    inputId = "provenance_derived_from_2",
    condition = nchar(input$provenance_derived_from_2) >= 0
  )
})

# license
observeEvent(input$provenance_license_2, {
  feedbackSuccess(
    inputId = "provenance_license_2",
    condition = nchar(input$provenance_license_2) >= 2
  )
})

# review
df_review_2 <- data.frame(
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
review_fname_2 <- tempfile(fileext = ".rds")

review_2.insert.callback <- function(data, row) {
  df_review_2 <- rbind(data, df_review_2)
  saveRDS(df_review_2, file = review_fname_2)
  return(df_review_2)
}

review_2.update.callback <- function(data, olddata, row) {
  df_review_2[row, ] <- data[1, ]
  saveRDS(df_review_2, file = review_fname_2)
  return(df_review_2)
}

review_2.delete.callback <- function(data, row) {
  df_review_2 <- df_review_2[-row, ]
  saveRDS(df_review_2, file = review_fname_2)
  return(df_review_2)
}

DTedit::dtedit(
  input, output,
  name = "provenance_review_2",
  thedata = df_review_2,
  edit.label.cols = c(
    "Status", "Reviewer Comment", "Date", "Reviewer Name",
    "Affiliation", "Email",
    "Contribution", "ORCID"
  ),
  input.types = c(reviewer_comment = "textAreaInput"),
  callback.insert = review_2.insert.callback,
  callback.update = review_2.update.callback,
  callback.delete = review_2.delete.callback
)

# load the edited df
load_df_review_2 <- reactive(if (file.exists(review_fname_2)) readRDS(review_fname_2) else NULL)

# contributors
df_contributors_2 <- data.frame(
  "name" = character(),
  "affiliation" = character(),
  "email" = character(),
  "contribution" = character(),
  "orcid" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
contributors_fname_2 <- tempfile(fileext = ".rds")

contributors_2.insert.callback <- function(data, row) {
  df_contributors_2 <- rbind(data, df_contributors_2)
  saveRDS(df_contributors_2, file = contributors_fname_2)
  return(df_contributors_2)
}

contributors_2.update.callback <- function(data, olddata, row) {
  df_contributors_2[row, ] <- data[1, ]
  saveRDS(df_contributors_2, file = contributors_fname_2)
  return(df_contributors_2)
}

contributors_2.delete.callback <- function(data, row) {
  df_contributors_2 <- df_contributors[-row, ]
  saveRDS(df_contributors_2, file = contributors_fname_2)
  return(df_contributors_2)
}

DTedit::dtedit(
  input, output,
  name = "provenance_contributors_2",
  thedata = df_contributors_2,
  edit.label.cols = c("Name", "Affiliation", "Email", "Contribution", "ORCID"),
  callback.insert = contributors_2.insert.callback,
  callback.update = contributors_2.update.callback,
  callback.delete = contributors_2.delete.callback
)

# load the edited df
load_df_contributors_2 <- reactive(if (file.exists(contributors_fname_2)) readRDS(contributors_fname_2) else NULL)

# 2. usability

# 3.1 fhir

# fhir_endpoint
observeEvent(input$fhir_endpoint_2, {
  feedbackSuccess(
    inputId = "fhir_endpoint_2",
    condition = nchar(input$fhir_endpoint_2) >= 7
  )
})

# fhir_version
observeEvent(input$fhir_version_2, {
  feedbackSuccess(
    inputId = "fhir_version_2",
    condition = nchar(input$fhir_version_2) >= 1
  )
})

# fhir_resources
df_fhir_resources_2 <- data.frame(
  "id" = character(),
  "resource" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
fhir_resources_fname_2 <- tempfile(fileext = ".rds")

fhir_resources_2.insert.callback <- function(data, row) {
  df_fhir_resources_2 <- rbind(data, df_fhir_resources_2)
  saveRDS(df_fhir_resources_2, file = fhir_resources_fname_2)
  return(df_fhir_resources_2)
}

fhir_resources_2.update.callback <- function(data, olddata, row) {
  df_fhir_resources_2[row, ] <- data[1, ]
  saveRDS(df_fhir_resources_2, file = fhir_resources_fname_2)
  return(df_fhir_resources_2)
}

fhir_resources_2.delete.callback <- function(data, row) {
  df_fhir_resources_2 <- df_fhir_resources_2[-row, ]
  saveRDS(df_fhir_resources_2, file = fhir_resources_fname_2)
  return(df_fhir_resources_2)
}

DTedit::dtedit(
  input, output,
  name = "fhir_resources_2",
  thedata = df_fhir_resources_2,
  edit.label.cols = c("ID", "Resource"),
  callback.insert = fhir_resources_2.insert.callback,
  callback.update = fhir_resources_2.update.callback,
  callback.delete = fhir_resources_2.delete.callback
)

# load the edited df
load_df_fhir_resources_2 <- reactive(if (file.exists(fhir_resources_fname_2)) readRDS(fhir_resources_fname_2) else NULL)

# 4. description

# platform
observeEvent(input$desc_platform_2, {
  feedbackSuccess(
    inputId = "desc_platform_2",
    condition = nchar(input$desc_platform_2) >= 3
  )
})

# keywords
observeEvent(input$desc_keywords_2, {
  feedbackSuccess(
    inputId = "desc_keywords_2",
    condition = nchar(input$desc_keywords_2) >= 3
  )
})

# xref
df_desc_xref_2 <- data.frame(
  "namespace" = character(),
  "name" = character(),
  "ids" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_xref_fname_2 <- tempfile(fileext = ".rds")

desc_xref_2.insert.callback <- function(data, row) {
  df_desc_xref_2 <- rbind(data, df_desc_xref_2)
  saveRDS(df_desc_xref_2, file = desc_xref_fname_2)
  return(df_desc_xref_2)
}

desc_xref_2.update.callback <- function(data, olddata, row) {
  df_desc_xref_2[row, ] <- data[1, ]
  saveRDS(df_desc_xref_2, file = desc_xref_fname_2)
  return(df_desc_xref_2)
}

desc_xref_2.delete.callback <- function(data, row) {
  df_desc_xref_2 <- df_desc_xref_2[-row, ]
  saveRDS(df_desc_xref_2, file = desc_xref_fname_2)
  return(df_desc_xref_2)
}

DTedit::dtedit(
  input, output,
  name = "desc_xref_2",
  thedata = df_desc_xref_2,
  edit.label.cols = c("Namespace", "Name", "IDs", "Access Time"),
  callback.insert = desc_xref_2.insert.callback,
  callback.update = desc_xref_2.update.callback,
  callback.delete = desc_xref_2.delete.callback
)

# load the edited df
load_desc_xref_2 <- reactive(if (file.exists(desc_xref_fname_2)) readRDS(desc_xref_fname_2) else NULL)

# pipeline_meta
# output$desc_pipeline_meta_2 <- DT::renderDT({
#   data.frame(
#     "step_number" = character(),
#     "name" = character(),
#     "description" = character(),
#     "version" = character(),
#     stringsAsFactors = FALSE
#   )
# })

df_desc_pipeline_meta_2 <- data.frame(
  "step_number" = character(),
  "name" = character(),
  "description" = character(),
  "version" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_meta_fname_2 <- tempfile(fileext = ".rds")

desc_pipeline_meta_2.insert.callback <- function(data, row) {
  df_desc_pipeline_meta_2 <- rbind(data, df_desc_pipeline_meta_2)
  saveRDS(df_desc_pipeline_meta_2, file = desc_pipeline_meta_fname_2)
  return(df_desc_pipeline_meta_2)
}

desc_pipeline_meta_2.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_meta_2[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_meta_2, file = desc_pipeline_meta_fname_2)
  return(df_desc_pipeline_meta_2)
}

desc_pipeline_meta_2.delete.callback <- function(data, row) {
  df_desc_pipeline_meta_2 <- df_desc_pipeline_meta_2[-row, ]
  saveRDS(df_desc_pipeline_meta_2, file = desc_pipeline_meta_fname_2)
  return(df_desc_pipeline_meta_2)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_meta_2",
  thedata = df_desc_pipeline_meta_2,
  edit.label.cols = c("Namespace", "Name", "IDs", "Access Time"),
  callback.insert = desc_pipeline_meta_2.insert.callback,
  callback.update = desc_pipeline_meta_2.update.callback,
  callback.delete = desc_pipeline_meta_2.delete.callback
)

# load the edited df
load_desc_pipeline_meta_2 <- reactive(if (file.exists(desc_pipeline_meta_fname_2)) readRDS(desc_pipeline_meta_fname_2) else NULL)

# pipeline_prerequisite
df_desc_pipeline_prerequisite_2 <- data.frame(
  "step_number" = character(),
  "name" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_prerequisite_fname_2 <- tempfile(fileext = ".rds")

desc_pipeline_prerequisite_2.insert.callback <- function(data, row) {
  df_desc_pipeline_prerequisite_2 <- rbind(data, df_desc_pipeline_prerequisite_2)
  saveRDS(df_desc_pipeline_prerequisite_2, file = desc_pipeline_prerequisite_fname_2)
  return(df_desc_pipeline_prerequisite_2)
}

desc_pipeline_prerequisite_2.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_prerequisite_2[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_prerequisite_2, file = desc_pipeline_prerequisite_fname_2)
  return(df_desc_pipeline_prerequisite_2)
}

desc_pipeline_prerequisite_2.delete.callback <- function(data, row) {
  df_desc_pipeline_prerequisite_2 <- df_desc_pipeline_prerequisite_2[-row, ]
  saveRDS(df_desc_pipeline_prerequisite_2, file = desc_pipeline_prerequisite_fname_2)
  return(df_desc_pipeline_prerequisite_2)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_prerequisite_2",
  thedata = df_desc_pipeline_prerequisite_2,
  edit.label.cols = c("Step Number", "Name", "URI", "Access Time"),
  callback.insert = desc_pipeline_prerequisite_2.insert.callback,
  callback.update = desc_pipeline_prerequisite_2.update.callback,
  callback.delete = desc_pipeline_prerequisite_2.delete.callback
)

# load the edited df
load_desc_pipeline_prerequisite_2 <- reactive(if (file.exists(desc_pipeline_prerequisite_fname_2)) readRDS(desc_pipeline_prerequisite_fname_2) else NULL)

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
df_desc_pipeline_input_2 <- data.frame(
  "step_number" = as.character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_input_fname_2 <- tempfile(fileext = ".rds")

desc_pipeline_input_2.insert.callback <- function(data, row) {
  df_desc_pipeline_input_2 <- rbind(data, df_desc_pipeline_input_2)
  saveRDS(df_desc_pipeline_input_2, file = desc_pipeline_input_fname_2)
  return(df_desc_pipeline_input_2)
}

desc_pipeline_input_2.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_input_2[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_input_2, file = desc_pipeline_input_fname_2)
  return(df_desc_pipeline_input_2)
}

desc_pipeline_input_2.delete.callback <- function(data, row) {
  df_desc_pipeline_input_2 <- df_desc_pipeline_input_2[-row, ]
  saveRDS(df_desc_pipeline_input_2, file = desc_pipeline_input_fname_2)
  return(df_desc_pipeline_input_2)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_input_2",
  thedata = df_desc_pipeline_input_2,
  edit.label.cols = c("Step Number", "URI", "Access Time"),
  callback.insert = desc_pipeline_input_2.insert.callback,
  callback.update = desc_pipeline_input_2.update.callback,
  callback.delete = desc_pipeline_input_2.delete.callback
)

# load the edited df
load_desc_pipeline_input_2 <- reactive(if (file.exists(desc_pipeline_input_fname_2)) readRDS(desc_pipeline_input_fname_2) else NULL)

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
df_desc_pipeline_output_2 <- data.frame(
  "step_number" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
desc_pipeline_output_fname_2 <- tempfile(fileext = ".rds")

desc_pipeline_output_2.insert.callback <- function(data, row) {
  df_desc_pipeline_output_2 <- rbind(data, df_desc_pipeline_output_2)
  saveRDS(df_desc_pipeline_output_2, file = desc_pipeline_output_fname_2)
  return(df_desc_pipeline_output_2)
}

desc_pipeline_output_2.update.callback <- function(data, olddata, row) {
  df_desc_pipeline_output_2[row, ] <- data[1, ]
  saveRDS(df_desc_pipeline_output_2, file = desc_pipeline_output_fname_2)
  return(df_desc_pipeline_output_2)
}

desc_pipeline_output_2.delete.callback <- function(data, row) {
  df_desc_pipeline_output_2 <- df_desc_pipeline_output_2[-row, ]
  saveRDS(df_desc_pipeline_output_2, file = desc_pipeline_output_fname_2)
  return(df_desc_pipeline_output_2)
}

DTedit::dtedit(
  input, output,
  name = "desc_pipeline_output_2",
  thedata = df_desc_pipeline_output_2,
  edit.label.cols = c("Step Number", "URI", "Access Time"),
  callback.insert = desc_pipeline_output_2.insert.callback,
  callback.update = desc_pipeline_output_2.update.callback,
  callback.delete = desc_pipeline_output_2.delete.callback
)

# load the edited df
load_desc_pipeline_output_2 <- reactive(if (file.exists(desc_pipeline_output_fname_2)) readRDS(desc_pipeline_output_fname_2) else NULL)

# 5. execution

# script
observeEvent(input$execution_script_2, {
  feedbackSuccess(
    inputId = "execution_script_2",
    condition = nchar(input$execution_script_2) >= 7
  )
})

# script_driver
observeEvent(input$execution_script_driver_2, {
  feedbackSuccess(
    inputId = "execution_script_driver_2",
    condition = nchar(input$execution_script_driver_2) >= 2
  )
})

# execution_software_prerequisites
df_software_prerequisites_2 <- data.frame(
  "name" = "Seven Bridges Platform",
  "version" = as.character(Sys.Date()),
  "uri" = "https://igor.sbgenomics.com/",
  "access_time" = Sys.Date(),
  "sha1_chksum" = c(""),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
software_prerequisites_fname_2 <- tempfile(fileext = ".rds")

software_prerequisites_2.insert.callback <- function(data, row) {
  df_software_prerequisites_2 <- rbind(data, df_software_prerequisites_2)
  saveRDS(df_software_prerequisites_2, file = software_prerequisites_fname_2)
  return(df_software_prerequisites_2)
}

software_prerequisites_2.update.callback <- function(data, olddata, row) {
  df_software_prerequisites_2[row, ] <- data[1, ]
  saveRDS(df_software_prerequisites_2, file = software_prerequisites_fname_2)
  return(df_software_prerequisites_2)
}

software_prerequisites_2.delete.callback <- function(data, row) {
  df_software_prerequisites_2 <- df_software_prerequisites_2[-row, ]
  saveRDS(df_software_prerequisites_2, file = software_prerequisites_fname_2)
  return(df_software_prerequisites_2)
}

DTedit::dtedit(
  input, output,
  name = "execution_software_prerequisites_2",
  thedata = df_software_prerequisites_2,
  edit.label.cols = c(
    "Name", "Version", "URI", "Access Time", "SHA1 Checkksum"
  ),
  callback.insert = software_prerequisites_2.insert.callback,
  callback.update = software_prerequisites_2.update.callback,
  callback.delete = software_prerequisites_2.delete.callback
)

# load the edited df
load_software_prerequisites_2 <- reactive(if (file.exists(software_prerequisites_fname_2)) readRDS(software_prerequisites_fname_2) else NULL)

# execution_data_endpoints
df_data_endpoints_2 <- data.frame(
  "name" = character(),
  "url" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
data_endpoints_fname_2 <- tempfile(fileext = ".rds")

data_endpoints_2.insert.callback <- function(data, row) {
  df_data_endpoints_2 <- rbind(data, df_data_endpoints_2)
  saveRDS(df_data_endpoints_2, file = data_endpoints_fname_2)
  return(df_data_endpoints_2)
}

data_endpoints_2.update.callback <- function(data, olddata, row) {
  df_data_endpoints_2[row, ] <- data[1, ]
  saveRDS(df_data_endpoints_2, file = data_endpoints_fname_2)
  return(df_data_endpoints_2)
}

data_endpoints_2.delete.callback <- function(data, row) {
  df_data_endpoints_2 <- df_data_endpoints_2[-row, ]
  saveRDS(df_data_endpoints_2, file = data_endpoints_fname_2)
  return(df_data_endpoints_2)
}

DTedit::dtedit(
  input, output,
  name = "execution_data_endpoints_2",
  thedata = df_data_endpoints_2,
  edit.label.cols = c("Name", "URL"),
  callback.insert = data_endpoints_2.insert.callback,
  callback.update = data_endpoints_2.update.callback,
  callback.delete = data_endpoints_2.delete.callback
)

# load the edited df
load_data_endpoints_2 <- reactive(if (file.exists(data_endpoints_fname_2)) readRDS(data_endpoints_fname_2) else NULL)

# execution_environment_variables
df_environment_variables_2 <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
environment_variables_fname_2 <- tempfile(fileext = ".rds")

environment_variables_2.insert.callback <- function(data, row) {
  df_environment_variables_2 <- rbind(data, df_environment_variables_2)
  saveRDS(df_environment_variables_2, file = environment_variables_fname_2)
  return(df_environment_variables_2)
}

environment_variables_2.update.callback <- function(data, olddata, row) {
  df_environment_variables_2[row, ] <- data[1, ]
  saveRDS(df_environment_variables_2, file = environment_variables_fname_2)
  return(df_environment_variables_2)
}

environment_variables_2.delete.callback <- function(data, row) {
  df_environment_variables_2 <- df_environment_variables_2[-row, ]
  saveRDS(df_environment_variables_2, file = environment_variables_fname_2)
  return(df_environment_variables_2)
}

DTedit::dtedit(
  input, output,
  name = "execution_environment_variables_2",
  thedata = df_environment_variables_2,
  edit.label.cols = c("Key", "Value"),
  callback.insert = environment_variables_2.insert.callback,
  callback.update = environment_variables_2.update.callback,
  callback.delete = environment_variables_2.delete.callback
)

# load the edited df
load_environment_variables_2 <- reactive(if (file.exists(environment_variables_fname_2)) readRDS(environment_variables_fname_2) else NULL)

# 6. parametric

df_parametric_2 <- data.frame(
  "param" = character(),
  "value" = character(),
  "step" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
parametric_fname_2 <- tempfile(fileext = ".rds")

parametric_2.insert.callback <- function(data, row) {
  df_parametric_2 <- rbind(data, df_parametric_2)
  saveRDS(df_parametric_2, file = parametric_fname_2)
  return(df_parametric_2)
}

parametric_2.update.callback <- function(data, olddata, row) {
  df_parametric_2[row, ] <- data[1, ]
  saveRDS(df_parametric_2, file = parametric_fname_2)
  return(df_parametric_2)
}

parametric_2.delete.callback <- function(data, row) {
  df_parametric_2 <- df_parametric[-row, ]
  saveRDS(df_parametric_2, file = parametric_fname_2)
  return(df_parametric_2)
}

DTedit::dtedit(
  input, output,
  name = "parametric_2",
  thedata = df_parametric_2,
  edit.label.cols = c("Parameter", "Value", "Step Number"),
  callback.insert = parametric_2.insert.callback,
  callback.update = parametric_2.update.callback,
  callback.delete = parametric_2.delete.callback
)

# load the edited df
load_parametric_2 <- reactive(if (file.exists(parametric_fname_2)) readRDS(parametric_fname_2) else NULL)

# 7. io
# input
# output$io_input_2 <- DT::renderDT({
#   data.frame(
#     "filename" = character(),
#     "uri" =  character(),
#     "access_time" = character(),
#     stringsAsFactors = FALSE
#   )
# })
# input
df_input_subdomain_2 <- data.frame(
  "filename" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
input_subdomain_fname_2 <- tempfile(fileext = ".rds")

input_subdomain_2.insert.callback <- function(data, row) {
  df_input_subdomain_2 <- rbind(data, df_input_subdomain_2)
  saveRDS(df_input_subdomain_2, file = input_subdomain_fname_2)
  return(df_input_subdomain_2)
}

input_subdomain_2.update.callback <- function(data, olddata, row) {
  df_input_subdomain_2[row, ] <- data[1, ]
  saveRDS(df_input_subdomain_2, file = input_subdomain_fname_2)
  return(df_input_subdomain_2)
}

input_subdomain_2.delete.callback <- function(data, row) {
  df_input_subdomain_2 <- df_input_subdomain_2[-row, ]
  saveRDS(df_input_subdomain_2, file = input_subdomain_fname_2)
  return(df_input_subdomain_2)
}

DTedit::dtedit(
  input, output,
  name = "io_input_2",
  thedata = df_input_subdomain_2,
  edit.label.cols = c("Filename", "URI", "Access Time"),
  callback.insert = input_subdomain_2.insert.callback,
  callback.update = input_subdomain_2.update.callback,
  callback.delete = input_subdomain_2.delete.callback
)
#
# # load the edited df
load_input_subdomain_2 <- reactive(if (file.exists(input_subdomain_fname_2)) readRDS(input_subdomain_fname_2) else NULL)

# output
# output$io_output_2 <- DT::renderDT({
#   data.frame(
#     "mediatype" = character(),
#     "uri" = character(),
#     "access_time" = character(),
#     stringsAsFactors = FALSE
#   )
# })

df_output_subdomain_2 <- data.frame(
  "mediatype" = character(),
  "uri" = character(),
  "access_time" = as.Date(integer(), origin = "1970-01-01"),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
output_subdomain_fname_2 <- tempfile(fileext = ".rds")

output_subdomain_2.insert.callback <- function(data, row) {
  df_output_subdomain_2 <- rbind(data, df_output_subdomain_2)
  saveRDS(df_output_subdomain_2, file = output_subdomain_fname_2)
  return(df_output_subdomain_2)
}

output_subdomain_2.update.callback <- function(data, olddata, row) {
  df_output_subdomain_2[row, ] <- data[1, ]
  saveRDS(df_output_subdomain_2, file = output_subdomain_fname_2)
  return(df_output_subdomain_2)
}

output_subdomain_2.delete.callback <- function(data, row) {
  df_output_subdomain_2 <- df_output_subdomain_2[-row, ]
  saveRDS(df_output_subdomain_2, file = output_subdomain_fname_2)
  return(df_output_subdomain_2)
}

DTedit::dtedit(
  input, output,
  name = "io_output_2",
  thedata = df_output_subdomain_2,
  edit.label.cols = c("Media Type", "URI", "Access Time"),
  callback.insert = output_subdomain_2.insert.callback,
  callback.update = output_subdomain_2.update.callback,
  callback.delete = output_subdomain_2.delete.callback
)

# load the edited df
load_output_subdomain_2 <- reactive(if (file.exists(output_subdomain_fname_2)) readRDS(output_subdomain_fname_2) else NULL)

# 8. error

# empirical
df_error_empirical_2 <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
error_empirical_fname_2 <- tempfile(fileext = ".rds")

error_empirical_2.insert.callback <- function(data, row) {
  df_error_empirical_2 <- rbind(data, df_error_empirical_2)
  saveRDS(df_error_empirical_2, file = error_empirical_fname_2)
  return(df_error_empirical_2)
}

error_empirical_2.update.callback <- function(data, olddata, row) {
  df_error_empirical_2[row, ] <- data[1, ]
  saveRDS(df_error_empirical_2, file = error_empirical_fname_2)
  return(df_error_empirical_2)
}

error_empirical_2.delete.callback <- function(data, row) {
  df_error_empirical_2 <- df_error_empirical[-row, ]
  saveRDS(df_error_empirical_2, file = error_empirical_fname_2)
  return(df_error_empirical_2)
}

DTedit::dtedit(
  input, output,
  name = "error_empirical_2",
  thedata = df_error_empirical_2,
  edit.label.cols = c("Key", "Value"),
  callback.insert = error_empirical_2.insert.callback,
  callback.update = error_empirical_2.update.callback,
  callback.delete = error_empirical_2.delete.callback
)

# load the edited df
load_error_empirical_2 <- reactive(if (file.exists(error_empirical_fname_2)) readRDS(error_empirical_fname_2) else NULL)

# algorithmic
df_error_algorithmic_2 <- data.frame(
  "key" = character(),
  "value" = character(),
  stringsAsFactors = FALSE
)

# tmp file storing the latest edited df
error_algorithmic_fname_2 <- tempfile(fileext = ".rds")

error_algorithmic_2.insert.callback <- function(data, row) {
  df_error_algorithmic_2 <- rbind(data, df_error_algorithmic_2)
  saveRDS(df_error_algorithmic_2, file = error_algorithmic_fname_2)
  return(df_error_algorithmic_2)
}

error_algorithmic_2.update.callback <- function(data, olddata, row) {
  df_error_algorithmic_2[row, ] <- data[1, ]
  saveRDS(df_error_algorithmic_2, file = error_algorithmic_fname_2)
  return(df_error_algorithmic_2)
}

error_algorithmic_2.delete.callback <- function(data, row) {
  df_error_algorithmic_2 <- df_error_algorithmic_2[-row, ]
  saveRDS(df_error_algorithmic_2, file = error_algorithmic_fname_2)
  return(df_error_algorithmic_2)
}

DTedit::dtedit(
  input, output,
  name = "error_algorithmic_2",
  thedata = df_error_algorithmic_2,
  edit.label.cols = c("Key", "Value"),
  callback.insert = error_algorithmic_2.insert.callback,
  callback.update = error_algorithmic_2.update.callback,
  callback.delete = error_algorithmic_2.delete.callback
)

# load the edited df
load_error_algorithmic_2 <- reactive(if (file.exists(error_algorithmic_fname_2)) readRDS(error_algorithmic_fname_2) else NULL)

# top level fields
observeEvent(input$bco_id_2, {
  feedbackSuccess(
    inputId = "bco_id_2",
    condition = nchar(input$bco_id_2) >= 7
  )
})
