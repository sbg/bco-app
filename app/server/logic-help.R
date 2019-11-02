# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

observeEvent(input$bco_domain, {
  bco_domain <- input$bco_domain

  if (bco_domain == "bco_must") {
    hideTab(inputId = "domains", target = "Top Level Fields")
    hideTab(inputId = "domains", target = "Provenance Domain")
    hideTab(inputId = "domains", target = "Usability Domain")
    hideTab(inputId = "domains", target = "Extension Domain")
    hideTab(inputId = "domains", target = "Description Domain")
    hideTab(inputId = "domains", target = "Error Domain")
  } else {
    showTab(inputId = "domains", target = "Top Level Fields")
    showTab(inputId = "domains", target = "Provenance Domain")
    showTab(inputId = "domains", target = "Usability Domain")
    showTab(inputId = "domains", target = "Extension Domain")
    showTab(inputId = "domains", target = "Description Domain")
    showTab(inputId = "domains", target = "Error Domain")
  }
})

data_table_bco_specs <- read.delim("include/bco-spec.tsv", header = TRUE)

# generate specific tables according to their domains
output$table_top <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Top Level Fields"))
output$table_provenance <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Provenance Domain"))
output$table_usability <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Usability Domain"))
output$table_extension <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Extension Domain"))
output$table_description <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Description Domain"))
output$table_execution <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Execution Domain"))
output$table_parametric <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Parametric Domain"))
output$table_io <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Input and Output Domain"))
output$table_error <- render_gt(gen_bco_domain_table_gt(data_table_bco_specs, "BCO", "Error Domain, acceptable range of variability"))
