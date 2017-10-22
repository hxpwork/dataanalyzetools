library(shiny)
library(datasets)

shinyServer(function(input, output) {
        formatTitle <- reactive({
              switch(
                      input$method,
                      "codebook" = "Code Book",
                      "summary" = "Summary",
                      "nacheck" = "NA Check",
                      "freqtable" = "Frequency Distortion",
                      "boxplot" = "Box Plot"
              )
        })
        
        datasetInput <- reactive({
              switch(
                      input$dataset,
                        "airquality" = airquality,
                        "anscombe" = anscombe,
                        "attenu" = attenu,
                        "attitude" = attitude,
                        "beaver1" = beaver1,
                        "beaver2" = beaver2,
                        "BOD" = BOD,
                        "cars" = cars,
                        "chickwts" = chickwts,
                        "esoph" = esoph,
                        "faithful" = faithful,
                        "Formaldehyde" = Formaldehyde,
                        "Freeny" = freeny,
                        "InsectSprays" = InsectSprays,
                        "iris" = iris,
                        "LifeCycleSavings" = LifeCycleSavings,
                        "longley" = longley,
                        "morley" = morley,
                        "mtcars" = mtcars,
                        "OrchardSprays" = OrchardSprays,
                        "PlantGrowth" = PlantGrowth,
                        "pressure" = pressure,
                        "Puromycin" = Puromycin,
                        "quakes" = quakes,
                        "randu" = randu,
                        "rock" = rock,
                        "sleep" = sleep,
                        "stackloss" = stackloss,
                        "swiss" = swiss,
                        "ToothGrowth" = ToothGrowth,
                        "trees" = trees,
                        "USArrests" = USArrests,
                        "USJudgeRatings" = USJudgeRatings,
                        "warpbreaks" = warpbreaks,
                        "women" = women
                )
        })
        
        output$title <- renderText({
                input$goButton
                isolate(formatTitle())
        })
        
        ####### Code book #######
        
        output$codebook <-
                renderPrint(help(input$dataset, package = "datasets"))
        
        
        ####### Summary #######
        output$summary <- renderPrint({
                input$goButton
                datas <- isolate(datasetInput())
                summary(datas)
        })
        
        # Show the first "n" observations
        output$headview <- renderTable({
                input$goButton
                datas <- isolate(datasetInput())
                num <- isolate(input$obs)
                head(datas, n = num)
        })
        
        ####### Check N  #######
        output$naresult <- renderPrint({
                input$goButton
                NA_Num <- isolate(colSums(is.na(datasetInput())))
                Normal_Num <- isolate(colSums(!is.na(datasetInput())))
                rbind(NA_Num, Normal_Num)
        })
        
        ####### Frequency Distribution
        output$dataColumn1 <- renderUI({
                data_columns <- names(datasetInput())
                selectInput("col1", "Choose a column:", choices = data_columns)
        })
        output$dataColumn2 <- renderUI({
                data_columns <- names(datasetInput())
                selectInput("col2", "Choose a column(optional):", choices = c("\t", data_columns))
        })
        
        output$freqTable <- renderTable({
                if (input$goButton == 0)
                  return()
                usena <- isolate({ if(input$ignoreNA) "no" else "always" })
                col1 <- isolate(input$col1)
                col2 <- isolate(input$col2)
                ncol1 <- nchar(gsub("^\\s+|\\s+$", "", col1)) 
                ncol2 <- nchar(gsub("^\\s+|\\s+$", "", col2))
                if(ncol1>0){
                        if( ncol2 >0 ){
                            table( datasetInput()[[col1]], datasetInput()[[col2]], useNA=usena )
                        }
                        else
                            table(datasetInput()[[col1]], useNA=usena)
                }
                else
                        NULL

        })
        
        output$checkGroup1 <- renderUI({
          checkboxGroupInput("show_cols", "Columns to show:",
                             names(datasetInput()), selected = names(datasetInput()))
        })
        
        output$boxplot <- renderPlot({
          if (input$goButton == 0)
            return()
          dat <- datasetInput()
          boxplot(dat[, input$show_cols, drop = FALSE])
        })
})