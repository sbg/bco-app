# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

library("sevenbridges")
library("tools")

# get raw CWL based on workflow name
sbpla_get_cwl <- function(platform, token, user_name, proj_name, wf_name) {
  a <- suppressMessages(Auth(platform = platform, token = token))
  p <- a$project(id = paste0(user_name, "/", proj_name))

  wf_list <- p$app()
  wf_id <- wf_list[[which(sapply(wf_list, "[[", "name") == wf_name)]]$id
  wf_cwl <- httr::content(sevenbridges::api(base_url = .platforms[[platform]][["base_url"]], token = token, path = paste0("apps/", wf_id, "/raw"), method = "GET"))

  # return a list, to be combined with BCO domains later
  wf_cwl
}

# get CWL URI based on workflow name
sbpla_get_cwl_uri <- function(platform, token, user_name, proj_name, wf_name) {
  a <- suppressMessages(Auth(platform = platform, token = token))
  p <- a$project(id = paste0(user_name, "/", proj_name))

  wf_list <- p$app()
  wf_id <- wf_list[[which(sapply(wf_list, "[[", "name") == wf_name)]]$id
  wf_uri <- paste0(.platforms[[platform]][["token_url"]], wf_id)

  wf_uri
}

# list projects of a user
get_list_project_sbgapi <- function(platform = c("aws-us", "aws-eu", "cgc", "f4c", "cavatica"), token) {
  a <- suppressMessages(Auth(platform = platform, token = token))
  p <- try(a$project(complete = TRUE), silent = TRUE)
  if (class(p) == "try-error" | class(p) == "NULL") {
    return(NULL)
  }
  if (p@response$status_code == 200) sapply(p, "[[", "id") else NULL
}

# list task of a selected project
get_list_task_sbgapi <- function(platform_target, token, project_target) {
  a <- suppressMessages(Auth(platform = platform_target, token = token))
  tsk <- try(a$task(project = project_target))

  if (class(tsk) == "NULL" | is.null(tsk)) {
    return(NULL)
  }
  if (class(tsk) == "try-error") {
    return(NULL)
  }

  sapply(tsk, "[[", "name")
}

# list task-app workflows of a selected project
get_list_task_app_sbgapi <- function(platform_target, token, project_target, task_name) {
  a <- suppressMessages(Auth(platform = platform_target, token = token))
  tsk <- try(a$task(project = project_target, name = task_name, detail = TRUE, exact = TRUE))

  if (class(tsk) == "NULL" | is.null(tsk)) {
    return(NULL)
  }
  if (class(tsk) == "try-error") {
    return(NULL)
  }

  sapply(strsplit(sapply(tsk, "[[", "app"), split = "/"), "[[", 3)
}

# list task information (input, output)
get_list_task_info_sbgapi <- function(platform_target, token, project_target, task_name) {
  a <- suppressMessages(Auth(platform = platform_target, token = token))
  tsk <- try(a$task(project = project_target, name = task_name, detail = TRUE, exact = TRUE))

  if (class(tsk) == "NULL" | is.null(tsk)) {
    return(NULL)
  }
  if (class(tsk) == "try-error") {
    return(NULL)
  }

  tsk_inputs <- if (is.null(unlist(tsk[[1]]$inputs))) NULL else as.matrix(unlist(tsk[[1]]$inputs))
  tsk_inputs_paths <- tsk_inputs[grepl("\\.path$", rownames(tsk_inputs))]
  tsk_inputs_names <- tsk_inputs[grepl("\\.name$", rownames(tsk_inputs))]

  tsk_outputs <- if (is.null(unlist(tsk[[1]]$outputs))) NULL else as.matrix(unlist(tsk[[1]]$outputs))
  tsk_outputs_paths <- tsk_outputs[grepl("\\.path$", rownames(tsk_outputs))]
  tsk_outputs_names <- tsk_outputs[grepl("\\.name$", rownames(tsk_outputs))]

  info_io <- list()
  info_io$input_path <- as.character(1)
  info_io$input_name <- as.character(1)
  info_io$start_time <- as.character(1)
  info_io$step_number_input <- as.character(1)
  info_io$output_path <- as.character(1)
  info_io$output_name <- as.character(1)
  info_io$output_mediatype <- as.character(1)
  info_io$end_time <- as.character(1)
  info_io$step_number_output <- as.character(1)

  if (length(tsk_inputs_paths) > 0) {
    for (i in 1:length(tsk_inputs_paths)) {
      info_io$input_path[[i]] <- paste0(.platforms[[platform_target]][["file_url"]], project_target, "/files/", as.character(tsk_inputs_paths[i], "/"))
      info_io$input_name[[i]] <- as.character(tsk_inputs_names[i])
    }
    info_io$start_time <- rep(as.character(tsk[[1]]$start_time), length(tsk_inputs_paths))
    info_io$step_number_input <- as.character(1:length(tsk_inputs_paths))
  }

  if (length(tsk_outputs_paths) > 0) {
    for (i in 1:length(tsk_outputs_paths)) {
      info_io$output_path[[i]] <- paste0(.platforms[[platform_target]][["file_url"]], project_target, "/files/", as.character(tsk_outputs_paths[i], "/"))
      info_io$output_name[[i]] <- as.character(tsk_outputs_names[i])
      info_io$output_mediatype[[i]] <- as.character(tools::file_ext(tsk_outputs_names[i]))
    }
    info_io$end_time <- rep(as.character(tsk[[1]]$end_time), length(tsk_outputs_paths))
    info_io$step_number_output <- as.character(1:length(tsk_outputs_paths))
  }

  info_io
}

# list workflows of a selected project
get_list_app_sbgapi <- function(platform_target, token, project_target) {
  a <- suppressMessages(Auth(platform = platform_target, token = token))
  ap <- try(a$app(project = project_target))
  if (class(ap) == "try-error" | class(ap) == "NULL") {
    return(NULL)
  }
  if (class(try(ap@response, silent = TRUE)) == "try-error") {
    return(NULL)
  }
  if (ap@response$status_code == 200) sapply(strsplit(sapply(ap, "[[", "id"), split = "/"), "[[", 3) else NULL
}

# list BCOs in a selected project
get_list_bco_app_sbgapi <- function(platform_target, token, project_target) {
  a <- suppressMessages(Auth(platform = platform_target, token = token))
  root_bco_folder <- a$file(project = project_target, name = "BCO", exact = TRUE)
  if (class(root_bco_folder) == "try-error" | class(root_bco_folder) == "NULL") {
    return(NULL)
  }

  if (length(root_bco_folder) == 0) character(0) else sapply(root_bco_folder$list_folder_contents(), "[[", "name")
}

# get raw CWL based on workflow name
get_app_cwl_sbgapi <- function(platform_target, project_target, app_target, token) {
  if (!is_token(token)) {
    return(NULL)
  }
  a <- suppressMessages(Auth(platform = platform_target, token = token))
  ap <- try(a$app(project = project_target))
  if (class(ap) == "try-error" | class(ap) == "NULL") {
    return(NULL)
  }

  # return target app's id
  app_target_id <- ap[[which(sapply(strsplit(sapply(ap, "[[", "id"), split = "/"), "[[", 3) == app_target)]]$id

  # return a list of the workflow's CWL
  app_target_cwl <- httr::content(sevenbridges::api(base_url = .platforms[[platform_target]][["base_url"]], token = token, path = paste0("apps/", app_target_id, "/raw"), method = "GET"))
  class(app_target_cwl) <- "cwl"
  app_target_cwl
}

# return list of BCO folder existing projects
get_list_bco_projects <- function(platform, token) {
  a <- suppressMessages(Auth(platform = platform, token = token))
  p <- try(a$project(complete = TRUE), silent = TRUE)
  lst_p <- sapply(p, "[[", "id")
  vec_bco_exist <- vector()

  for (p_obj in lst_p) {
    p <- a$project(id = p_obj)
    check_bco <- p$file(name = "BCO", exact = TRUE)
    flag_no_bco <- is.null(check_bco)
    if (!flag_no_bco) {
      vec_bco_exist <- c(NA, vec_bco_exist)
      vec_bco_exist[length(1)] <- p_obj
    }
  }
  vec_bco_exist
}

# is bco folder exists in the target project
is_bco_folder_not_exist <- function(platform, token, proj_name) {
  a <- suppressMessages(Auth(platform = platform, token = token))
  p <- a$project(id = proj_name)
  # BCO folder check
  check_bco <- p$file(name = "BCO", exact = TRUE)
  return(is.null(check_bco))
}

# create bco folder if not exist in the target project
create_bco_folder <- function(platform, token, proj_name) {
  # auth connection
  a <- suppressMessages(Auth(platform = platform, token = token))
  # get projects
  p <- a$project(id = proj_name)
  # BCO folder check
  check_bco <- p$file(name = "BCO", exact = TRUE)

  result_msg <- ""

  if (is.null(check_bco)) {
    root_folder <- p$get_root_folder()
    folder_bco <- root_folder$create_folder("BCO")
    result_msg <- "BCO FOLDER IS CREATED!"
  } else {
    folder_bco <- p$file(name = "BCO", exact = TRUE)
    result_msg <- "BCO FOLDER EXISTS!"
  }

  # list about the process
  list(
    "msg" = result_msg,
    "id" = folder_bco$id
  )
}

# upload BCO to the platform
upload_sbgapi <- function(platform, token, proj_name, file_name, file_path) {
  # auth connection
  a <- suppressMessages(Auth(platform = platform, token = token))
  # get projects
  p <- a$project(id = proj_name)
  # upload file
  if (is_bco_folder_not_exist(platform = platform, token = token, proj_name = proj_name)) {
    u <- suppressMessages(p$upload(file_path, overwrite = TRUE, name = file_name))
    fl_new <- p$file(id = u$id)

    id_bco <- create_bco_folder(platform = platform, token = token, proj_name = proj_name)$id
    fl_new$move_to_folder(id_bco)
  } else {
    u <- suppressMessages(p$upload(file_path, overwrite = TRUE, name = file_name))
    fl_new <- p$file(id = u$id)

    folder_bco <- p$file(name = "BCO", exact = TRUE)
    fl_new$move_to_folder(folder_bco$id)
  }
  # check the result of the process
  msg <- if (u$response$status_code == 201) {
    "Upload successful!"
  } else {
    paste0("Upload failed, status code: ", u$response$status_code)
  }
  # list about the process
  list(
    "res" = u,
    "msg" = msg,
    "url" = paste0(
      .platforms[[platform]][["file_url"]],
      proj_name, "/files/", u$id, "/"
    )
  )
}

# help tab - list bco specs
gen_bco_domain_table_gt <- function(dframe, name_header, filter_domain) {
  dframe %>%
    dplyr::group_by(domain) %>%
    dplyr::filter(domain == filter_domain) %>%
    dplyr::select(-optional) %>%
    gt(rowname_col = "name", groupname_col = "domain") %>%
    tab_header(
      title = paste(name_header, filter_domain, sep = " ")
    ) %>%
    cols_label(
      id = "ID",
      # optional = "Optional",
      description = "Description"
    )
}

# GitHub connection
push_bco_to_git <- function(username, password, commit_text, filename_bco, file_bco, repository_url) {
  str_error <- ""
  flg_success <- TRUE
  path_repo <- tempfile(pattern = "repo-")
  # dir.create(path_bare)
  dir.create(path_repo)
  # credentials
  credentials <- git2r::cred_user_pass(username, password)

  env <- new.env()
  assign("error_have", "Successful Operation!", env = env)

  flg_clone <- tryCatch({
      repo <- git2r::clone(url = repository_url, local_path = path_repo, credentials = credentials)
      git2r::config(repo, user.name = "gcs", user.email = "contact@sevenbridges.com")
    },
    error = function(e) {
      print(e)
      FALSE
    }
  )

  writeLines(file_bco, file.path(path_repo, filename_bco))

  # add file to repo
  flg_add <- tryCatch(
    {
      git2r::add(repo, path = filename_bco)
    },
    error = function(e) {
      print(e)
      assign("error_have", e, env = env)
      FALSE
    }
  )


  # commit and its msg
  commit_text <- ifelse(nchar(commit_text) > 0, commit_text, "BCO file commit")
  flg_commit <- tryCatch(
    {
      git2r::commit(repo, message = commit_text)
    },
    error = function(e) {
      print(e)
      assign("error_have", e, env = env)
      FALSE
    }
  )

  # push
  flg_push <- tryCatch(
    {
      git2r::push(object = repo, credentials = credentials, refspec = "refs/heads/master")
    },
    error = function(e) {
      print(e)
      assign("error_have", e, env = env)
      FALSE
    }
  )

  flg_error <- (is.logical(flg_clone) || is.logical(flg_add) || is.logical(flg_commit) || is.logical(flg_push))
  # str_error <- ifelse(flg_error, "Unsuccessful operation!", "Successful push!")

  list(
    "summary" = as.character(paste(get("error_have", env = env), "\n", "Username: ", username, "\nPassword: ", "******", "\nCommit Message:", commit_text, "\nFile Committed:", filename_bco, "\nRepository URL:", repository_url, sep = "")),
    "url" = repository_url,
    "success" = !flg_error
  )
}

# git filename edit
filename_fixer <- function(str, sep = "_", date.format = "%Y_%m_%d_%H_%M_%S", extension = "bco.json") {
  stopifnot(is.character(str))
  fname <- paste(str, format(Sys.time(), date.format), sep = sep)
  fname <- paste(fname, extension, sep = ".")
  return(fname)
}
