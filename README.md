# us-pollution
Data ETL and analysis of us pollution data from the EPA

ECTL files are used to download and merge / aggregate / clean the data
It will consume about 15 GB of data before mergeing and cleaning
However some of the ECTL files look for all gas files, and only ozone and so2 are used in analysis at the moment
I included all the files in case you tried to run the aggregation code


<h4>Automatically download the EPA files</h4>
<p>If you just want to automatically download the EPA files use the pollution-data-download.r file</p>
<p>Adjust the categories and dates as nessecary in the R file</p>


#------  ECTL 
#
# Run in the following order depending on how raw you want the data
#
# pollution-data-download.r
# pollution-data-aggregation.r
# pollution-monthly-aggregation.r
# pollution-data-cleaning-town.r
#
# city_data_all - all files by gas
# merged - city_data_all + sites data
# city_monthly_all - data aggregated into monthly data + sites data
#
# ------ Analysis 
# pollution-analysis.r
# pollution-analysis-monthly.r
# pollution-timeseries.r
