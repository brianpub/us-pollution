#-------------------------------------------------------------------
# Brian Publik
# Data downloading
#-------------------------------------------------------------------

#cwd <- getwd()
#setwd("C:/Users/publikb/Documents/analytics/datasets/pollution")

#--- download pollution data
#--- https://aqs.epa.gov/aqsweb/airdata/download_files.html#Daily
#--- https://aqs.epa.gov/aqsweb/airdata/daily_44201_2017.zip

#--- test
#download.file("https://aqs.epa.gov/aqsweb/airdata/daily_44201_2017.zip",destfile="daily_44201_2017.zip",method="libcurl")
#unzip("daily_44201_2017.zip")
#read.csv("daily_44201_2017.csv")

#All pollution gases
#Ozone (44201)	
#SO2 (42401)	
#CO (42101)	
#NO2 (42602)
clist <- c("44201", "42401", "42101", "42602")

#------- future data , did not work into current project
#particulates
#PM2.5 FRM/FEM Mass (88101)	
#PM2.5 non FRM/FEM Mass (88502)	
#PM10 Mass (81102)	
#PM2.5 Speciation	
#PM10 Speciation
#clist <- c("88101", "88502", "81102", "SPEC", "PM10SPEC")

#meterological
#Winds (Resultant)	
#Temperature (62101)	B
#Barometric Pressure (64101)	
#RH and Dewpoint
#clist <- c("WIND","TEMP","PRESS","RH_DP")


#----------------- Retrieve data --------------------
year_list <- c(2000:2018)

#For each gas
for( cat in clist ){
  
  #For each year
  for( y in year_list ){
    
    #Download and unzip file
    url_in = paste( "https://aqs.epa.gov/aqsweb/airdata/daily_", cat, "_", y, ".zip" , sep = "" )
    file_in = paste("daily_", cat, "_", y, ".zip" , sep = "" )
    
    print(c("Downloading file " , url_in))
    
    download.file(url_in, destfile=file_in,method="libcurl")
    unzip(file_in)
    
  }
  
}


#---- monitor data from epa above 

download.file("https://aqs.epa.gov/aqsweb/airdata/aqs_sites.zip",destfile="aqs_sites.zip",method="libcurl")
unzip("aqs_sites.zip")

#setwd(cwd)