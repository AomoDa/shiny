library(shiny)
library(shinythemes) 
shinyUI(navbarPage( theme = shinytheme("flatly"),
                    
                    "Recommend",
                    
                    tabPanel("User-Item",  
                             sidebarLayout( 
                               sidebarPanel( 
                               
       textInput("tt", label = h3("Items"), 
                value = ""),  
                                 submitButton(h3("Query"))
                               ),                                   
                               
                               mainPanel( 
                                 tabsetPanel( 
                                   tabPanel("Recommend", tableOutput("desc")),
                                   tabPanel("Rawdata", tableOutput("tb"))
                               )
                             )               
                             
                             
                    )),
       
       tabPanel("xxx",  
                sidebarLayout( 
                  sidebarPanel( 
                    sidebarPanel("sidebar panel",
                  sliderInput("a", label = '',
                        min = 0, max = 100, value = 50,width='1000px'),
                  selectInput(inputId = "n_breaks",
                              label = "Number of bins in histogram (approximate):",
                              choices = c(10, 20, 35, 50),
                              selected = 20),
                  submitButton("Query")              
                                  ),
                    mainPanel("main panel")
                  ),                                   
                  
                  mainPanel( 
                    
                    plotOutput("xxx")

                  )               
                ) ,
                sidebarLayout( 
                  sidebarPanel( 
                    sidebarPanel( "sidebar panel"),
                    mainPanel("main panel")
                  ),                                   
                  
                  mainPanel( 
                    

                    
                  )               
                ))            
                    
                    
                    
))
