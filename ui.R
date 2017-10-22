library(shiny)

dts <- c("airquality", "anscombe", "attenu", "attitude",
         "beaver1", "beaver2", "BOD",
         "cars", "chickwts",
         "esoph",
         "faithful", "Formaldehyde", "Freeny",
         "InsectSprays", "iris", 
         "LifeCycleSavings", "longley",
         "morley", "mtcars",
         "OrchardSprays",
         "PlantGrowth", "pressure", "Puromycin",
         "quakes",
         "randu", "rock",
         "sleep", "stackloss", "swiss",
         "ToothGrowth", "trees",
         "USArrests", "USJudgeRatings",
         "warpbreaks", "women"
         )

methods <- list(#"Code Book" = "codebook", 
             "Summary" = "summary",
             "NA Check" = "nacheck",
             "Frequency Distortion" = "freqtable",
             "Box Plot" = "boxplot")

shinyUI(pageWithSidebar(

  headerPanel("Data Analyze Tools"),
  
  sidebarPanel(
    selectInput("dataset", "Choose a dataset:", choices = dts),
    selectInput("method", "Analysis Method:", methods),
    conditionalPanel(
        condition = "input.method=='summary'",
        numericInput("obs", "Number of observations to view:", 5)
    ),
    conditionalPanel(
        condition="input.method=='freqtable'",
        uiOutput("dataColumn1"),
        uiOutput("dataColumn2"),
        checkboxInput("ignoreNA", "Ignore NA value", FALSE)
    ),
    conditionalPanel(
        condition="input.method=='boxplot'",
        uiOutput("checkGroup1")
    ),
    actionButton("goButton", "Go!")
  ),
  
  mainPanel(
    h4(textOutput("title")),
    
    conditionalPanel(
        condition = "input.method=='codebook'",
        verbatimTextOutput("codebook")
    ),
    
    conditionalPanel(
        condition = "input.method=='summary'",
        verbatimTextOutput("summary"),
        tableOutput("headview")
    ),
    
    conditionalPanel(
        condition="input.method=='nacheck'",
        verbatimTextOutput("naresult")
    ),

    conditionalPanel(
        condition="input.method=='freqtable'",
        tableOutput("freqTable")
    ),
    
    conditionalPanel(
        condition="input.method=='boxplot'",
        plotOutput("boxplot", click = "plot_click")
    )
  )

))
