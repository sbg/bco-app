get_provenance_local <- reactive({
  biocompute::compose_provenance(
    input$provenance_name_local, input$provenance_version_local, load_df_review_local(),
    input$provenance_derived_from_local, input$provenance_obsolete_after_local,
    input$provenance_embargo_local, input$provenance_created_local,
    input$provenance_modified_local, load_df_contributors_local(),
    input$provenance_license_local
  )
})

get_usability_local <- reactive({
  biocompute::compose_usability(input$usability_text_local)
})

get_extension_local <- reactive({
  fhir <- biocompute::compose_fhir(input$fhir_endpoint_local, input$fhir_version_local, load_df_fhir_resources_local())
  scm <- biocompute::compose_scm(input$scm_repository_local, input$scm_type_local, input$scm_commit_local, input$scm_path_local, input$scm_preview_local)
  biocompute::compose_extension(fhir, scm)
})

get_description_local <- reactive({

  # if (!is.null(get_rawcwl_local() %>% parse_steps())) {
  #   pipeline_meta <- data.frame(
  #     "step_number" = as.character(1:length(get_rawcwl_local() %>% parse_steps() %>% get_steps_id())),
  #     "name" = tryCatch({get_rawcwl_local() %>% parse_steps() %>% get_steps_id()}, error = function(e) {""}),
  #     "description" = tryCatch({get_rawcwl_local() %>% parse_steps() %>% get_steps_doc()}, error = function(e) {""}),
  #     "version" = tryCatch({get_rawcwl_local() %>% parse_steps() %>% get_steps_version()}, error = function(e) {""}),
  #     stringsAsFactors = FALSE
  #   )
  # } else {
  #   pipeline_meta <- data.frame(
  #     "step_number" = character(1),
  #     "name" = character(1),
  #     "description" = character(1),
  #     "version" = character(1),
  #     stringsAsFactors = FALSE
  #   )
  # }

  biocompute::compose_description(
    trimws(unlist(strsplit(input$desc_keywords_local, ",")[[1]])),
    load_desc_xref_local(),
    input$desc_platform_local,
    load_desc_pipeline_meta_local(),
    load_desc_pipeline_prerequisite_local(),
    load_df_desc_pipeline_input_local(),
    load_desc_pipeline_output_local()
  )
})

get_execution_local <- reactive({
  biocompute::compose_execution(
    input$execution_script_local,
    input$execution_script_driver_local,
    load_software_prereq_local(),
    load_data_endps_local(),
    load_env_vars_local()
  )
})

get_parametric_local <- reactive({
  biocompute::compose_parametric(load_parametric_local())
})

get_io_local <- reactive({

  io_input <- data.frame(
    "filename" = character(1),
    "uri" = character(1),
    "access_time" = character(1),
    stringsAsFactors = FALSE
  )

  io_output <- data.frame(
    "mediatype" = character(1),
    "uri" = character(1),
    "access_time" = character(1),
    stringsAsFactors = FALSE
  )
  biocompute::compose_io(io_input, io_output)
})

get_error_local <- reactive({
  biocompute::compose_error(load_error_empr_local(), load_error_algo_local())
})

get_tlf_local <- reactive({
  biocompute::compose_tlf(
    get_provenance_local(), get_usability_local(), get_extension_local(), get_description_local(),
    get_execution_local(), get_parametric_local(), get_io_local(), get_error_local(), input$bco_id_local
  )
})

get_bco_json_local <- reactive({
  biocompute::compose(
    get_tlf_local(), get_provenance_local(), get_usability_local(), get_extension_local(),
    get_description_local(), get_execution_local(), get_parametric_local(),
    get_io_local(), get_error_local()
  ) %>% convert_json()
})



# preview bco json
observeEvent(input$btn_gen_bco_local, {
  updateAceEditor(session,
                  "bco_previewer_local",
                  value = get_bco_json_local())
})
# TODO: change it to clearn when uploaded file is changed
# preview bco json - clear when app_name is changed
# observeEvent(input$app_name, {
#   updateAceEditor(session,
#                   "bco_previewer",
#                   value = '"Click the button below to generate and preview the BioCompute Object."')
# })

# download bco json
output$btn_export_json_local <- downloadHandler(
  filename = function() {
    paste0(input$provenance_name_local, ".bco.json")
  },
  content = function(file) {
    tmp <- tempfile(fileext = ".bco.json")
    writeLines(get_bco_json_local(), tmp)
    file.rename(tmp, file)
  }
)

# TODO: implement at the end, you should move authentication window to the end for local file upload
# button to upload a file to the platform
# upload_react <- eventReactive(input$btn_upload_plat, {
#   showModal(modalDialog("Uploading to the platform...", footer = NULL))
#   plat <- input$plat
#   token <- stringr::str_trim(input$token_plaintext)
#   proj_name <- input$proj_name
#   file_name <- paste0(input$app_name, ".bco.json")
#   file_text <- input$bco_previewer
#
#   file_path <- tempfile(fileext = ".bco.json")
#   conn <- file(file_path)
#   writeLines(file_text, conn)
#   close(conn)
#
#   lst_upload <- upload_sbgapi(plat, token, proj_name, file_name, file_path)
#
#   removeModal()
#   showModal(modalDialog(lst_upload$msg, footer = NULL))
#   shinyjs::delay(2000, removeModal())
#
#   lst_upload
# })

output$bco_preview_browser_local <- renderReactjson({
  get_val_browser_local()
})

# TODO
# print upload status
# output$msg_upload_local <- renderText({
#   upload_react_local()$"msg"
# })

# Git window
# output$btn_open_git_local <- renderUI({
#
#   if(check_entries() & push_to_git()$"success"){
#     url <- push_to_git()$"url"
#     actionButton(
#       "link_git_local", "Open Repository",
#       icon("external-link"),
#       class = "btn btn-primary btn-block",
#       onclick = paste0("window.open('", url, "', '_blank')")
#     )
#   }
#
# })

# push_to_git_local <- eventReactive(input$push_yes_local, {
#   # bco
#   fname_user_bco <- filename_fixer(input$app_name_local)
#   bco_user <- get_bco_json_local()
#
#   # TODO:
#   # #cwl
#   # fname_user_cwl <- filename_fixer(input$app_name, extension = "cwl.json")
#   # cwl_user <- as.character(get_rawcwl())
#
#   link_user <- as.character(paste("https://github.com", input$user_name_local, input$repo_name_local, sep = "/"))
#
#   if(check_entries()) {
#     # push bco
#     push_bco_to_git(username = input$user_name_local,
#                     password = input$pass_user_local,
#                     commit_text = input$commit_info_local,
#                     filename_bco = fname_user_bco,
#                     file_bco = bco_user,
#                     repository_url = link_user)
#     # # push cwl
#     # push_bco_to_git(username = input$userName,
#     #                 password = input$passUser,
#     #                 commit_text = input$commit_info,
#     #                 filename_bco = fname_user_cwl,
#     #                 file_bco = cwl_user,
#     #                 repository_url = link_user)
#   } else{
#     return("Please check your Username, password and URL!")
#   }
# })
