
library(shiny)
library(shinythemes) 


shinyUI(navbarPage( theme = shinytheme("cosmo"),
                    
                    "Doudou Zhang",
                    
                    tabPanel("Residential Fires",  
                             sidebarLayout( 
                               sidebarPanel( 
                                 selectInput(inputId = "year1",
                                             label = "Year",
                                             choices =2006:2015,
                                             selected = 2015),
                                 submitButton("Run")
                               ),
                               mainPanel( 
                                 
                                 tabsetPanel( 
                                   tabPanel("Fire Deaths", 
                                            plotOutput("map1")),
                                   tabPanel("Fire Frequency", 
                                            plotOutput("map2")),
                                   tabPanel("Property Loss", 
                                            plotOutput("map3")),
                                   tabPanel("Contents Loss", 
                                            plotOutput("map4")))
                               )
                             ),
                             
                             sidebarLayout( 
                               sidebarPanel( 
                                 selectInput(inputId = "year2",
                                             label = "Year",
                                             choices =2006:2015,
                                             selected = 2015),
                                 selectInput(inputId = "position",
                                             label = "BarPlot Type",
                                             choices =c('dodge','fill','stack'),
                                             selected = 'stack'),
                                 submitButton("Run")
                               ),
                               mainPanel( 
                                 
                                 tabsetPanel( 
                                   tabPanel("BarPlot", 
                                            plotOutput("bar")),
                                   tabPanel("BarTbale", 
                                            tableOutput('bar_table'))
                                 )
                               )
                             )     
                    ),
                    
                    
                    
                    tabPanel("Time series analysis",  
                             sidebarLayout( 
                               sidebarPanel( 
                                 selectInput(inputId = "state1",
                                             label = "State",
                                             choices =  state.abb,
                                             selected = c('PA','AK','CA'),
                                             multiple=TRUE),
                                 selectInput(inputId = "ts_v",
                                             label = "Value: ",
                                             choices =  c('DEATH','CNT',
                                                          'PROP_LOSS','CONT_LOSS'),
                                             selected = 'CNT'
                                             ),
                                 submitButton("Run")
                               ),                                   
                               mainPanel(
                                 plotOutput('tt')
                               )               
                             ),
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
                                             choices = 2:12,
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
                             
                             
                             
                    ),
                    
                    
                    tabPanel("Deaths Demographic",  
                             sidebarLayout( 
                               sidebarPanel( 
                                 selectInput(inputId = "year3",
                                             label = "Year : ",
                                             choices =  c(2006:2010,2012:2015),
                                             selected = 2015),
                                 selectInput(inputId = "plot_type",
                                             label = "Plot Type : ",
                                             choices = c('Pie','Barplot'),
                                             selected = 'Pie'),
                                 submitButton("Run")
                               ),                                   
                               mainPanel( 
                                 plotOutput("pie_gender"),
                                 plotOutput("pie_age")
                               )               
                             )
                             
                    )
                    
                    
))
