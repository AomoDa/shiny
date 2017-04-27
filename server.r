data = read.csv("data/view(1).csv")
source("helper.txt")
shinyServer(function(input, output) {
  
  output$tb <-  renderTable({   
    data[1:50,]
    })
 

  output$xx <- renderPlot({
    plot(1:19)
  })
  aa <- 19
  output$xxx <- renderPlot({
    y <- as.numeric(input$a)
    plot(1:y)
  })
  
  output$cd <-  renderTable({   

  })
  
  output$desc <-  renderTable({  
     set.seed(nchar(as.character(input$tt)))
     a = unique(data$beer_style)
     data.frame(Recommend = a[sample(1:length(a), sample(3:10,1))])
  })
  
})
