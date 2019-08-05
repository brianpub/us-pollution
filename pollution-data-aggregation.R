#-------------------------------------------------------------------
# Brian Publik
# Pollution data aggregation of daily data
#-------------------------------------------------------------------

#cwd <- getwd()
#setwd("C:/Users/publikb/Documents/analytics/datasets/pollution")

#42101 CO
#44201 Oz
#42401 So2
#42602 N02

#--- data reporting is done on multiple standards
#--- some data does not have AQI generated for the standard instead it uses the most current standard

#--- 42401 SO 1 hour standard , SO2 3-hour 1971 dropped
#--- 42101 CO CO 8-hour 1971, CO 1-hour 1971 dropped
#--- 42602 NO NO2 1-hour only
#--- 44201 OZ doesnt have data from nov and dec on some sites

clist <- c("44201", "42401", "42101", "42602")
#clist <- c("44201")
year_list <- c(2000:2018)

data_all <- NULL

for( cat in clist ){
  
  data_all <- NULL
  
  for( y in year_list ){
    
    data1 <- NULL
    
    file_in <- paste("daily_", cat, "_", y, ".csv" , sep = "" )
    
    print(c("Processing data ", file_in))
    
    data1 <- read.csv(file_in)
    
    #remove unused columns
    data1 <- data1[, -c(4,5,6,7,8,9,10,11,13,14,15,16,21,22,23,24,29)]
    
    #remove data without AQI, just a duplicate different standard measurement at the same site
    complete_rows <- complete.cases(data1[, "AQI"])
    data1 <- data1[complete_rows, ]
    
    #format date factor into date type
    data1$Date.Local <- as.Date(data1$Date.Local, format = "%Y-%m-%d")
    
    colnames(data1) <- c( "StateCode", "CountyCode", "SiteNumber", "Date", "DataMean", "DataMaxValue", "DataMaxHour", "DataAQI", "State", "County", "City", "CBSA")
    
    data_all <- rbind(data_all, data1)
    
    print(c("Dataset Rows ", nrow(data_all)))
    
  }
  
    write.csv(data_all, file = paste(cat, "_city_daily_all.csv", sep=""))
 
}

print("Done aggregating data")