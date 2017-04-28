library(shiny)
library(shinythemes) 


shinyUI(navbarPage( theme = shinytheme("flatly"),
                    
                    "Final Project",
                    
                    tabPanel("My Test",  
                             sidebarLayout( 
                               sidebarPanel( 
                                 selectInput(inputId = "year",
                                             label = "Year",
                                             choices =2006:2015,
                                             selected = 'ALL'),
                                 submitButton("Run")
                               ),
                               mainPanel( 
                                 plotOutput("map1"),
                                 plotOutput("map2"),
                                 plotOutput("map3"),
                                 plotOutput("map4")
                                 
                             )               
                             
                             
                    )),
       
       tabPanel("Time series analysis",  
                sidebarLayout( 
                  sidebarPanel( 
                  selectInput(inputId = "state",
                              label = "Prediction State",
                              choices =  c('ALL',state.abb),
                              selected = 'ALL'),
                  selectInput(inputId = "pred_value",
                              label = "Prediction Content",
                              choices =  c('DEATH','CNT','PROP_LOSS','CONT_LOSS'),
                              selected = 'DEATH'),
                  selectInput(inputId = "pred_h",
                              label = "Prediction Months",
                              choices = 1:12,
                              selected = 6),
                  submitButton("Run")
                  ),                                   
                  mainPanel( 
                    plotOutput("xxx"),
                    tabsetPanel( 
                    tabPanel("Predict Data With 95% Confidence Interval", 
                             tableOutput("pred_table")))
                  )               
                )
                
                )))
