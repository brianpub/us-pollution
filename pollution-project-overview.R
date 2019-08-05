#-------------------------------------------------------------------
#
# Notes
#
# About measuring the pollutants
#
# https://www.epa.gov/criteria-air-pollutants/naaqs-table
#
# Data metrics column details
#
# https://aqs.epa.gov/aqsweb/airdata/FileFormats.html
#
# Details on  air quality data in reports
#
# https://www.epa.gov/outdoor-air-quality-data/about-air-data-reports
#
# Identifiers - Gas
# 42101 CO  Carbon Monoxide
# 44201 Oz  Ozone
# 42401 So2 Sulfur Dioxide
# 42602 N02 Nitrogen Dioxide
#
# AQI Air Quality Index - number between 0 - 300
# CSBA Core based statistical area - area or group of monitors that make up a sample
#
#- data reporting is done on multiple standards
#- some data does not have AQI generated for the standard instead it uses the most current, or selected standard
#- 42401 SO 1 hour standard , SO2 3-hour 1971 dropped
#- 42101 CO CO 8-hour 1971, CO 1-hour 1971 dropped
#- 42602 NO NO2 1-hour only
#- 44201 OZ Missing data from nov to jan, gap in results due to unknowns
#
# Site / Monitor data
#
# Site data contains geolocation and land use information
# Elevation, land use ( agriculture, industrial, residential etc ), area setting ( suburban, commerical, etc, )
# Geo location
#
# Data aggregation
# 
# Data consisted of 76 files, 19 for each gas type from the years 2000-2018
# Each file consisted of records 10,000s of rows from multiple monitors across the US
# Total file size was 6.13 GB uncompressed
# Data was dropped with no AQI values, which were duplicated from other standards
# Data was combined based on gas type for a full daily report from 2000-2018 per gas type
# in total #14 million 657 thousand 160 rows are in the entire set of data
# After reducing and aggregating the data we reduced the size to 600 MB
#
#
# AQI buckets
#
# 0-50 Good
# 51-100 Moderate
# 101-150 Sensitive
# 151-200 Unhealthy
# 201-300 Very unhealthy
# 301+ Hazardous

#------  ECTL 
#
# pollution-data-download.r
# pollution-data-aggregation.r
# pollution-monthly-aggregation.r
# pollution-data-cleaning-town.r
#
# city_data_all - all files by gas
# merged - city_data_all + sites data
# city_monthly_all - monthly data + sites data
#
# ------ Analysis 
# pollution-analysis.r
# pollution-analysis-monthly.r
# pollution-timeseries.r
#

# Data samples
cwd <- getwd()
setwd("C:/Users/publikb/Documents/analytics/datasets/pollution")

first_file <- read.csv("daily_42101_2001.csv")

#Read in Ozone
sites <- read.csv("aqs_sites.csv")

data_in <- read.csv("44201_merged.csv")

data_in_monthly <- read.csv("44201_city_monthly_all.csv")


nrow(data_in)
nrow(data_in_monthly)

