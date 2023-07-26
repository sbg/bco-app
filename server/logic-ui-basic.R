# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This document is the property of Seven Bridges Genomics Inc.
# It is considered confidential and proprietary.
#
# This document may not be reproduced or transmitted in any form,
# in whole or in part, without the express written permission of
# Seven Bridges Genomics Inc.

# landing page buttons
observeEvent(input$btn_nav_text, updateNavlistPanel(session, "nav_bco", selected = "Text Composer"))
observeEvent(input$btn_nav_file, updateNavlistPanel(session, "nav_bco", selected = "CWL Composer"))
observeEvent(input$btn_nav_plat, updateNavlistPanel(session, "nav_bco", selected = "Platform Composer"))
observeEvent(input$btn_nav_help, updateNavlistPanel(session, "nav_bco", selected = "Help"))

# prev, next buttons for Text Composer ------------------------------------------------

rv_page_basic <- reactiveValues(page_basic = 1)

observe({
  toggleState(id = "prev_btn_basic", condition = rv_page_basic$page_basic > 1)
  toggleState(id = "next_btn_basic", condition = rv_page_basic$page_basic < num_pages_basic)
  hide(selector = ".page_basic")
  show(paste0("step", rv_page_basic$page_basic, "_basic"))
})

nav_page_basic <- function(direction) {
  rv_page_basic$page_basic <- rv_page_basic$page_basic + direction
}

observeEvent(input$prev_btn_basic, nav_page_basic(-1))
observeEvent(input$next_btn_basic, nav_page_basic(1))

# prev, next buttons for Platform Composer ------------------------------------------------

rv_page <- reactiveValues(page = 1)

observe({
  toggleState(id = "prev_btn", condition = rv_page$page > 1)
  toggleState(id = "next_btn", condition = (rv_page$page < num_pages) & (tidycwl::is_cwl(get_rawcwl())))
  hide(selector = ".page")
  show(paste0("step", rv_page$page))
})

nav_page <- function(direction) {
  rv_page$page <- rv_page$page + direction
}

observeEvent(input$prev_btn, nav_page(-1))
observeEvent(input$next_btn, nav_page(1))

# prev, next buttons for Local Composer (CWL) ------------------------------------------------

rv_page_local <- reactiveValues(page_local = 1)

observe({
  toggleState(id = "prev_btn_local", condition = rv_page_local$page_local > 1)
  # toggleState(id = "next_btn_local", condition = ((rv_page_local$page_local < num_pages) & (tidycwl::is_cwl(get_rawcwl_local()))))
  hide(selector = ".page_local")
  show(paste0("step", rv_page_local$page_local, "_local"))
})

nav_page_local <- function(direction) {
  rv_page_local$page_local <- rv_page_local$page_local + direction
}

observeEvent(input$prev_btn_local, nav_page_local(-1))
observeEvent(input$next_btn_local, nav_page_local(1))
