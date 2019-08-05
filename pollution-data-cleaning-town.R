#-------------------------------------------------------------------
# Brian Publik
# Data cleaning for cities
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
#--- 44201 OZ doesnt have data from nov

#------------ load and rename columns --------------

data_in <- read.csv("44201_city_daily_all.csv")

format(object.size(data_in), standard="SI", units="MB")

colnames(data_in)[6] <- "Ozone_DataMean"
colnames(data_in)[7] <- "Ozone_DataMax"
colnames(data_in)[8] <- "Ozone_DataMaxHour"
colnames(data_in)[9] <- "Ozone_DataAQI"

data_in2 <- read.csv("42101_city_daily_all.csv")
format(object.size(data_in2), standard="SI", units="MB")


colnames(data_in2)[6] <- "CO_DataMean"
colnames(data_in2)[7] <- "CO_DataMax"
colnames(data_in2)[8] <- "CO_DataMaxHour"
colnames(data_in2)[9] <- "CO_DataAQI"

data_in3 <- read.csv("42401_city_daily_all.csv")
format(object.size(data_in3), standard="SI", units="MB")


colnames(data_in3)[6] <- "SO_DataMean"
colnames(data_in3)[7] <- "SO_DataMax"
colnames(data_in3)[8] <- "SO_DataMaxHour"
colnames(data_in3)[9] <- "SO_DataAQI"

data_in4 <- read.csv("42602_city_daily_all.csv")
format(object.size(data_in4), standard="SI", units="MB")


colnames(data_in4)[6] <- "NO_DataMean"
colnames(data_in4)[7] <- "NO_DataMax"
colnames(data_in4)[8] <- "NO_DataMaxHour"
colnames(data_in4)[9] <- "NO_DataAQI"

#~600 MB total
nr= nrow(data_in) + nrow(data_in2) + nrow(data_in3) + nrow(data_in4)
print(c("Total rows : ", nr))

#14 million 657 thousand 160 rows

#---------- site data ------------

sites <- read.csv("aqs_sites.csv")
sites1 <- sites[,-c( 6,10:28 )]

#----------- Data merge on state codes for NA values ---------------

#Join data based on site county and state id's to get factor data
#test for NA data
data_na <- data_in[rowSums(is.na(data_in)) > 0,]
nrow(data_na)

#1 million + records missing state code
#create a table of states and codes
site_codes <- sites[,c("State.Code","State.Name")]
site_codes <- unique(site_codes)

#merge state codes from the table
data_in <- merge(data_in, site_codes, by.x=c("State"), by.y=c("State.Name"), all.x=TRUE)
nrow(data_in)

#reset the statecode
data_in$StateCode <- data_in$State.Code

#remove columns
data_in <- data_in[,-c(2,14)]

#NA test now we have 0 NA rows
data_na <- data_in[rowSums(is.na(data_in)) > 0,]
nrow(data_na)

#----------- data merge on columns for extra site geo and subject data ----------------

#merge data and include geo and subject site data
data_merge <- merge(data_in, sites1, by.x=c("StateCode", "CountyCode", "SiteNumber"), by.y=c("State.Code", "County.Code", "Site.Number"), all.x=TRUE)
nrow(data_merge)

#na check
data_na <- data_merge[rowSums(is.na(data_merge)) > 0,]
nrow(data_na)

#reorder
data_merge <- data_merge[c(4,1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17)]

#sort
data_merge <- data_merge[order( data_merge$StateCode, data_merge$CountyCode, data_merge$SiteNumber,as.Date(data_merge$Date, format="%Y-%m-%d")),]


data_merge$Date <- as.Date(data_merge$Date, format = "%Y-%m-%d")
data_in2$Date <- as.Date(data_in2$Date, format = "%Y-%m-%d")
data_merge$StateCode <- as.character(data_merge$StateCode)
data_in2$StateCode <- as.character(data_in2$StateCode)




#------------- data 2 

data_na <- data_in2[rowSums(is.na(data_in2)) > 0,]
nrow(data_in2)
nrow(data_na)
data_in2 <- merge(data_in2, sites1, by.x=c("StateCode", "CountyCode", "SiteNumber"), by.y=c("State.Code", "County.Code", "Site.Number"), all.x=TRUE)


data_na <- data_in3[rowSums(is.na(data_in3)) > 0,]
nrow(data_in3)
nrow(data_na)
data_in3 <- merge(data_in3, sites1, by.x=c("StateCode", "CountyCode", "SiteNumber"), by.y=c("State.Code", "County.Code", "Site.Number"), all.x=TRUE)


data_na <- data_in4[rowSums(is.na(data_in4)) > 0,]
nrow(data_in4)
nrow(data_na)
data_in4 <- merge(data_in4, sites1, by.x=c("StateCode", "CountyCode", "SiteNumber"), by.y=c("State.Code", "County.Code", "Site.Number"), all.x=TRUE)


write.csv(data_merge, file = "44201_merged.csv")
write.csv(data_in2, file = "42101_merged.csv")
write.csv(data_in3, file = "42401_merged.csv")
write.csv(data_in4, file = "42602_merged.csv")
