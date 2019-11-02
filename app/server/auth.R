# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

# reactive value containing user's authentication status
user_input <- reactiveValues(
  authenticated = FALSE, valid_credentials = FALSE,
  user_locked_out = FALSE, status = ""
)

# authenticate user by:
# 1. checking whether their username and password are in the credentials
# data frame and on the same row (credentials are valid)
# 2. if credentials are valid, retrieve their lockout status from the data frame
# 3. if user has failed login too many times and is not currently locked out,
#    change locked out status to TRUE in credentials DF and save DF to file
# 4. if user is not authenticated, determine whether the username or the password
#    is bad (username precedent over pw) or he is locked out. set status value for
#    error message code below
observeEvent(input$login_button, {
  credentials <- readRDS("credentials/credentials.rds")

  row_username <- which(credentials$user == input$login_user_name)

  # if username and password both match, credentials are valid
  # then retrieve locked out status
  password_ok <- FALSE
  if (length(row_username) == 1) {
    if (bcrypt::checkpw(input$password, credentials$pw[row_username])) {
      password_ok <- TRUE
      user_input$valid_credentials <- TRUE
      user_input$user_locked_out <- credentials$locked_out[row_username]
    }
  }

  # if user is not currently locked out but has now failed login too many times:
  # 1. set current lockout status to TRUE
  # 2. if username is present in credentials DF, set locked out status in
  #    credentials DF to TRUE and save DF
  if (input$login_button == max_lockout &
    user_input$user_locked_out == FALSE) {
    user_input$user_locked_out <- TRUE

    if (length(row_username) == 1) {
      credentials$locked_out[row_username] <- TRUE

      saveRDS(credentials, "credentials/credentials.rds")
    }
  }

  # if a user has valid credentials and is not locked out, he/she is authenticated
  if (user_input$valid_credentials == TRUE & user_input$user_locked_out == FALSE) {
    user_input$authenticated <- TRUE
  } else {
    user_input$authenticated <- FALSE
  }

  # if user is not authenticated, set login status variable for error messages below
  if (user_input$authenticated == FALSE) {
    if (user_input$user_locked_out == TRUE) {
      user_input$status <- "locked_out"
    } else if (length(row_username) > 1) {
      user_input$status <- "credentials_data_error"
    } else if (input$login_user_name == "" || length(row_username) == 0) {
      user_input$status <- "bad_user"
    } else if (input$password == "" || !password_ok) {
      user_input$status <- "bad_password"
    }
  }
})

# password entry UI componenets:
# username and password text fields, login button
output$uiLogin <- renderUI({
  wellPanel(
    HTML('<h3 style="color:#555"; align="center">Genomics Compliance Suite&trade;</h3>'),
    textInput("login_user_name", label = "", placeholder = "Username or email"),
    passwordInput("password", label = "", placeholder = "Password"),
    actionButton("login_button", "Login", width = "100%"),
    tags$style(type = "text/css", ".well { background: #FFF; }")
  )
})

# red error message if bad credentials
output$pass <- renderUI({
  if (user_input$status == "locked_out") {
    h5(strong(paste0(
      "The account has been locked because of too many\n",
      "failed login attempts. Please contact us."
    ), style = "color:red"), align = "center")
  } else if (user_input$status == "credentials_data_error") {
    h5(strong("Credentials data error. Please contact us.", style = "color:red"), align = "center")
  } else if (user_input$status == "bad_user") {
    h5(strong("Incorrect username or password", style = "color:red"), align = "center")
  } else if (user_input$status == "bad_password") {
    h5(strong("Incorrect username or password", style = "color:red"), align = "center")
  } else {
    ""
  }
})
