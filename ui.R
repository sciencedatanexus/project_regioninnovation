# Define UI for app that draws a dashboard ----
# NOT setup as a function to enable bookmarking (https://shiny.posit.co/r/reference/shiny/0.14/enablebookmarking)
ui <- fluidPage(
  page_navbar(
    useShinyjs(),
    # ---------------------------------------- #
    # APP settings
    # ---------------------------------------- #
    # Add custom CSS
    # tags$head(
    #   tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    # ),
    tags$head(includeCSS("www/styles.css")),
    # App title ----
    title = content_page_title,
    # a character string used for dynamically updating the container ----
    id = "profile",
    # App theme (uncomment bs_themer() in server to test alternative themes) ----
    # shiny::bootstrapLib(),
    theme = bslib::bs_theme(preset = "minty"),
    # theme = bslib::bs_theme(preset = "lux"),
    # theme = bslib::bs_theme(bootswatch = "lux"),
    # theme = bslib::bs_theme(bootswatch = "sandstone"),
    # theme = bslib::bs_theme(bootswatch = "quartz"), # very colourful
    # TRUE to use a dark background and light text for the navigation bar ----
    inverse = TRUE,
    # UI element(s) (htmltools::tags) to display above the nav content ----
    header = NULL,
    # UI element(s) (htmltools::tags) to display below the nav content ----
    footer = ui_footer,
    fluid = TRUE,
    # ---------------------------------------- #
    # APP sidebar
    # ---------------------------------------- #
    sidebar = sidebar(
      title = "Portal information and options",
      id = "page_sidebar",
      style = "display: flex; flex-direction: column; height: 90vh;", # Make sidebar fill vertical space
      open = list(desktop = "open", mobile = "closed"),
      textInput(
        inputId = "main_search_query",
        label = "Enter a topic or technology of interest",
        value = "dementia treatment",
        placeholder = "Enter search here..."
      ),
      actionButton(inputId = "main_search", label = "Search", icon = icon("magnifying-glass")), # Search button
      radioButtons(
        inputId = "main_xp",
        label = "Portal features",
        choices = list(
          "Simplified" = "new",
          "Expert mode" = "xpt"
        ),
        selected = "new"
      ),
      div(style = "flex-grow: 1;"),
      div(
        style = "margin-top: auto;",
        p(includeHTML("www/poweredby_thelens.html"))
      )
    ),
    # ---------------------------------------- #
    # PAGES definitions: landing page
    # ---------------------------------------- #
    nav_panel(
      title = content_home_title,
      id = "panel_landing",
      # ---------------------------------------- #
      # LANDING PAGE: main body of text
      # ---------------------------------------- #
      accordion(
        id = "landing_main_content",
        open = c("landing_main", "landing_join"),
        accordion_panel(
          title = "Get involved",
          value = "landing_join",
                                icon = bsicons::bs_icon("hand-thumbs-up"),
                                includeMarkdown("www/landing_join.md"),
                                layout_columns(
                                                        card(
                                                          card_header("Try the Proof of Concept"),
                                                          actionLink("go_to_result", label = "Try out www.regioninnovation.org Proof of Concept", icon = icon("circle-left"))
                                                        ),
                                                        card(
                                                          card_header("Contact the project to become a partner"),
                                                          mailtoR(email = "regioninnovation@sciencedatanexus.com",
                                                                  text = "Click here to send an email !",
                                                                  subject = "Become a regioninnovation.org partner",
                                                                  body = "I would like to participate in the regioninnovation.org partnership"),
                                                          use_mailtoR()
                                                        ),
                                                        width = 1 / 2
                                                )
                        ),
                        accordion_panel(
          title = "Innovative region",
          value = "landing_main",
          icon = bsicons::bs_icon("universal-access-circle"),
          includeMarkdown("www/landing_main.md")
        ),
        accordion_panel(
          title = "What is the need?",
          value = "landing_need",
          icon = bsicons::bs_icon("signpost-split"),
          includeMarkdown("www/landing_need.md"),
        ),
        accordion_panel(
          title = "Solution",
          value = "landing_solution",
          icon = bsicons::bs_icon("speedometer"),
          includeMarkdown("www/landing_solution.md")
        ),
        accordion_panel(
          title = "A collaborative approach",
          value = "landing_partnership",
          icon = bsicons::bs_icon("people-fill"),
          includeMarkdown("www/landing_partnership.md")
        )
      )
    ),
    # ---------------------------------------- #
    # PAGES definitions: map page
    # ---------------------------------------- #
    nav_panel(
      title = "Search results",
      id = "panel_map",
      # ---------------------------------------- #
      # MAP PAGE: main body of text
      # ---------------------------------------- #
      leafletOutput("rwhichsn1_net", width = "100%", height = "100%") ,
      absolutePanel(id = "poc_warning", p("This is a Proof of Concept with partial data an placeholders."), top = 75, left = 350, width = 300, height = 50, fixed = TRUE, draggable = TRUE),
      absolutePanel(
          id = "main_controls", class = "panel panel-default",
          top = 75, right = 55, width = 200, align = "right", fixed = TRUE,
          draggable = TRUE, height = "auto", class = "panel panel-default",
          span(tags$i(h6("Estimation of the regional research and innovation")), style = "color:#045a8d"),
          h6("Topic", align = "right"),
          tableOutput("cwhatsp1_stats"),
          h6("Location", align = "right"),
          tableOutput("rwhichsn1_org_stats"),
          h6("R&D strength", align = "right"),
          tableOutput("stats_quality")
      )
    ),
    # ---------------------------------------- #
    # PAGES definitions: ABOUT
    # ---------------------------------------- #
    nav_panel(
      title = "About",
      id = "panel_about",
      accordion(
        id = "content_about",
        open = "about_A",
        accordion_panel(
          title = "Last updates",
          value = "about_update",
          icon = bsicons::bs_icon("newspaper"),
          includeMarkdown("www/about_update.md")
        ),
        accordion_panel(
          title = "Background and context",
          value = "about_background",
          icon = bsicons::bs_icon("globe-asia-australia"),
          includeMarkdown("www/about_background.md")
        ),
        accordion_panel(
          title = "Sponsor",
          value = "about_sponsor",
          icon = bsicons::bs_icon("building"),
          includeMarkdown("www/about_sponsor.md")
        ),
        accordion_panel(
          title = "Contributors",
          value = "about_contributor",
          icon = bsicons::bs_icon("people"),
          p("The following contributors have participated in this project:"),
          uiOutput("list_contributors")
        ),
        accordion_panel(
          title = "Code",
          value = "about_code",
          icon = bsicons::bs_icon("file-code"),
          includeMarkdown("www/about_code.md"),
          p(link_github)
        ),
        accordion_panel(
          title = "Terms of use",
          value = "about_license",
          icon = bsicons::bs_icon("signpost"),
          includeMarkdown("license.md"),
          # ADD ANY OTHER DATA SOURCES AS RELEVANT
          includeMarkdown("www/license_thelens.md"),
        )
      )
    ),
    # ---------------------------------------- #
    # PAGES definitions: SECOND MENU
    # ---------------------------------------- #
    nav_spacer(),
    navbarMenu(
      title = "Links",
      align = "right",
      nav_item(link_sdn),
      nav_item(link_github),
      nav_item(link_lens)
    ),
    # switch dark/light mode, mode=NULL for default user preferences ----
    nav_item(input_dark_mode(id = "mode", mode = "light"))
    # bookmarkButton()
  )
)

