# Copyright (C) 2019 Seven Bridges Genomics Inc. All rights reserved.
#
# This program is licensed under the terms of the GNU Affero General
# Public License version 3 (https://www.gnu.org/licenses/agpl-3.0.txt).

tabPanel(
  title = "BCO Creator",

  useShinyFeedback(),

  useShinyjs(),

  div(
    class = "page_2", id = "step1_2",

    fluidRow(column(
      width = 10, offset = 1,
      shinydashboard::box(
        width = 12,
        title = "Step 1/5 - Provenance / Usability / Extension", status = "primary", solidHeader = TRUE,

        fluidRow(column(includeHTML("css/progress1-basic.html"), width = 12)),

        fluidRow(column(
          width = 10, offset = 1,
          h3("1. Provenance Domain"),
          hr()
        )),

        fluidRow(
          column(
            width = 5, offset = 1,
            textInput(
              inputId = "provenance_name_2",
              label = "Name for the BCO",
              placeholder = "e.g. My CWL Workflow"
            )
          ),

          column(
            width = 5, offset = 0,
            textInput(
              inputId = "provenance_version_2",
              label = "Version of the BCO instance object",
              placeholder = "e.g. 2.1.0"
            )
          ),

          column(
            width = 10, offset = 1,
            textInput(
              inputId = "provenance_derived_from_2",
              label = "Inheritance or derivation from",
              placeholder = "e.g. https://example.com/workflow.json"
            )
          ),

          column(
            width = 10, offset = 1,
            textInput(
              inputId = "provenance_license_2",
              label = "License",
              value = "https://spdx.org/licenses/CC-BY-4.0.html",
              placeholder = "e.g. https://spdx.org/licenses/CC-BY-4.0.html"
            )
          ),

          column(
            width = 10, offset = 1,
            dateInput(
              inputId = "provenance_created_2",
              label = "BCO initial creation date"
            )
          ),

          column(
            width = 10, offset = 1,
            dateInput(
              inputId = "provenance_modified_2",
              label = "BCO modification date"
            )
          ),

          column(
            width = 10, offset = 1,
            dateInput(
              inputId = "provenance_obsolete_after_2",
              label = "BCO obsolescence (expiration) date"
            )
          ),

          column(
            width = 10, offset = 1,
            dateRangeInput(
              inputId = "provenance_embargo_2",
              label = "Embargo period (when the BCO is not public)"
            )
          ),

          column(
            width = 10, offset = 1,
            p(strong("Provenance - Reviews")),
            uiOutput("provenance_review_2")
          ),

          column(
            width = 10, offset = 1,
            p(strong("Provenance - Contributors")),
            uiOutput("provenance_contributors_2")
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
              inputId = "usability_text_2",
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
              inputId = "fhir_endpoint_2",
              label = "Endpoint URL of the FHIR server containing the resource:",
              placeholder = "e.g. http://fhir.example.com/baseDstu3"
            )
          ),

          column(
            width = 3, offset = 0,
            textInput(
              inputId = "fhir_version_2",
              label = "The FHIR version used:",
              placeholder = "e.g. 3"
            )
          ),

          column(
            width = 10, offset = 1,
            h5("FHIR Resources"),
            hr(),
            uiOutput("fhir_resources_2")
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
              inputId = "scm_repository_2",
              label = "Base url for the SCM repository:",
              placeholder = "e.g. https://github.com/example/repo"
            )
          )
        ),

        fluidRow(
          column(
            width = 10, offset = 1,
            selectInput(
              inputId = "scm_type_2",
              label = "Type of the SCM database",
              choices = c("git", "svn", "hg", "other")
            )
          )
        ),

        fluidRow(
          column(
            width = 10, offset = 1,
            textInput(
              inputId = "scm_commit_2",
              label = "Revision ID within the scm repository:",
              placeholder = "e.g. c9ffea0b60fa3bcf8e138af7c99ca141a6b8fb21"
            )
          )
        ),

        fluidRow(
          column(
            width = 10, offset = 1,
            textInput(
              inputId = "scm_path_2",
              label = "Path from the repository to the source code referenced:",
              placeholder = "e.g. src/workflow.cwl"
            )
          )
        ),

        fluidRow(
          column(
            width = 10, offset = 1,
            textInput(
              inputId = "scm_preview_2",
              label = "Revision ID within the scm repository:",
              placeholder = "e.g. https://github.com/example/repo/blob/id/src/workflow.cwl"
            )
          )
        ),

        br(), br()
      )
    ))
  ),

  hidden(
    div(
      class = "page_2", id = "step2_2",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 2/5 - Execution / Parametric", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress2-basic.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("4. Execution Domain"),
            hr()
          )),

          column(
            width = 10, offset = 1,
            textInput(
              inputId = "execution_script_2",
              label = "Script"
            )
          ),

          column(
            width = 10, offset = 1,
            textInput(
              inputId = "execution_script_driver_2",
              label = "Script driver",
              value = "Seven Bridges Common Workflow Language Executor"
            )
          ),

          column(
            width = 10, offset = 1,
            p(strong("Algorithmic tools and software prerequisites")),
            uiOutput("execution_software_prerequisites_2")
          ),

          column(
            width = 10, offset = 1,
            p(strong("External data endpoints")),
            uiOutput("execution_data_endpoints_2")
          ),

          column(
            width = 10, offset = 1,
            p(strong("Environment variables")),
            uiOutput("execution_environment_variables_2")
          ),

          fluidRow(column(
            width = 10, offset = 1,
            h3("5. Parametric Domain"),
            hr()
          )),

          fluidRow(column(
            width = 10, offset = 1,
            uiOutput("parametric_2")
          )),

          br(), br()
        )
      ))
    ),

    div(
      class = "page_2", id = "step3_2",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 3/5 - Description", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress3-basic.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("6. Description Domain"),
            hr()
          )),

          fluidRow(
            column(
              width = 5, offset = 1,
              textInput(
                inputId = "desc_platform_2",
                label = "Platform",
                value = "Seven Bridges Platform"
              )
            ),
            column(
              width = 5, offset = 0,
              textInput(
                inputId = "desc_keywords_2",
                label = "A list of keywords that describe the experiment, separated by comma:",
                placeholder = "e.g. HCV1a, Ledipasvir, antiviral resistance"
              )
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("External References")),
              uiOutput("desc_xref_2")
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("Pipeline Metadata")),
              uiOutput("desc_pipeline_meta_2")
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("Tool Prerequisites")),
              uiOutput("desc_pipeline_prerequisite_2")
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("Pipeline Input List")),
              uiOutput("desc_pipeline_input_2")
            )
          ),

          fluidRow(
            column(
              width = 10, offset = 1,
              p(strong("Pipeline Output List")),
              uiOutput("desc_pipeline_output_2")
            )
          ),
          br(), br()
        )
      ))
    ),

    div(
      class = "page_2", id = "step4_2",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 4/5 - IO / Error", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress4-basic.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("7. Input/Output Domain"),
            hr()
          )),

          fluidRow(column(
            width = 10, offset = 1,
            p(strong("Input subdomain")),
            uiOutput("io_input_2")
            # DT::DTOutput("io_input_2")
          )),

          fluidRow(column(
            width = 10, offset = 1,
            p(strong("Output subdomain")),
            uiOutput("io_output_2")
            # DT::DTOutput("io_output_2")
          )),

          fluidRow(column(
            width = 10, offset = 1,
            h3("8. Error Domain"),
            hr()
          )),

          fluidRow(column(
            width = 10, offset = 1,
            p(strong("Empirical error subdomain")),
            uiOutput("error_empirical_2")
          )),

          fluidRow(column(
            width = 10, offset = 1,
            p(strong("Algorithmic error subdomain")),
            uiOutput("error_algorithmic_2")
          )),

          br(), br()
        )
      ))
    ),

    div(
      class = "page_2", id = "step5_2",

      fluidRow(column(
        width = 10, offset = 1,
        shinydashboard::box(
          width = 12,
          title = "Step 5/5 - Review and Export", status = "primary", solidHeader = TRUE,

          fluidRow(column(includeHTML("css/progress5-basic.html"), width = 12)),

          fluidRow(column(
            width = 10, offset = 1,
            h3("Top Level Fields"),
            hr()
          )),

          fluidRow(
            column(
              width = 10, offset = 1,
              textInput(
                inputId = "bco_id_2",
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
                actionButton("btn_gen_bco_2", "Generate & Preview BCO", icon = icon("play"), class = "btn btn-block"), style = "margin-left: -6px;"
              )
            )
          ),

          br(),
          fluidRow(
            column(
              width = 10, offset = 1,
              aceEditor(
                "bco_previewer_2",
                value = '"Click the button below to generate and preview the BioCompute Object."',
                height = "320px",
                mode = "json",
                theme = "textmate",
                readOnly = TRUE,
                fontSize = 12
              )
            )
          ),
          br(),
          fluidRow(
            column(
              width = 10, offset = 1,
              column(
                width = 12,
                downloadButton("btn_export_json_2", "Export as JSON", class = "btn btn-primary btn-block", style = "margin-left: -6px;")
              )
            )
          ),
          br(), br()
        )
      ))
    )
  ),

  fluidRow(
    column(
      width = 10, offset = 1,
      column(
        width = 3,
        disabled(actionButton(
          "prev_btn_2", "Previous",
          icon("arrow-circle-o-left"),
          class = "btn btn-block"
        ))
      ),
      column(
        width = 3, offset = 6,
        actionButton(
          "next_btn_2", "Next",
          icon("arrow-circle-o-right"),
          class = "btn btn-block"
        )
      )
    )
  ),

  br(), br(), br(),

  fluidRow(column(width = 12)),

  fluidRow(column(width = 10, offset = 1, hr())),

  fluidRow(
    HTML('<p align="center">&copy; 2019 Seven Bridges &nbsp; &middot; &nbsp; <a href="https://www.sevenbridges.com/privacy-policy/" target="_blank">Privacy</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/copyright-policy/" target="_blank">Copyright</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/terms-of-service/" target="_blank">Terms</a> &nbsp;&nbsp; <a href="https://www.sevenbridges.com/contact/" target="_blank">Contact</a></p>')
  )
)
