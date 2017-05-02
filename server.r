library(ggplot2)
library(maps)
library(plyr)
library(forecast)
library(reshape)
data_ts_sum <- read.csv('./data/data_ts_sum.csv',
                        stringsAsFactors = F)
data_fire_sum <- read.csv('./data/data_fire_sum.csv',
                          stringsAsFactors = F)
states_map <- map_data("state")

data_fire_type <- read.csv('./data/data_fire_type.csv',
                           stringsAsFactors = F)
data_death_detial <- read.csv('./data/data_death_detial.csv',
                              stringsAsFactors = F)

data_death_detial$GENDER <- as.factor(data_death_detial$GENDER)
data_death_detial$AGE_TYPE <- cut(data_death_detial$AGE,
                                  breaks = c(min(data_death_detial$AGE,na.rm = T),
                                             18,40,65,
                                             max(data_death_detial$AGE,na.rm = T)))
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
    ggplot(data_fire_sum[data_fire_sum$YEAR==input$year1,], aes(map_id = STATE_NAME)) +
      geom_map(aes(fill = DEATH), map = states_map,col=I('white')) +
      expand_limits(x = states_map$long, y = states_map$lat)+
      coord_map()+
      scale_fill_distiller(palette = "YlOrRd",direction =1)+
      theme(panel.background = element_blank())+
      labs(x='',y='',title='Fire Deaths')+
      scale_x_discrete(breaks=NULL)+
      scale_y_discrete(breaks=NULL)+
      geom_text(aes(x=log,y=lat,label=STATE,size=DEATH),col=gray(0.3),
                check_overlap=TRUE,show.legend = FALSE,na.rm = T)
    
  })
  
  output$map2 <-  renderPlot({  
    ggplot(data_fire_sum[data_fire_sum$YEAR==input$year1,], aes(map_id = STATE_NAME)) +
      geom_map(aes(fill = CNT), map = states_map,col=I('white')) +
      expand_limits(x = states_map$long, y = states_map$lat)+
      coord_map()+
      scale_fill_distiller(palette = "YlGnBu",direction =1)+
      theme(panel.background = element_blank())+
      labs(x='',y='',title='Fire Frequency')+
      scale_x_discrete(breaks=NULL)+
      scale_y_discrete(breaks=NULL)+
      geom_text(aes(x=log,y=lat,label=STATE,size=CNT),col=gray(0.2),
                check_overlap=TRUE,show.legend = FALSE,na.rm = T)
  })
  
  output$map3 <-  renderPlot({  
    ggplot(data_fire_sum[data_fire_sum$YEAR==input$year1,], aes(map_id = STATE_NAME)) +
      geom_map(aes(fill = PROP_LOSS), map = states_map,col=I('white')) +
      expand_limits(x = states_map$long, y = states_map$lat)+
      coord_map()+
      scale_fill_distiller(palette = "Reds",direction =1)+
      theme(panel.background = element_blank())+
      labs(x='',y='',title='Property Loss Million Dollar')+
      scale_x_discrete(breaks=NULL)+
      scale_y_discrete(breaks=NULL)+
      geom_text(aes(x=log,y=lat,label=STATE,size=PROP_LOSS),col=gray(0.3),
                check_overlap=TRUE,show.legend = FALSE,na.rm = T)
  })
  output$map4 <-  renderPlot({  
    ggplot(data_fire_sum[data_fire_sum$YEAR==input$year1,], aes(map_id = STATE_NAME)) +
      geom_map(aes(fill = CONT_LOSS), map = states_map,col=I('white')) +
      expand_limits(x = states_map$long, y = states_map$lat)+
      coord_map()+
      scale_fill_distiller(palette = "Reds",direction =1)+
      theme(panel.background = element_blank()) + 
      labs(x='',y='',title='Contents Loss Million Dollar')+
      scale_x_discrete(breaks=NULL)+
      scale_y_discrete(breaks=NULL)+
      geom_text(aes(x=log,y=lat,label=STATE,size=CONT_LOSS),col=gray(0.3),
                check_overlap=TRUE,show.legend = FALSE,na.rm = T)
    
  })
  
  output$bar <-  renderPlot({  
    bar_title <- paste0('Residential Fires Type Count In Year ',
                        input$year2)
    ggplot(data = data_fire_type[data_fire_type$year==input$year2,],
           aes(x=as.factor(mon),
               weights=CNT,
               fill=type))+geom_bar(position = input$position)+
      theme(panel.background = element_blank()) +theme_bw()+
      labs(x='',
           y='',
           title=bar_title)+
      theme(axis.text.x=element_text(face="bold",
                                     angle=0,
                                     color="black")
      )
    
  }) 
  output$bar_table <-  renderTable({
    bar_table <- cast(data = data_fire_type[data_fire_type$year==input$year2,],
                      mon~type,
                      fun.aggregate = sum,
                      value='CNT')
    bar_table$YEAR=input$year2
    bar_table[,c(ncol(bar_table),1:(ncol(bar_table)-1))]
  },rownames=FALSE,colnames = TRUE)
  
  output$pie_gender <-  renderPlot({ 
    ggplot(data=data_death_detial[data_death_detial$year==input$year3,],
           aes(x=factor(1),fill=GENDER))+
      geom_bar(width=1,position = 'fill')+
      coord_polar(theta = "y")+
      theme(panel.background = element_blank())+
      labs(x='',y='',title='Gender')
  })
  
  output$pie_age <-  renderPlot({ 
    if(input$plot_type=='Pie'){
      ggplot(data=data_death_detial[data_death_detial$year==input$year3,],
             aes(x=factor(1),fill=AGE_TYPE))+
        geom_bar(width=1,position = 'fill')+
        coord_polar(theta = "y")+
        theme(panel.background = element_blank())+
        labs(x='',y='',title='Age')+ 
        theme(legend.position = "bottom")} else{
          ggplot(data=data_death_detial[data_death_detial$year==input$year3,],
                 aes(x=AGE_TYPE,fill=AGE_TYPE))+
            geom_bar(width=1,position = 'dodge')+
            theme(panel.background = element_blank())+
            labs(x='',y='',title='Age')+ 
            theme(legend.position = "bottom")
        }
    
  })
  
  output$tt <-  renderPlot({
    mydf <- data_ts_sum[data_ts_sum$STATE %in% input$state1,
                        c('MONTHS','STATE',input$ts_v)]
    
    ggplot(data=mydf,
           aes(x=as.Date(MONTHS),y=mydf[,3] ,col=STATE))+
      geom_point()+
      geom_line()+theme(panel.background = element_blank())+
      theme_bw()+
      labs(x='',y='',title='Time Series')+ 
      theme(legend.position = "bottom")+scale_colour_brewer(palette = "Set1")
    
  })
  
  
})
