

startVisualForge <- function(launch.browser = TRUE, host = "0.0.0.0", port = 8888){
  options(shiny.maxRequestSize = 1000 * 1024^2, warn = -1, shiny.sanitize.errors = TRUE)
  shinyApp(ui = VisualForge_ui, server = VisualForge_server) %>% runApp(launch.browser = launch.browser, host = host, port = port)
}
