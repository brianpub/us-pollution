#-------------------------------------------------------------------
# Brian Publik
# Pollution data aggregation of monthly data
#-------------------------------------------------------------------


library(lubridate)

#cwd <- getwd()
#setwd("C:/Users/publikb/Documents/analytics/datasets/pollution")

#Function to convert AQI into levels
aqi_factor <- function(x){
  
  if(x > 200 ){
    return(5)
  }
  if(x > 150 & x < 200 ){
    return(4)
  }
  if(x > 100 & x< 150 ){
    return(3)
  }
  if(x > 50 & x < 100 ){
    return(2)
  }
  if(x < 50  ){
    return(1)
  }
  return(1)
}

clist <- c("44201", "42401", "42101", "42602")
#clist <- c("44201")
year_list <- c(2000:2018)

fun_value <- 1

data_all <- NULL

for( cat in clist ){
  
  data_all <- NULL
  
  for( y in year_list ){
    
    data1 <- NULL
    
    file_in <- paste("daily_", cat, "_", y, ".csv" , sep = "" )
    #file_in <- "daily_44201_2000.csv"
    
    print(c("Processing data ", file_in))
    
    data_in <- read.csv(file_in)
    
    #remove unused columns
    data1 <- data_in[, -c(4,5,6,7,8,9,10,11,13,14,15,16,21,22,23,24,29)]
    
    #remove data without AQI, just a duplicate different standard measurement at the same site
    complete_rows <- complete.cases(data1[, "AQI"])
    data1 <- data1[complete_rows, ]
    
    #match up state codes wiht state names for data irregularity
    sites <- read.csv("aqs_sites.csv")
    site_codes <- sites[,c("State.Code","State.Name")]
    site_codes <- unique(site_codes)
    
    #merge state codes from the table
    data1 <- merge(data1, site_codes, by.x=c("State.Name"), by.y=c("State.Name"), all.x=TRUE)
    nrow(data1)
    
    data1 <- data1[,-c(2)]
    
    #format date factor into date type
    data1$Date.Local <- as.Date(data1$Date.Local, format = "%Y-%m-%d")
    
    #--------------- ROLL UP INTO MONTH AND AGGREGATE --------------------
    #use lubridate to change all daily values into a month value
    data1$DateMonth <- floor_date(data1$Date.Local, "month")
  
    
    #aggregate data based on month and take the average
  
    #remove unimportant columns ?
    data1 <- data1[,-c(1,4,9:11)]
    
    data1$State.Code.y <- as.character(data1$State.Code.y)

    #Aggregate based on MAX values
    data2 <- aggregate(data1,  by=list(data1$DateMonth, data1$State.Code.y, data1$County.Code, data1$Site.Num), max)
    data2 <- data2[,-c(1:4)]  
    
    #Aggregate based on MEAN values
    data1 <- aggregate(data1,  by=list(data1$DateMonth, data1$State.Code.y, data1$County.Code, data1$Site.Num), mean)
    data1 <- data1[,-c(1,3,4,11)]
    colnames(data1)[1] <- "State.Code"
    
    #Merge data
    data1 <- merge(data1, data2, by.x=c("State.Code", "County.Code", "Site.Num", "DateMonth"), by.y =c("State.Code.y", "County.Code", "Site.Num", "DateMonth"))
      
    colnames(data1)[5] <- "Mean"
    colnames(data1)[6] <- "MaxValue"
    colnames(data1)[7] <- "MaxHour"
    colnames(data1)[8] <- "AQI"
    colnames(data1)[9] <- "MeanMax"
    colnames(data1)[10] <- "MaxValueMax"
    colnames(data1)[11] <- "MaxHourMax"
    colnames(data1)[12] <- "AQIMax"
    
    
    #-------------- Monitor sites data -----------------
    sites1 <- sites[,-c( 6,10:21,27,28 )]

    #merge site monitoring data
    data1 <- merge(data1, sites1, by.x=c("State.Code", "County.Code", "Site.Num"), by.y=c("State.Code", "County.Code", "Site.Number"), all.x=TRUE)
 
    
    data1$aqi_level <- ""
    
    #apply too slow, convert to vector and vapply
    #apply( data_in, 1, aqi_factor)
    
    af <- as.vector(data1$AQI)
    apif <- vapply( af,  aqi_factor, FUN.VALUE = numeric(1))
    data1$aqi_level <- apif
    
    af <- as.vector(data1$AQIMax)
    apif <- vapply( af,  aqi_factor, FUN.VALUE = numeric(1))
    data1$aqi_level_max <- apif
   
    #Combine all data
    data_all <- rbind(data_all, data1)
    
    print(c("Dataset Rows ", nrow(data_all)))
    
  }

    write.csv(data_all, file = paste(cat, "_city_monthly_all.csv", sep=""))
 
  
}

print("Done aggregating data")




