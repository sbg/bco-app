# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This document is the property of Seven Bridges Genomics Inc.
# It is considered confidential and proprietary.
#
# This document may not be reproduced or transmitted in any form,
# in whole or in part, without the express written permission of
# Seven Bridges Genomics Inc.

# Add variable to control whether login page will be allowed
# source(file.path("ui", "interface_variables.R"), local = TRUE)

tabPanel(
  title = title_local_composer,
  icon = icon("desktop"),

  useShinyFeedback(),

  useShinyjs(),

  div(
    class = "page_local", id = "step1_local",

    fluidRow(column(
      width = 10, offset = 1,

      shinydashboard::box(
        width = 12,
        title = "Step 1/6 - Import", status = "primary", solidHeader = TRUE,

        fluidRow(column(includeHTML("css/progress1.html"), width = 12)),

        fluidRow(column(
          width = 10, offset = 1,

          h4("Upload your CWL to compose a brand-new BCO"),
          hr(),

          fluidRow(
            column(
              width = 10,
              fileInput("upfile_local_composer",
                label = "",
                multiple = F,
                width = "100%",
                placeholder = "Upload or Drop Your CWL File...",
                accept = c(".cwl", ".json", ".yaml")
              ),
            )
          ),
        ))
      )
    ), )
  ),

  hidden(
    div(
      class = "page_local", id = "step2_local",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 2/6 - Provenance / Usability / Extension", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress2.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("Workflow Visualization"),
            hr()
          )),


          fluidRow(column(
            width = 10, offset = 1,
            shinydashboard::box(
              width = 12, offset = 1,
              withSpinner(
                visNetworkOutput("vis_cwl_workflow_local"),
                proxy.height = "300px", color = "#0273B7"
              ),
            )
          )),

          hr(),

          fluidRow(column(
            width = 10, offset = 1,
            h3("1. Provenance Domain"),
            hr()
          )),

          fluidRow(
            column(
              width = 5, offset = 1,
              textInput(
                inputId = "provenance_name_local",
                label = "Name for the BCO",
                placeholder = "e.g. My CWL Workflow",
              )
            ),

            column(
              width = 5, offset = 0,
              textInput(
                inputId = "provenance_version_local",
                label = "Version of the BCO instance object",
                placeholder = "e.g. 2.1.0",
              )
            ),

            column(
              width = 10, offset = 1,
              textInput(
                inputId = "provenance_derived_from_local",
                label = "Inheritance or derivation from",
                placeholder = "e.g. https://example.com/workflow.json"
              )
            ),

            column(
              width = 10, offset = 1,
              textInput(
                inputId = "provenance_license_local",
                label = "License",
                value = "https://spdx.org/licenses/CC-BY-4.0.html",
                placeholder = "e.g. https://spdx.org/licenses/CC-BY-4.0.html"
              )
            ),

            column(
              width = 10, offset = 1,
              dateInput(
                inputId = "provenance_created_local",
                label = "BCO initial creation date"
              )
            ),

            column(
              width = 10, offset = 1,
              dateInput(
                inputId = "provenance_modified_local",
                label = "BCO modification date"
              )
            ),

            column(
              width = 10, offset = 1,
              dateInput(
                inputId = "provenance_obsolete_after_local",
                label = "BCO obsolescence (expiration) date"
              )
            ),

            column(
              width = 10, offset = 1,
              dateRangeInput(
                inputId = "provenance_embargo_local",
                label = "Embargo period (when the BCO is not public)"
              )
            ),

            column(
              width = 10, offset = 1,
              p(strong("Provenance - Reviews")),
              uiOutput("provenance_review_local")
            ),

            column(
              width = 10, offset = 1,
              p(strong("Provenance - Contributors")),
              uiOutput("provenance_contributors_local")
            )
          ),


          fluidRow(column(
            width = 10, offset = 1,
            h3("2. Usability Domain"),
            hr()
          )),

          fluidRow(
            column(
              width = 10, offset = 1,
              textAreaInput(
                inputId = "usability_text_local",
                label = "Describe the scientific use case and the function of the BCO:",
                rows = "15"
              )
            )
          ),


          fluidRow(column(
            width = 10, offset = 1,
            h3("3. Extension Domain"),
            hr()
          )),

          fluidRow(column(
            width = 10, offset = 1,
            h4("3.1 FHIR Extension"),
            hr()
          )),

          fluidRow(
            column(
              width = 7, offset = 1,
              textInput(
                inputId = "fhir_endpoint_local",
                label = "Endpoint URL of the FHIR server containing the resource:",
                placeholder = "e.g. http://fhir.example.com/baseDstu3"
              )
            ),

            column(
              width = 3, offset = 0,
              textInput(
                inputId = "fhir_version_local",
                label = "The FHIR version used:",
                placeholder = "e.g. 3"
              )
            ),

            column(
              width = 10, offset = 1,
              h5("FHIR Resources"),
              hr(),
              uiOutput("fhir_resources_local")
            )
          ),

          fluidRow(column(
            width = 10, offset = 1,
            h4("3.2 SCM Extension"),
            hr()
          )),

          fluidRow(
            column(
              width = 10, offset = 1,
              textInput(
                inputId = "scm_repository_local",
                label = "Base url for the SCM repository:",
                placeholder = "e.g. https://github.com/example/repo"
              )
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              selectInput(
                inputId = "scm_type_local",
                label = "Type of the SCM database",
                choices = c("git", "svn", "hg", "other")
              )
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              textInput(
                inputId = "scm_commit_local",
                label = "Revision ID within the scm repository:",
                placeholder = "e.g. c9ffea0b60fa3bcf8e138af7c99ca141a6b8fb21"
              )
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              textInput(
                inputId = "scm_path_local",
                label = "Path from the repository to the source code referenced:",
                placeholder = "e.g. src/workflow.cwl"
              )
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              textInput(
                inputId = "scm_preview_local",
                label = "Revision ID within the scm repository:",
                placeholder = "e.g. https://github.com/example/repo/blob/id/src/workflow.cwl"
              )
            )
          ),

          br(), br()
        )
      ))
    ),

    div(
      class = "page_local", id = "step3_local",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 3/6 - Execution / Parametric", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress3.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("4. Execution Domain"),
            hr()
          )),

          column(
            width = 10, offset = 1,
            textInput(
              inputId = "execution_script_local",
              label = "Script",
            )
          ),

          column(
            width = 10, offset = 1,
            textInput(
              inputId = "execution_script_driver_local",
              label = "Script driver",
              value = "Seven Bridges Common Workflow Language Executor"
            )
          ),

          column(
            width = 10, offset = 1,
            p(strong("Algorithmic tools and software prerequisites")),
            uiOutput("execution_software_prerequisites_local")
          ),

          column(
            width = 10, offset = 1,
            p(strong("External data endpoints")),
            uiOutput("execution_data_endpoints_local")
          ),

          column(
            width = 10, offset = 1,
            p(strong("Environment variables")),
            uiOutput("execution_environment_variables_local")
          ),

          fluidRow(column(
            width = 10, offset = 1,
            h3("5. Parametric Domain"),
            hr()
          )),

          fluidRow(column(
            width = 10, offset = 1,
            uiOutput("parametric_local")
          )),

          br(), br()
        )
      ))
    ),

    div(
      class = "page_local", id = "step4_local",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 4/6 - Description", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress4.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("6. Description Domain"),
            hr()
          )),

          fluidRow(
            column(
              width = 5, offset = 1,
              textInput(
                inputId = "desc_platform_local",
                label = "Platform",
                value = "Seven Bridges Platform",
              )
            ),
            column(
              width = 5, offset = 0,
              textInput(
                inputId = "desc_keywords_local",
                label = "A list of keywords that describe the experiment, separated by comma:",
                placeholder = "e.g. HCV1a, Ledipasvir, antiviral resistance",
              )
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("External References")),
              uiOutput("desc_xref_local")
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("Pipeline Metadata")),
              DT::DTOutput("desc_pipeline_meta_local")
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("Tool Prerequisites")),
              uiOutput("desc_pipeline_prerequisite_local")
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("Pipeline Input List")),
              uiOutput("desc_pipeline_input_local")
              # DT::DTOutput("desc_pipeline_input")
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("Pipeline Output List")),
              uiOutput("desc_pipeline_output_local")
              # DT::DTOutput("desc_pipeline_output")
            )
          ),

          br(), br()
        )
      ))
    ),

    div(
      class = "page_local", id = "step5_local",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 5/6 - IO / Error", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress5.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("7. Input/Output Domain"),
            hr()
          )),

          fluidRow(column(
            width = 10, offset = 1,
            p(strong("Input subdomain")),
            uiOutput("io_input_local")
            # DT::DTOutput("io_input_local")
          )),

          fluidRow(column(
            width = 10, offset = 1,
            p(strong("Output subdomain")),
            uiOutput("io_output_local")
            # DT::DTOutput("io_output_local")
          )),

          fluidRow(column(
            width = 10, offset = 1,
            h3("8. Error Domain"),
            hr()
          )),

          fluidRow(column(
            width = 10, offset = 1,
            p(strong("Empirical error subdomain")),
            uiOutput("error_empirical_local")
          )),

          fluidRow(column(
            width = 10, offset = 1,
            p(strong("Algorithmic error subdomain")),
            uiOutput("error_algorithmic_local")
          )),

          br(), br()
        )
      ))
    ),

    div(
      class = "page_local", id = "step6_local",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 6/6 - Review and Export", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress6.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("Top Level Fields"),
            hr()
          )),

          fluidRow(
            column(
              width = 10, offset = 1,
              textInput(
                inputId = "bco_id_local",
                label = "BCO ID",
                value = biocompute::generate_id()
              )
            )
          ),

          fluidRow(column(
            width = 10, offset = 1,
            h4("Review & Export"),
            hr()
          )),

          fluidRow(
            column(
              width = 10, offset = 1,
              column(
                width = 12,
                actionButton("btn_gen_bco_local", "Generate & Preview BCO", icon = icon("play"), class = "btn btn-block"), style = "margin-left: -6px;"
              )
            )
          ),

          br(),
          fluidRow(
            column(
              width = 10, offset = 1,
              aceEditor(
                "bco_previewer_local",
                value = '"Click the button below to generate and preview the BioCompute Object."',
                height = "320px",
                mode = "json",
                theme = "textmate",
                readOnly = TRUE,
                fontSize = 12
              )
            )
          ),

          fluidRow(column(
            width = 10, offset = 1,
            h4("Export as JSON/PDF"),
            hr()
          )),

          fluidRow(
            column(
              width = 5,
              downloadButton("btn_export_json_local", "Export as JSON", class = "btn btn-primary btn-block", style = "margin-left: 100px;")
            ),
            column(
              width = 5, offset = 1,
              downloadButton("btn_export_pdf_local", "Export as PDF", class = "btn btn-primary btn-block"), style = "margin-left: 100px;"
            )
          )

          # fluidRow(column(
          #   width = 10, offset = 1,
          #   h4("Save to the Platform"),
          #   hr()
          # )),
          #
          # fluidRow(
          #   column(
          #     width = 3, offset = 1,
          #     actionButton("btn_upload_plat_local", "Upload to Platform", icon = icon("cloud-upload-alt"), class = "btn btn-primary btn-block", style = "margin-left: 36px;")
          #   ),
          #   column(
          #     width = 3, offset = 0,
          #     uiOutput("btn_open_bco_plat_local")
          #   )
          # ),
          #
          # fluidRow(
          #   column(
          #     width = 10, offset = 1,
          #     tags$head(tags$style("#msg_upload { margin-left: 36px; }")),
          #     br(),
          #     column(width = 4, textOutput("msg_upload_local"))
          #   )
          # ),
          #
          # fluidRow(column(
          #   width = 10, offset = 1,
          #   h4("Save to Git Project"),
          #   hr()
          # )),
          #
          # fluidRow(
          #   column(
          #     width = 3, offset = 1,
          #     actionButton("btn_push_git_local", "Push to GitHub", icon = icon("cloud-upload-alt"), class = "btn btn-primary btn-block", style = "margin-left: 36px;")
          #   )
          # ),
          #
          # bsModal("gitaccount_local", "Push BCO to GitHub", "btn_push_git_local",
          #
          #         p("Push your genereated BCO file to your GitHub repo."),
          #         p("Note: we don't record any of your account information."),
          #
          #         hr(),
          #
          #         fluidRow(
          #           column(
          #             width = 5, offset = 1,
          #             textInput("user_name_local",label = "Username: ")
          #           ),
          #           column(
          #             width = 5, offset = 0,
          #             passwordInput("pass_user_local", label = "Password: ")
          #           )
          #         ),
          #
          #         fluidRow(
          #           column(
          #             width = 5, offset = 1,
          #             textInput("repo_name_local",label = "Repository Name: ", placeholder = "e.g. my-bco-project")
          #           ),
          #           column(
          #             width = 5, offset = 0,
          #             textInput("commit_info_local",label = "Commit Message: ", value = "BCO file commit", placeholder = "e.g. add new bco")
          #           )
          #         ),
          #
          #         hr(),
          #
          #         fluidRow(
          #           column(
          #             width = 10, offset = 1,
          #             textAreaInput("git_text_local", label = "Git commit message: ", value = "Type the preferred git commit message here", resize = "none", width = '400px',height = '250px')
          #           )
          #         ),
          #
          #         hr(),
          #
          #         fluidRow(
          #           column(
          #             width = 5, offset = 1,
          #             actionButton("push_yes_local", "Push", class = "btn btn-primary btn-block")
          #           ),
          #           column(
          #             width = 5, offset = 0,
          #             uiOutput("btn_open_git_local")
          #           )
          #         )
          # ),
          #
          # br(), br()
        )
      ))
    )
  ),

  fluidRow(
    column(
      width = 10, offset = 1,
      # style = 'margin-left: 5px; margin-right: 5px;',
      column(
        width = 3,
        disabled(actionButton(
          "prev_btn_local", "Previous",
          icon("arrow-circle-o-left"),
          class = "btn btn-block"
        ))
      ),
      column(
        width = 3, offset = 6,
        disabled(actionButton(
          "next_btn_local", "Next",
          icon("arrow-circle-o-right"),
          class = "btn btn-block"
        ))
      )
    )
  ),

  br(), br(), br(),

  fluidRow(column(width = 12)),

  fluidRow(column(width = 10, offset = 1, hr())),

  fluidRow(
    HTML('<p align="center">&copy; 2020 Seven Bridges &nbsp; &middot; &nbsp; <a href="https://www.sevenbridges.com/privacy-policy/" target="_blank">Privacy</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/copyright-policy/" target="_blank">Copyright</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/terms-of-service/" target="_blank">Terms</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/contact/" target="_blank">Contact</a></p>')
  )
)
