# server.R
# Source the external rendering functions
# List all the the function files to source
file_list <- c(
  "utils.R", # generic functions
  "rwhichsn1.R",
  "cwhatsp1.R",
  "stats_quality.R"
)
# Loop through each file in the list and attempt to source it
for (file_name in file_list) {
  tryCatch({
    source(file.path(lib_directory_result, file_name))
    print(paste("Successfully sourced:", file_name))
  }, error = function(e) {
    print(paste("Error in sourcing the file:", file_name, "- file not found or execution error."))
  })
}

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  # plot themes following the page theme
  thematic::thematic_shiny()
  # Enable bookmarking (add - enableBookmarking = "url" - to the shinyApp() call)
  # observe({
  #   reactiveValuesToList(input)
  #   session$doBookmark()
  # })
  # onBookmarked(updateQueryString)
  # ---------------------------------------- #
  # LANDING PAGE
  # ---------------------------------------- #
  observeEvent(input$go_to_result, {
    updateNavbarPage(session, "profile", selected = "Search results")
  })
  observeEvent(input$main_search, {
    updateNavbarPage(session, "profile", selected = "Search results")
  })
  # ---------------------------------------- #
  # RESULT PAGE: Estimation of the regional innovation capability
  # ---------------------------------------- #
  output$rwhichsn1_net <- renderLeaflet({
    result <- rplot_rwhichsn1(data_file, c(project_start_year, project_end_year), NULL, ui_font_size, "local")
    result$net %>% setView(lng = 144, lat = -37, zoom = 8) # center of the map positioned on Castlemaine
  })

  output$cwhatsp1_stats <- renderTable({
    result <- rplot_cwhatsp1(data_file)
    result$stats
  }, colnames = FALSE)

  output$rwhichsn1_org_stats <- renderTable({
          result <- rplot_rwhichsn1(data_file)
          result$stats
  }, colnames = FALSE)

  output$stats_quality <- renderTable({
    result <- stats_quality(data_file)
    result$stats
  }, colnames = FALSE)
  # ---------------------------------------- #
  # PAGES definitions: DATA
  # ---------------------------------------- #
  # Helper function to extract topics and render them as JSON
  get_topics_ui <- function(data, source_name) {
    # Initialize an empty list to store UI elements
    ui_elements <- list()

    # Loop over top-level elements (e.g., lens_scholarly, lens_patents, openalex)
    for (section_name in names(data)) {
      if (section_name == source_name){
        section <- data[[source_name]]
        # Check for 'main' and 'secondary' entries, excluding 'aggregations'
        for (sub_section_name in c("main", "secondary")) {
          if (!is.null(section[[sub_section_name]]$topics)) {
            topics <- section[[sub_section_name]]$topics

            # Loop over each topic in 'topics' and create UI elements
            for (topic in topics) {
              topic_name <- names(topic)
              topic_content <- topic[[topic_name]]

              # Convert topic content to JSON for display
              json_content <- toJSON(topic_content$value, pretty = TRUE)

              # Add topic name and JSON content to UI elements
              ui_elements <- append(ui_elements, list(
                tags$h4(topic_content$name),  # Topic title
                tags$pre(json_content)        # Display JSON content
              ))
            }
          }
        }
      }
    }

    # Return the list of UI elements
    do.call(tagList, ui_elements)
  }
  output$data_source_lens <- renderUI({
    get_topics_ui(project_search_strategy,"lens_scholarly")
  })
  # ---------------------------------------- #
  # PAGES definitions: ABOUT
  # ---------------------------------------- #
  output$list_contributors <- renderUI({
    # Loop through each contributor and create a line with role and name
    lapply(project_contributors, function(contributor) {
      tags$p(
        strong(contributor$role), ": ", contributor$name, " - ",
        tags$a(href = contributor$orcid, contributor$orcid, target = "_blank")
      )
    })
  })
  # ---------------------------------------- #
  # Other applications
  # ---------------------------------------- #
  # Observe tab changes and toggle sidebar visibility
  # observeEvent(input$page_sidebar, {
  #   toggle("sidebar")  # Toggles the visibility of the sidebar
  # })
  # observeEvent(input$profile, {
  #   if (input$profile != "panel_landing") {
  #     toggle("page_sidebar")  # Toggles the visibility of the sidebar
  #   }
  # })
  # observeEvent(input$profile, {
  #   if (input$profile == "panel_landing") {
  #     runjs('$("#page_sidebar").show();')  # Show sidebar
  #   } else {
  #     runjs('$("#page_sidebar").hide();')  # Hide sidebar
  #   }
  # })
  # ---------------------------------------- #
  # SHINY App CLEAN-UP
  # ---------------------------------------- #
  # Automatically disconnect when the app stops
  # onStop(function() {
  #   if (exists(conn)) {dbDisconnect(conn)}
  # })
  # enableBookmarking("url")
  # bslib::bs_themer() # use to select themes only
}
