# update projects list for selection
observeEvent({
  input$token_plaintext
  input$plat
  # bco_op <- input$bco_op
}, {
  plat <- input$plat
  token <- stringr::str_trim(input$token_plaintext)

  # if (bco_op == "bco_edit") {
  #   showModal(modalDialog("Loading projects with existing BCOs...", footer = NULL))
  #   projects <- if (length(token) == 0 | !is_token(token)) character(0) else get_list_bco_projects(plat, token)
  #   removeModal()
  # } else {
  projects <- character(0)
  
  if (!is_token(token) & (token != '')) {
    msg = "Please Check Your Token, Not Valid!"
    showModal(modalDialog(msg, footer = NULL))
    shinyjs::delay(3000, removeModal())
  } else {
    if (token != '') {
      showModal(modalDialog("Loading projects and workflows...", footer = NULL))
      lst_project <- get_list_project_sbgapi(plat, token)
      removeModal()
      
      if (is_token(token) & is.null(lst_project)) {
        msg = "Please Check Your Project! No Project to List."
        showModal(modalDialog(msg, footer = NULL))
        shinyjs::delay(3000, removeModal())
      } else {
        projects <- lst_project
      }
      # }
      updateSelectInput(session, "proj_name", choices = projects)
    }
  }
}, ignoreNULL = TRUE)

# update tasks list for selection
observeEvent({
  input$proj_name
}, {
  plat <- input$plat
  proj_name <- input$proj_name
  # bco_op <- input$bco_op
  token <- stringr::str_trim(input$token_plaintext)


  if (length(token) == 0 | !is_token(token)) {
    tasks <- character(0)
  } else {
    tasks <- get_list_task_sbgapi(plat, token, proj_name)
  }

  tasks <- if(is.null(tasks)) list() else tasks
  updateSelectInput(session, "task_name", choices = c("", tasks))
}, ignoreNULL = TRUE)

# update apps list for selection
observeEvent({
  input$proj_name
  # input$bco_op
  input$task_name
  input$plat
}, {
  plat <- input$plat
  proj_name <- input$proj_name
  task_name <- input$task_name
  # bco_op <- input$bco_op
  token <- stringr::str_trim(input$token_plaintext)

  if (length(token) == 0 | !is_token(token)) {
    apps <- character(0)
    app_task <- character(0)
  } else {
    # if (bco_op == "bco_edit") {
    #   app_task <- if (length(token) == 0 | length(task_name) == 0) character(0) else get_list_task_app_sbgapi(plat, token, proj_name, task_name)
    #   apps <- if (length(token) == 0 | !is_token(token)) character(0) else get_list_bco_app_sbgapi(plat, token, proj_name)
    # } else {
    app_task <- if (length(token) == 0 | length(task_name) == 0) character(0) else get_list_task_app_sbgapi(plat, token, proj_name, task_name)
    apps <- if (length(token) == 0 | !is_token(token)) character(0) else get_list_app_sbgapi(plat, token, proj_name)
    # }
  }

  if (nchar(task_name) > 1) {
    updateSelectInput(session, "app_name", choices = list("All Apps" = as.list(apps), "App of Task" = as.list(app_task)), selected = as.list(app_task)[1])
  } else {
    updateSelectInput(session, "app_name", choices = list("All Apps" = as.list(apps), "App of Task" = as.list(app_task)), selected = as.list(apps)[1])
  }

}, ignoreNULL = TRUE)

# observe({
#   if (length(input$task_name) > 1) {
#     updateVarSelectInput(session = session, inputId = "app_name", )
#   }
# })


# get task selected flag
get_taskused <- eventReactive(input$app_name, {
  token <- stringr::str_trim(input$token_plaintext)
  get_list_task_info_sbgapi(platform_target = input$plat, token = token, project_target = input$proj_name, task_name = input$task_name)
})

# get raw cwl
get_rawcwl <- eventReactive(input$app_name, {
  token <- stringr::str_trim(input$token_plaintext)
  cwl_out <- if (nchar(input$app_name) > 1) get_app_cwl_sbgapi(input$plat, input$proj_name, input$app_name, token) else NULL
})

output$testcwl <- renderPrint({
  get_rawcwl()
})

# update apps list for selection
# observeEvent({
#   input$app_name
#   input$proj_name
#   input$plat
#   input$token_plaintext
#   get_rawcwl()
# }, {
#   if (!is_cwl(get_rawcwl())) {
#     msg <- a("Check Selected CWL! ", href="Not Valid", target="_blank", style="color:red;")
#     showModal(modalDialog(msg, footer = NULL))
#     shinyjs::delay(3000, removeModal())
#   }
# }, ignoreNULL = TRUE)

## input ui with feedback --------------------------------------------

# list workflow names
# react_get_wf <- eventReactive(
#   {input$proj_name},
#   #sbpla_get_app(user_name = "nanx_demo", proj_name = input$proj_name)
#   plat <- input$plat,
#   token <- stringr::str_trim(input$token_plaintext),
#   if (length(token) == 0 | !is_token(token)) character(0) else list_app_sbgapi(plat, input$proj_name, token)
#   #updateSelectInput(session, "app_name", choices = apps),
#   #list_app_sbgapi
# )
# output$ui_wf_name <- renderUI({
#   selectInput("app_name", NULL, choices = c(react_get_wf()))
# })
