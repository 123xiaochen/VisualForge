
# BGC Plot UI

fluidPage(
  style = "margin-left:10px;margin-right:10px;",
  box(
    title = "Plot Parament Set:", width = 9,
    uiOutput("BGC_Plot_Select_BGC"),
    actionButton("bgc_plot_action","Make Plot", width = "30%", style = "background-color: #76a5af; border-radius: 28px;"),
  ),
  box(
    title = "Set Plot Size:", width = 3,
    sliderInput("bgc_plot_width", "Figure Width (%):", min = 50, max = 100, value = 100, step = 2, width = "100%"),
    sliderInput("bgc_plot_height", "Figure Height (px):", min = 200, max = 1500, value = 600, step = 2, width = "100%")
  ),
  box(
    title = "Plot Display:", width = 12,
    div(
      shinycssloaders::withSpinner(uiOutput("bgc_plotUI"))
    )
  )
)
