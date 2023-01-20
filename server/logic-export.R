get_provenance <- reactive({
  biocompute::compose_provenance(
    input$provenance_name, input$provenance_version, load_df_review(),
    input$provenance_derived_from, input$provenance_obsolete_after,
    input$provenance_embargo, input$provenance_created,
    input$provenance_modified, load_df_contributors(),
    input$provenance_license
  )
})

get_usability <- reactive({
  biocompute::compose_usability(input$usability_text)
})

get_extension <- reactive({
  fhir <- biocompute::compose_fhir(input$fhir_endpoint, input$fhir_version, load_df_fhir_resources())
  scm <- biocompute::compose_scm(input$scm_repository, input$scm_type, input$scm_commit, input$scm_path, input$scm_preview)
  biocompute::compose_extension(fhir, scm)
})

get_description <- reactive({

  biocompute::compose_description(
    trimws(unlist(strsplit(input$desc_keywords, ",")[[1]])),
    load_desc_xref(),
    input$desc_platform,
    load_desc_pipeline_meta(),
    load_desc_pipeline_prerequisite(),
    load_desc_pipeline_input(),
    load_desc_pipeline_output()
  )
})

get_execution <- reactive({
  biocompute::compose_execution(
    input$execution_script,
    input$execution_script_driver,
    load_software_prerequisites(),
    load_data_endpoints(),
    load_environment_variables()
  )
})

get_parametric <- reactive({
  biocompute::compose_parametric(load_parametric())
})

get_io <- reactive({

  if (!is.null(get_taskused())) {
    io_input <- data.frame(
      "filename" = get_taskused()$input_name,
      "uri" = get_taskused()$input_path,
      "access_time" = get_taskused()$start_time,
      stringsAsFactors = FALSE
    )

    io_output <- data.frame(
      "mediatype" = get_taskused()$output_mediatype,
      "uri" = get_taskused()$output_path,
      "access_time" = get_taskused()$end_time,
      stringsAsFactors = FALSE
    )
  } else {
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
  }


  biocompute::compose_io(io_input, io_output)
})

get_error <- reactive({
  biocompute::compose_error(load_error_empirical(), load_error_algorithmic())
})

get_tlf <- reactive({
  biocompute::compose_tlf(
    get_provenance(), get_usability(), get_extension(), get_description(),
    get_execution(), get_parametric(), get_io(), get_error(), input$bco_id
  )
})

get_bco_json <- reactive({
  biocompute::compose(
    get_tlf(), get_provenance(), get_usability(), get_extension(),
    get_description(), get_execution(), get_parametric(),
    get_io(), get_error()
  ) %>% convert_json()
})



# preview bco json
observeEvent(input$btn_gen_bco, {
  updateAceEditor(session,
                  "bco_previewer",
                  value = get_bco_json())
})
# preview bco json - clear when app_name is changed
observeEvent(input$app_name, {
  updateAceEditor(session,
                  "bco_previewer",
                  value = '"Click the button below to generate and preview the BioCompute Object."')
})

# download bco json
output$btn_export_json <- downloadHandler(
  filename = function() {
    paste0(input$app_name, ".bco.json")
  },
  content = function(file) {
    tmp <- tempfile(fileext = ".bco.json")
    writeLines(get_bco_json(), tmp)
    file.rename(tmp, file)
  }
)

# button to upload a file to the platform
observeEvent(input$btn_upload_plat, {#upload_react <- eventReactive(input$btn_upload_plat, {
  showModal(modalDialog("Uploading to the platform...", footer = NULL))
  plat <- input$plat
  token <- stringr::str_trim(input$token_plaintext)
  proj_name <- input$proj_name
  file_name <- paste0(input$app_name, ".bco.json")
  file_text <- input$bco_previewer

  file_path <- tempfile(fileext = ".bco.json")
  conn <- file(file_path)
  writeLines(file_text, conn)
  close(conn)

  lst_upload <- upload_sbgapi(plat, token, proj_name, file_name, file_path)

  removeModal()
  url <- a("Open Generated BCO in Platform", href=lst_upload$"url", target="_blank", style="color:green;text-decoration:underline")
  msg_result <- tagList(lst_upload$msg, url)#" window.open('", url, "', '_blank')")
  showModal(modalDialog(msg_result, footer = NULL))
  shinyjs::delay(6000, removeModal())

  lst_upload
})

# BCO DB Object Local
output$btn_open_bco_db_local <- renderUI({
  url <- "https://biocomputeobject.org/objects"
  actionButton(
    "link_bco_db_object", "Open BioCompute DB",
    icon("external-link"),
    class = "btn btn-primary btn-block",
    onclick = paste0("window.open('", url, "', '_blank')"),
    style = "margin-left: 20px;"
  )
})

# BCO DB Object Text
output$btn_open_bco_db_txt <- renderUI({
  url <- "https://biocomputeobject.org/objects"
  actionButton(
    "link_bco_db_object", "Open BioCompute DB",
    icon("external-link"),
    class = "btn btn-primary btn-block",
    onclick = paste0("window.open('", url, "', '_blank')"),
    style = "margin-left: 20px;"
  )
})

# render button with link to task
output$btn_open_bco_plat <- renderUI({
  url <- upload_react()$"url"
  actionButton(
    "link_bco_plat", "Open BCO on Seven Bridges Platform",
    icon("external-link"),
    class = "btn btn-primary btn-block",
    onclick = paste0("window.open('", url, "', '_blank')"),
    style = "margin-left: 20px;"
  )
})

get_valChecksum <- eventReactive(input$btn_upfile_validate_bco, {
  str_checksum <- "Please check your input BCO File!"
  if (!is.null(input$upfile_validate_bco) || !(length(input$upfile_validate_bco) == 0)){
    str_checksum <- capture.output(biocompute::validate_checksum(file = input$upfile_validate_bco$datapath))
  }
  paste(str_checksum, collapse = "<br>")
})

output$val_check_text <- renderText({
  get_valChecksum()
})

get_valSchema <- eventReactive(input$btn_upfile_validate_bco, {
  str_schema <- "Please check your input BCO File!"
  if (!is.null(input$upfile_validate_bco) || !(length(input$upfile_validate_bco) == 0)){
    path_json <- input$upfile_validate_bco$datapath
    str_schema <- callr::r(function(x) capture.output(biocompute::validate_schema(x)), args = list(path_json))
  }
  paste0(str_schema, collapse = "<br>")
})

output$val_schema_text <- renderText({
  get_valSchema()
})

# preview bco json
observeEvent(input$btn_upfile_validate_bco, {
  if (!is.null(input$upfile_validate_bco) || !(length(input$upfile_validate_bco) == 0)){
    filePath <- input$upfile_validate_bco$datapath
    fileText <- paste(readLines(filePath), collapse = "\n")
    updateAceEditor(session, "bco_preview_validate", value = fileText)
  }
})

get_val_browser <- eventReactive(input$btn_upfile_browser_bco, {
  if (!is.null(input$upfile_browser_bco) || !(length(input$upfile_browser_bco) == 0)) {
    reactjson(
      jsonlite::fromJSON(paste(readLines(input$upfile_browser_bco$datapath), collapse = "\n")),
      iconStyle = "triangle"
    )
  }
})

output$bco_preview_browser <- renderReactjson({
  get_val_browser()
})

# print upload status
output$msg_upload <- renderText({
  upload_react()$"msg"
})

# Git window
output$btn_open_git <- renderUI({

  if(check_entries() & push_to_git()$"success"){
    url <- push_to_git()$"url"
    actionButton(
      "link_git", "Open Repository",
      icon("external-link"),
      class = "btn btn-primary btn-block",
      onclick = paste0("window.open('", url, "', '_blank')")
    )
  }

})

# CGC
check_entries <- eventReactive(input$push_yes, {
  ifelse (is.null(input$userName) ||
            is.null(input$passUser) ||
            is.null(input$repo_name), FALSE, TRUE)
})

# Text
check_entries_txt <- eventReactive(input$push_yes_txt, {
  ifelse (is.null(input$userName_txt) ||
            is.null(input$passUser_txt) ||
            is.null(input$repo_name_txt), FALSE, TRUE)
})

# Local
check_entries_loc <- eventReactive(input$push_yes_loc, {
  ifelse (is.null(input$userName_loc) ||
            is.null(input$passUser_loc) ||
            is.null(input$repo_name_loc), FALSE, TRUE)
})

push_to_git <- eventReactive(input$push_yes, {
  # bco
  fname_user_bco <- filename_fixer(input$app_name)
  bco_user <- get_bco_json()

  # #cwl
  # fname_user_cwl <- filename_fixer(input$app_name, extension = "cwl.json")
  # cwl_user <- as.character(get_rawcwl())

  link_user <- as.character(paste("https://github.com", input$userName, input$repo_name, sep = "/"))

  if(check_entries()) {
    # push bco
    push_bco_to_git(username = input$userName,
                    password = input$passUser,
                    commit_text = input$commit_info,
                    filename_bco = fname_user_bco,
                    file_bco = bco_user,
                    repository_url = link_user)
    # # push cwl
    # push_bco_to_git(username = input$userName,
    #                 password = input$passUser,
    #                 commit_text = input$commit_info,
    #                 filename_bco = fname_user_cwl,
    #                 file_bco = cwl_user,
    #                 repository_url = link_user)
  } else{
    return("Please check your Username, password and URL!")
  }
})

push_to_git_txt <- eventReactive(input$push_yes_txt, {
  # bco
  fname_user_bco <- filename_fixer(input$app_name_txt)
  bco_user <- get_bco_json_basic()

  # #cwl
  # fname_user_cwl <- filename_fixer(input$app_name, extension = "cwl.json")
  # cwl_user <- as.character(get_rawcwl())

  link_user <- as.character(paste("https://github.com", input$userName_txt, input$repo_name_txt, sep = "/"))

  if(check_entries_txt()) {
    # push bco
    push_bco_to_git(username = input$userName_txt,
                    password = input$passUser_txt,
                    commit_text = input$commit_info_txt,
                    filename_bco = fname_user_bco,
                    file_bco = bco_user,
                    repository_url = link_user)
  } else{
    return("Please check your Username, password and URL!")
  }
})

# CGC
check_entries_bco <- eventReactive(input$push_yes_bco, {
  ifelse (is.null(input$token_bco) || is.null(input$bco_prefix) ||
          is.null(input$bco_schema) || is.null(input$bco_owner_group), FALSE, TRUE)
})
# Text
check_entries_bco_txt <- eventReactive(input$push_yes_bco_txt, {
  ifelse (is.null(input$token_bco_txt) || is.null(input$bco_prefix_txt) ||
          is.null(input$bco_schema_txt) || is.null(input$bco_owner_group_txt), FALSE, TRUE)
})
# Local
check_entries_bco_local <- eventReactive(input$push_yes_bco_local, {
  ifelse (is.null(input$token_bco_local) || is.null(input$bco_prefix_local) ||
          is.null(input$bco_schema_local) || is.null(input$bco_owner_group_local), FALSE, TRUE)
})

observeEvent(input$push_yes_bco, {

  msg_return <- "Please check your Token, BCO Prefix, Schema, and Owner Group!"

  if(check_entries_bco()) {
    bco_object <- get_bco_json()
    # bco_file_path <- "bco-example.json"

    token <- input$token_bco
    bco_prefix <- input$bco_prefix
    bco_schema <- input$bco_schema
    bco_owner_group <- input$bco_owner_group

    # msg_push_bco <- upload_draft_bco_to_db_from_file(bco_file_path=bco_file_path, 
    #                                                 token=token, 
    #                                                 bco_prefix=bco_prefix, 
    #                                                 bco_schema=bco_schema, 
    #                                                 bco_owner_group=bco_owner_group)

    msg_push_bco <- upload_draft_bco_to_db(bco_object=bco_object, 
                                            token=token, 
                                            bco_prefix=bco_prefix, 
                                            bco_schema=bco_schema, 
                                            bco_owner_group=bco_owner_group)
    msg_return <- msg_push_bco

  }

  updateTextAreaInput(session, "bco_return_msg", value = msg_return)

})

observeEvent(input$push_yes_bco_txt, {

  msg_return <- "Please check your Token, BCO Prefix, Schema, and Owner Group!"

  if(check_entries_bco_txt()) {
    bco_object <- get_bco_json_basic()
    # bco_file_path <- "bco-example.json"

    token <- input$token_bco_txt
    bco_prefix <- input$bco_prefix_txt
    bco_schema <- input$bco_schema_txt
    bco_owner_group <- input$bco_owner_group_txt

    msg_push_bco <- upload_draft_bco_to_db(bco_object=bco_object, 
                                            token=token, 
                                            bco_prefix=bco_prefix, 
                                            bco_schema=bco_schema, 
                                            bco_owner_group=bco_owner_group)
    msg_return <- msg_push_bco

  }

  updateTextAreaInput(session, "bco_return_msg_txt", value = msg_return)

})

observeEvent(input$push_yes_bco_local, {

  msg_return <- "Please check your Token, BCO Prefix, Schema, and Owner Group!"

  if(check_entries_bco_local()) {
    bco_object <- get_bco_json_local()
    # bco_file_path <- "bco-example.json"

    token <- input$token_bco_local
    bco_prefix <- input$bco_prefix_local
    bco_schema <- input$bco_schema_local
    bco_owner_group <- input$bco_owner_group_local

    # msg_push_bco <- upload_draft_bco_to_db_from_file(bco_file_path=bco_file_path, 
    #                                                 token=token, 
    #                                                 bco_prefix=bco_prefix, 
    #                                                 bco_schema=bco_schema, 
    #                                                 bco_owner_group=bco_owner_group)

    msg_push_bco <- upload_draft_bco_to_db(bco_object=bco_object, 
                                            token=token, 
                                            bco_prefix=bco_prefix, 
                                            bco_schema=bco_schema, 
                                            bco_owner_group=bco_owner_group)
    msg_return <- msg_push_bco

  }

  updateTextAreaInput(session, "bco_return_msg_local", value = msg_return)

})
output$btn_open_bco_db <- renderUI({
  url <- "https://biocomputeobject.org/objects"
  actionButton(
    "link_bco_db", "Open biocomputeobject.org",
    icon("external-link"),
    class = "btn btn-primary btn-block",
    onclick = paste0("window.open('", url, "', '_blank')")
  )
})