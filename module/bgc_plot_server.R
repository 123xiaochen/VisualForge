
#BGC Plot Server
output$BGC_Plot_Select_BGC <- renderUI({
  data <- BGC_Data()
  selectInput(
    inputId = "bgc_plot_select_bgc", label = "Select BGC :",
    choices = unique(data$BGC_ID), multiple = T, width = "30%"
  )
})

# BGC_Data <- reactive({
#   if(input$bgc_upload_type == 'JSON'){
#     BGC_Data_Name <- paste0(stringr::str_remove(string = input$bgc_upload_json_data$name, pattern = ".json"), "_BGC_location.csv")
#   }else{
#     BGC_Data_Name <- paste0(stringr::str_remove(string = input$bgc_upload_gbk_data$name[i], pattern = ".gbk"), "_BGC_location.csv")
#   }
#   gtf_data$Strand <- ifelse(gtf_data$Strand=='+', 1,0)
# })


bgc_plot <- eventReactive(input$bgc_plot_action, {
  data <- BGC_Data()
  data <- data[data$BGC_ID==as.numeric(input$bgc_plot_select_bgc), ]
  data$Strand <- ifelse(data$Strand=='+', 1,0)

  ggplot(data, aes(xmin = Start, xmax = End, y = BGC_ID, fill = Function, forward = Strand)) +
    geom_gene_arrow(arrowhead_height = unit(8, "mm"), arrowhead_width = unit(2, "mm"), arrow_body_height = unit(8, "mm")) +
    #geom_text(aes(x = (Start + End) / 2-500, label = BGC_ID), vjust = 0, hjust=0, size = 2.5, color = "black") +  # 添加基因名
    # geom_text_repel(aes(x = (Start + End) / 2, label = ID), direction = "x", box.padding = 0.3,
    #                 size = 3, color = "black", position = position_dodge(width = 0.5)) +  # 使用geom_text_repel替代geom_text
    facet_wrap(~ BGC_ID, scales = "free", ncol = 1) +
    scale_fill_manual(values = c("biosynthetic" = "#990000", "biosynthetic-additional" = "#FF6666", "transport" = "#0080FF",
                                 "regulatory" = "#009900", "other" = "#A0A0A0")) +

    theme_genes()+
    theme(legend.position = "bottom",
          axis.title = element_text(size = 20),
          axis.text = element_text(size = 15),
          legend.title = element_text(size = 18),
          legend.text = element_text(size = 12))+
    labs(x = "Location", y = "BGC")
})

output$BGC_plot <- renderPlot({
  return(bgc_plot())
})

output$bgc_plotUI <- renderUI({
  shinycssloaders::withSpinner(plotOutput("BGC_plot", width = paste0(input$bgc_plot_width, "%"), height = paste0(input$bgc_plot_height, "px")))
})
