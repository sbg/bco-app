# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

get_provenance_2 <- reactive({
  biocompute::compose_provenance(
    input$provenance_name_2, input$provenance_version_2, load_df_review_2(),
    input$provenance_derived_from_2, input$provenance_obsolete_after_2,
    input$provenance_embargo_2, input$provenance_created_2,
    input$provenance_modified_2, load_df_contributors_2(),
    input$provenance_license_2
  )
})

get_usability_2 <- reactive({
  biocompute::compose_usability(input$usability_text_2)
})

get_extension_2 <- reactive({
  fhir <- biocompute::compose_fhir(input$fhir_endpoint_2, input$fhir_version_2, load_df_fhir_resources_2())
  scm <- biocompute::compose_scm(input$scm_repository_2, input$scm_type_2, input$scm_commit_2, input$scm_path_2, input$scm_preview_2)
  biocompute::compose_extension(fhir, scm)
})

get_description_2 <- reactive({

  # pipeline_meta_2 <- data.frame(
  #   "step_number" = character(1),
  #   "name" = character(1),
  #   "description" = character(1),
  #   "version" = character(1),
  #   stringsAsFactors = FALSE
  # )

  biocompute::compose_description(
    input$desc_keywords_2, # trimws(unlist(strsplit(input$desc_keywords_2, ",")[[1]])),
    load_desc_xref_2(), input$desc_platform_2,
    load_desc_pipeline_meta_2(), load_desc_pipeline_prerequisite_2(),
    load_desc_pipeline_input_2(), load_desc_pipeline_output_2()
  )
})

get_execution_2 <- reactive({
  biocompute::compose_execution(
    input$execution_script_2,
    input$execution_script_driver_2,
    load_software_prerequisites_2(),
    load_data_endpoints_2(),
    load_environment_variables_2()
  )
})

get_parametric_2 <- reactive({
  biocompute::compose_parametric(load_parametric_2())
})

get_io_2 <- reactive({

  # io_input_2 <- data.frame(
  #   "filename" = character(1),
  #   "uri" = character(1),
  #   "access_time" = character(1),
  #   stringsAsFactors = FALSE
  # )
  #
  # io_output_2 <- data.frame(
  #   "mediatype" = character(1),
  #   "uri" = character(1),
  #   "access_time" = character(1),
  #   stringsAsFactors = FALSE
  # )
  # biocompute::compose_io(io_input_2, io_output_2)
  biocompute::compose_io(load_input_subdomain_2(), load_output_subdomain_2())
})

get_error_2 <- reactive({
  biocompute::compose_error(load_error_empirical_2(), load_error_algorithmic_2())
})

get_tlf_2 <- reactive({
  biocompute::compose_tlf(
    get_provenance_2(), get_usability_2(), get_extension_2(), get_description_2(),
    get_execution_2(), get_parametric_2(), get_io_2(), get_error_2(), input$bco_id_2
  )
})

get_bco_json_2 <- reactive({
  biocompute::compose(
    get_tlf_2(), get_provenance_2(), get_usability_2(), get_extension_2(),
    get_description_2(), get_execution_2(), get_parametric_2(),
    get_io_2(), get_error_2()
  ) %>% convert_json()
})

# preview bco json
observeEvent(input$btn_gen_bco_2, {
  updateAceEditor(session,
    "bco_previewer_2",
    value = get_bco_json_2()
  )
})

# download bco json
output$btn_export_json_2 <- downloadHandler(
  filename = function() {
    paste0(input$provenance_name_2, ".bco.json")
  },
  content = function(file) {
    tmp <- tempfile(fileext = ".bco.json")
    writeLines(get_bco_json_2(), tmp)
    file.rename(tmp, file)
  }
)
