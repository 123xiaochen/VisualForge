# Server

shinyServer(function(session, input, output){
  source("module/bgc_data_server.R", local = T)
  source("module/bgc_plot_server.R", local = T)
})
