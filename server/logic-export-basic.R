get_provenance_basic <- reactive({
  biocompute::compose_provenance(
    input$provenance_name_basic, input$provenance_version_basic, load_df_review_basic(),
    input$provenance_derived_from_basic, input$provenance_obsolete_after_basic,
    input$provenance_embargo_basic, input$provenance_created_basic,
    input$provenance_modified_basic, load_df_contributors_basic(),
    input$provenance_license_basic
  )
})

get_usability_basic <- reactive({
  biocompute::compose_usability(input$usability_text_basic)
})

get_extension_basic <- reactive({
  fhir <- biocompute::compose_fhir(input$fhir_endpoint_basic, input$fhir_version_basic, load_df_fhir_resources_basic())
  scm <- biocompute::compose_scm(input$scm_repository_basic, input$scm_type_basic, input$scm_commit_basic, input$scm_path_basic, input$scm_preview_basic)
  biocompute::compose_extension(fhir, scm)
})

get_description_basic <- reactive({

  # pipeline_meta_basic <- data.frame(
  #   "step_number" = character(1),
  #   "name" = character(1),
  #   "description" = character(1),
  #   "version" = character(1),
  #   stringsAsFactors = FALSE
  # )

  biocompute::compose_description(
    input$desc_keywords_basic,#trimws(unlist(strsplit(input$desc_keywords_basic, ",")[[1]])),
    load_desc_xref_basic(), input$desc_platform_basic,
    load_desc_pipeline_meta_basic(), load_desc_pipeline_prerequisite_basic(),
    load_desc_pipeline_input_basic(), load_desc_pipeline_output_basic()
  )
})

get_execution_basic <- reactive({
  biocompute::compose_execution(
    input$execution_script_basic,
    input$execution_script_driver_basic,
    load_software_prerequisites_basic(),
    load_data_endpoints_basic(),
    load_environment_variables_basic()
  )
})

get_parametric_basic <- reactive({
  biocompute::compose_parametric(load_parametric_basic())
})

get_io_basic <- reactive({

  # io_input_basic <- data.frame(
  #   "filename" = character(1),
  #   "uri" = character(1),
  #   "access_time" = character(1),
  #   stringsAsFactors = FALSE
  # )
  #
  # io_output_basic <- data.frame(
  #   "mediatype" = character(1),
  #   "uri" = character(1),
  #   "access_time" = character(1),
  #   stringsAsFactors = FALSE
  # )
  # biocompute::compose_io(io_input_basic, io_output_basic)
  biocompute::compose_io(load_input_subdomain_basic(), load_output_subdomain_basic())
})

get_error_basic <- reactive({
  biocompute::compose_error(load_error_empirical_basic(), load_error_algorithmic_basic())
})

get_tlf_basic <- reactive({
  biocompute::compose_tlf(
    get_provenance_basic(), get_usability_basic(), get_extension_basic(), get_description_basic(),
    get_execution_basic(), get_parametric_basic(), get_io_basic(), get_error_basic(), input$bco_id_basic
  )
})

get_bco_json_basic <- reactive({
  biocompute::compose(
    get_tlf_basic(), get_provenance_basic(), get_usability_basic(), get_extension_basic(),
    get_description_basic(), get_execution_basic(), get_parametric_basic(),
    get_io_basic(), get_error_basic()
  ) %>% convert_json()
})



# preview bco json
observeEvent(input$btn_gen_bco_basic, {
  updateAceEditor(session,
                  "bco_previewer_basic",
                  value = get_bco_json_basic())
})

# download bco json
output$btn_export_json_basic <- downloadHandler(
  filename = function() {
    paste0(input$provenance_name_basic, ".bco.json")
  },
  content = function(file) {
    tmp <- tempfile(fileext = ".bco.json")
    writeLines(get_bco_json_basic(), tmp)
    file.rename(tmp, file)
  }
)
