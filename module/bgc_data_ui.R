
#BGC Data UI

fluidPage(
  style = "margin-left:10px;margin-right:10px;",
  box(
    title = "Data Analysis", width = 4, status = NULL, solidHeader = TRUE,
    selectInput(inputId = "bgc_upload_type", label = "Select Your Data Type", choices = c("JSON", "GBK"), selected = "GBK", multiple = F, width = "100%"),
    conditionalPanel(
      "input.bgc_upload_type == 'JSON'",
      fileInput(inputId = "bgc_upload_json_data", label = "Upload Your JSON Data:", multiple = F, accept = ".json", width = "100%")
    ),
    conditionalPanel(
      "input.bgc_upload_type == 'GBK'",
      fileInput(inputId = "bgc_upload_gbk_data", label = "Upload Your GBK Data:", multiple = T, accept = ".gbk", width = "100%")
    ),
    actionButton("bgc_data_action", "Data Analysis", width = "100%", class = "plot-button")
  ),
  box(
    title = "Data Display", width = 8,
    shinycssloaders::withSpinner(DT::dataTableOutput("BGC_Data_output"))
  )
)
