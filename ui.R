# UI
# insert R packages
library(shiny)
library(plotly)
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)
library(dplyr)
library(DT)
library(gggenes)
library(ggplot2)

#
shinyUI(
  fluidPage(
    style = "width:100%; padding: 0px",
    #useShinydashboard(),
    #useShinyjs(),
    #extendShinyjs(text = jsCode, functions = "collapse"),
    tags$head(HTML("<title>VisualForge</title>")),
    navbarPage(
      id = "mainMenu",
      title = "VisualForge",
      theme = "style/style.css",
      fluid = TRUE,
      collapsible = TRUE,

      tabPanel(title = "Home", value = "home", icon = icon("home")
      ),
      navbarMenu(
        title = "Bar Plot"

      ),
      navbarMenu(
        title = "Line Plot"
      ),
      navbarMenu(
        title = "Box Plot"
      ),
      navbarMenu(
        title = "BGC Plot",
        tabPanel(title = "Extral Data", value = "bgc_data", source("module/bgc_data_ui.R")$value),
        tabPanel(title = "Make Plot", value = "bgc_plot", source("module/bgc_plot_ui.R")$value)
        ),
      tabPanel(
        title = "About"
      )
    )
  )
)
