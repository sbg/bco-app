# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

# landing page buttons
observeEvent(input$btn_start, updateNavlistPanel(session, "nav_bco", selected = "BCO Creator"))
observeEvent(input$btn_about, updateNavlistPanel(session, "nav_bco", selected = "Help"))

# prev, next buttons ------------------------------------------------

rv_page <- reactiveValues(page = 1)

observe({
  toggleState(id = "prev_btn", condition = rv_page$page > 1)
  toggleState(id = "next_btn", condition = (rv_page$page < num_pages) & nchar(input$app_name) > 1)
  hide(selector = ".page")
  show(paste0("step", rv_page$page))
})

nav_page <- function(direction) {
  rv_page$page <- rv_page$page + direction
}

observeEvent(input$prev_btn, nav_page(-1))
observeEvent(input$next_btn, nav_page(1))

# prev, next buttons ------------------------------------------------
