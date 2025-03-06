# ---------------------------------- #
# Libraries
# ---------------------------------- #
# For Deployment
library(shiny)
library(shinycssloaders)
library(shinyjs)
library(bslib)
library(bsicons)
library(thematic)
library(markdown)
library(countrycode)
library(leaflet) # maps
library(sf) # spatial data
library(DT)
library(igraph) # network visualisation
library(visNetwork) # network visualisation
library(jsonlite)
library(htmltools)
library(knitr)
library(mailtoR) # to send email from shiny
# For analytics
library(yaml)
library(ggplot2)
library(tidyverse)
library(duckdb)
library(duckplyr)
library(hrbrthemes)
library(ggalluvial) #Sankey plot
library(viridis)
# ---------------------------------- #
# Analytics variables
# ---------------------------------- #
# Global variables
project_variables <- read_yaml("config/project_variables.yaml")
project_search_strategy <- read_yaml("config/search_strategy.yaml")
# Development/sandbox variables
if (project_variables$project_dev == TRUE) {
        lib_directory_result <- file.path(project_variables$dev_lib_dir, "nexus", paste0("pipeline_", project_variables$dev_result_pipeline_version), "output")
} else {
        lib_directory_result <- file.path(project_variables$lib_dir, paste0("pipeline_", project_variables$project_result_pipeline_version), "output")
}
# Specify the file paths
main_directory <- project_variables$lib_directory_result
result_directory <- project_variables$result_directory
data_directory <- file.path(project_variables$data_directory, "project_2024_11")
baseline_directory <- file.path(project_variables$data_directory, project_variables$baseline_version)
configfile <- project_variables$configfile
data_file <- file.path(data_directory, "project_data.duckdb")
# other global variables
project_start_year <- project_variables$project_start_year
project_end_year <- project_variables$project_end_year
project_contributors <- project_variables$project_contributors

# ---------------------------------- #
# Rendering variables
# ---------------------------------- #
# Links variables
link_sdn <- tags$a(shiny::icon("house"), "Science Data Nexus", href = "https://www.sciencedatanexus.com", target = "_blank")
link_github <- tags$a(shiny::icon("github"), "Github", href = paste0("https://github.com/sciencedatanexus/", project_variables$project_name), target = "_blank")
link_lens <- tags$a(shiny::icon("database"), "The Lens", href = "https://www.lens.org/", target = "_blank")
link_openalex <- tags$a(shiny::icon("database"), "OpenAlex", href = "https://openalex.org/", target = "_blank")

# header, footer variables
ui_header <- tags$header(strong("Header"), align = "center")
ui_footer <- tags$footer(includeMarkdown("license.md"), align = "right")

# Title elements
content_page_title <- "Innovative Region"
content_home_title <- "Central Victoria"

# UI variables
ui_font_size <- 14
