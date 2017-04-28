library(ggplot2)
library(maps)
library(plyr)
library(forecast)
data_ts_sum <- read.csv('./data//data_ts_sum.csv',
                        stringsAsFactors = F)
data_fire_sum <- read.csv('./data//data_fire_sum.csv',
                          stringsAsFactors = F)
states_map <- map_data("state")
shinyServer(function(input, output) {
  
  output$tb <-  renderTable({   
    data[1:50,]
    })
 

  output$xxx <- renderPlot({
    set.seed(2017)
    data_ts_sum_plot <- subset(data_ts_sum,
                               subset = STATE==input$state,
                               select = c('MONTHS',input$pred_value))
    
    min_date <- min(data_ts_sum_plot$MONTHS)
    myts <- ts(data_ts_sum_plot[,2],frequency = 12,
               start=c(as.numeric(substr(min_date,1,4)),as.numeric(substr(min_date,6,7))))
    
    myts.pred <- hw(myts,
                    h = as.numeric(input$pred_h),
                    level = 0.95)
    
    pred_table <- cbind(Pred=round(myts.pred$mean,2),
                        Low=round(myts.pred$lower,2),
                        Upp=round(myts.pred$upper,2))
    
    title=paste('Predict',tolower(input$pred_value),
                'in Future',input$pred_h,'Month(s)',
                'On',input$state,'Area',sep=' ')
    autoplot(myts.pred)+
      theme(panel.background = element_blank()) + theme_bw()+
      labs(x='',y='',title=title)
  
    
  })
  
  
  output$pred_table <-  renderTable({  
    
    set.seed(2017)
    data_ts_sum_plot <- subset(data_ts_sum,
                               subset = STATE==input$state,
                               select = c('MONTHS',input$pred_value))
    
    min_date <- min(data_ts_sum_plot$MONTHS)
    myts <- ts(data_ts_sum_plot[,2],frequency = 12,
               start=c(as.numeric(substr(min_date,1,4)),as.numeric(substr(min_date,6,7))))
    
    myts.pred <- hw(myts,
                    h = as.numeric(input$pred_h),
                    level = 0.95)
    
    pred_table <- cbind(
      State=input$state,
      Pred_What=input$pred_value,
      Pred=round(ifelse(myts.pred$mean<0,0,myts.pred$mean),2),
      Low=round(ifelse(myts.pred$lower<0,0,myts.pred$lower),2),
      Upp=round(ifelse(myts.pred$upper<0,0,myts.pred$upper),2))
    
    pred_table
  },rownames=TRUE)
  
  
  output$map1 <-  renderPlot({  
    ggplot(data_fire_sum, aes(map_id = STATE_NAME)) +
      geom_map(aes(fill = DEATH), map = states_map,col=I('white')) +
      expand_limits(x = states_map$long, y = states_map$lat)+
      coord_map()+
      scale_fill_distiller(palette = "YlOrRd",direction =1)+
      theme(panel.background = element_blank())+
      labs(x='',y='',title='Property Loss Million Dollar')+
      scale_x_discrete(breaks=NULL)+
      scale_y_discrete(breaks=NULL)+
      geom_text(aes(x=log,y=lat,label=STATE,size=DEATH),col=gray(0.3),
                check_overlap=TRUE,show.legend = FALSE)
    
  })
  
  output$map2 <-  renderPlot({  
    ggplot(data_fire_sum, aes(map_id = STATE_NAME)) +
      geom_map(aes(fill = CNT), map = states_map,col=I('white')) +
      expand_limits(x = states_map$long, y = states_map$lat)+
      coord_map()+
      scale_fill_distiller(palette = "YlGnBu",direction =1)+
      theme(panel.background = element_blank())+
      labs(x='',y='',title='Property Loss Million Dollar')+
      scale_x_discrete(breaks=NULL)+
      scale_y_discrete(breaks=NULL)+
      geom_text(aes(x=log,y=lat,label=STATE,size=CNT),col=gray(0.2),
                check_overlap=TRUE,show.legend = FALSE)
  })
  
  output$map3 <-  renderPlot({  
    ggplot(data_fire_sum, aes(map_id = STATE_NAME)) +
      geom_map(aes(fill = PROP_LOSS), map = states_map,col=I('white')) +
      expand_limits(x = states_map$long, y = states_map$lat)+
      coord_map()+
      scale_fill_distiller(palette = "Reds",direction =1)+
      theme(panel.background = element_blank())+
      labs(x='',y='',title='Property Loss Million Dollar')+
      scale_x_discrete(breaks=NULL)+
      scale_y_discrete(breaks=NULL)+
      geom_text(aes(x=log,y=lat,label=STATE,size=PROP_LOSS),col=gray(0.3),
                check_overlap=TRUE,show.legend = FALSE)
  })
  output$map4 <-  renderPlot({  
    ggplot(data_fire_sum, aes(map_id = STATE_NAME)) +
      geom_map(aes(fill = CONT_LOSS), map = states_map,col=I('white')) +
      expand_limits(x = states_map$long, y = states_map$lat)+
      coord_map()+
      scale_fill_distiller(palette = "Reds",direction =1)+
      theme(panel.background = element_blank()) + 
      labs(x='',y='',title='Contents Loss Million Dollar')+
      scale_x_discrete(breaks=NULL)+
      scale_y_discrete(breaks=NULL)+
      geom_text(aes(x=log,y=lat,label=STATE,size=CONT_LOSS),col=gray(0.3),
                check_overlap=TRUE,show.legend = FALSE)
    
  })
  
})
