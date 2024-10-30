
#BGC Data Server
BGC_Data <- eventReactive(input$bgc_data_action, {
  if(input$bgc_upload_type == 'JSON'){
    rep(input$bgc_upload_json_data)
    print(input$bgc_upload_json_data)
    #file.copy(input$bgc_upload_json_data$datapath, input$bgc_upload_json_data$name)
    print(input$bgc_upload_json_data$name)
    BGC_Data_Name <- paste0(stringr::str_remove(string = input$bgc_upload_json_data$name, pattern = ".json"), "_BGC_location.csv")
    print(BGC_Data_Name)
    system(paste('"/Users/lab_wang/miniconda3/envs/antismash7.0/bin/python"' ," www/Software/Antismash_JSON_to_Gene_location.py " , input$bgc_upload_json_data$datapath , BGC_Data_Name))
    data <- read.csv(file = BGC_Data_Name, header = T, sep = ",")
  }else {
    rep(input$bgc_upload_gbk_data)
    All_df=data.frame()
    All_df <- lapply(1:nrow(input$bgc_upload_gbk_data),function(i){
      BGC_Data_Name <- paste0(stringr::str_remove(string = input$bgc_upload_gbk_data$name[i], pattern = ".gbk"), "_BGC_location.csv")
      print(BGC_Data_Name)
      print(input$bgc_upload_gbk_data$datapath[i])
      system(paste('"/Users/lab_wang/miniconda3/envs/antismash7.0/bin/python"' ," www/Software/Antismash_GBK_to_Gene_location.py " , input$bgc_upload_gbk_data$datapath[i] , BGC_Data_Name))
      df <- read.csv(file = BGC_Data_Name, header = T, sep = ",")
    }) %>% bind_rows()
    All_df
  }
})

output$BGC_Data_output <- DT::renderDataTable({
  BGC_Data <- BGC_Data()
  if (is.null(BGC_Data)){
    print("No data available. Please check your input ! ")
    BGC_Data <- data.frame()
  }
  datatable(BGC_Data, escape = F, rownames = T, options = list(scrollX = TRUE, pageLength = 5))
})
