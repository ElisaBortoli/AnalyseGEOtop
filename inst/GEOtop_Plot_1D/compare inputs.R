
#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   compare inputs.R
# TITLE:        compare GEOtop inputs meteo files
# Autor:        Giacomo Bertoldi
#               Institute for Alpine Environment
# Data:         06/06/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------



#------------------------------------------------------------------------
# Load libraries

if(!require("AnalyseGeotop"))
{
  if(!require("devtools"))
  {
    install.packages(devtools)
    require("devtools")
  }
  install_github("AnalyseGeotop", "JBrenn")
  require("AnalyseGeotop")
}

if(!require("dygraphs"))
{
  install.packages(dygraphs)
  require("dygraphs")
}

library(geotopbricks)
library(data.table)
library(zoo)
library(dygraphs)

Sys.setenv(TZ='Etc/GMT-1')# sets the environment on italy´s time zone

#===================================================================================================
# --- Function to import inputs data ---
input_by_variables=function(wpath){
  
  meteofile_roots=get.geotop.inpts.keyword.value("MeteoFile",wpath=wpath)
  meteofolder=strsplit(meteofile_roots, "/")[[1]][1]
  files=dir(paste(wpath,"/",meteofolder,"/",sep=""),pattern = "meteo")
  files=files[-grep("old",files)]
  
  #--- FIRST LOOP--------------
  # reading all input meteo data, skipping .old files
  meteo=read.table(paste(wpath,"/",meteofolder,"/",files[1],sep=""),sep = ",",stringsAsFactors = F)
  colnames(meteo)=meteo[1,]
  meteo=meteo[-1,]
  for(j in 2:ncol(meteo)){
    meteo[,j]=as.numeric(meteo[,j])
    meteo[,j]=replace(meteo[,j],which(meteo[,j]==-9999),NA)
  }
 
  year=substring(meteo$Date,7,10)
  month=substring(meteo$Date,4,5)
  day=substring(meteo$Date,1,2)
  hour=substring(meteo$Date,12,13)
  minute=substring(meteo$Date,15,16)
  
  date_chr <- paste(year, "-", month, "-", day, " ", hour, ":", minute, ":00", sep="")
  time <- as.POSIXct( strptime(x = date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
  
  zoo_meteo=zoo(meteo[,-1],order.by = time)
  
  Iprec=zoo_meteo[,which(colnames(zoo_meteo)=="Iprec")]
  WindSp=zoo_meteo[,which(colnames(zoo_meteo)=="WindSp")]
  WindDir=zoo_meteo[,which(colnames(zoo_meteo)=="WindDir")]
  RelHum=zoo_meteo[,which(colnames(zoo_meteo)=="RelHum")]
  AirT=zoo_meteo[,which(colnames(zoo_meteo)=="AirT")]
  Swglobal=zoo_meteo[,which(colnames(zoo_meteo)=="Swglobal")]
  
  Iprec_tot=Iprec
  WindSp_tot=WindSp
  WindDir_tot=WindDir
  RelHum_tot=RelHum
  AirT_tot=AirT
  Swglobal_tot=Swglobal
  
  #--- OTHER LOOPS--------------
  
  for(i in files[-1]){
    meteo=read.table(paste(wpath,"/",meteofolder,"/",i,sep=""),sep = ",",stringsAsFactors = F)
    colnames(meteo)=meteo[1,]
    meteo=meteo[-1,]
    for(j in 2:ncol(meteo)){
      meteo[,j]=as.numeric(meteo[,j])
      meteo[,j]=replace(meteo[,j],which(meteo[,j]==-9999),NA)
    }
    
    year=substring(meteo$Date,7,10)
    month=substring(meteo$Date,4,5)
    day=substring(meteo$Date,1,2)
    hour=substring(meteo$Date,12,13)
    minute=substring(meteo$Date,15,16)
    
    date_chr <- paste(year, "-", month, "-", day, " ", hour, ":", minute, ":00", sep="")
    time <- as.POSIXct( strptime(x = date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
    
    zoo_meteo=zoo(meteo[,-1],order.by = time)
    
    Iprec=zoo_meteo[,which(colnames(zoo_meteo)=="Iprec")]
    WindSp=zoo_meteo[,which(colnames(zoo_meteo)=="WindSp")]
    WindDir=zoo_meteo[,which(colnames(zoo_meteo)=="WindDir")]
    RelHum=zoo_meteo[,which(colnames(zoo_meteo)=="RelHum")]
    AirT=zoo_meteo[,which(colnames(zoo_meteo)=="AirT")]
    Swglobal=zoo_meteo[,which(colnames(zoo_meteo)=="Swglobal")]
    
    
    Iprec_tot=merge(Iprec_tot,Iprec)
    WindSp_tot=merge(WindSp_tot,WindSp)
    WindDir_tot=merge(WindDir_tot,WindDir)
    RelHum_tot=merge(RelHum_tot,RelHum)
    AirT_tot=merge(AirT_tot,AirT)
    Swglobal_tot=merge(Swglobal_tot,Swglobal)
    
  }
  
  colnames(Iprec_tot)=substring(files,1,9)
  colnames(WindSp_tot)=substring(files,1,9)
  colnames(WindDir_tot)=substring(files,1,9)
  colnames(RelHum_tot)=substring(files,1,9)
  colnames(AirT_tot)=substring(files,1,9)
  colnames(Swglobal_tot)=substring(files,1,9)
  
  return(list(Iprec_tot,WindSp_tot,WindDir_tot, RelHum_tot, AirT_tot, Swglobal_tot))
}
#=====================================================================================================

# --- Import inputs data for different simualtion and save as .Rdata ---

#------------------------------------------------------------------------
# Specify working path where are simulations data
# run the fucntion input_by_variables to import input data in R 

#wpath <-  "C:/Users/CBrida/Desktop/Simulations_GEOtop/CRYOMON_sim_157_v002/"
#wpath <-  "C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/CRYOMON_sim_157_v008/"

wpath <-  "C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/1D/CRYOMON_sim_1D_204_v002"
all_inputs=input_by_variables(wpath)
save(all_inputs,file="C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/Inputs_GEOtop_sim_1D_204_v002.Rdata")

wpath <-  "C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/3D/CRYOMON_sim_157_v009/"
all_inputs=input_by_variables(wpath = wpath)
save(all_inputs,file="C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/Inputs_GEOtop_sim009.Rdata")

#=====================================================================================================

# --- Load .Rdata ---

load("C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/Inputs_GEOtop_sim008.Rdata")
sim_0008=all_inputs

load("C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/Inputs_GEOtop_sim009.Rdata")
sim_0009=all_inputs

load("C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/Inputs_GEOtop_sim_1D_204_v002.Rdata")
sim_1D_002=all_inputs

#=====================================================================================================

# --- Aggregate and plot inputs ---

# Select simulations to aggregate and plot

simulation=sim_1D_002
simulation2=sim_0009

mycolors=c("red", "blue","yellow", "green", "orange","violet","lime","grey","black","pink","gold")
stations=c("red = M4","blue = B2","yellow = B3","green = M3","orange = B1",
           "violet = Teufelsegg","lime = Grawand","grey = Melag","black = Vernagt", "pink = Marienberg","gold = M4_snow")

#=============================================
# hourly data for variable sim 1 # simulation 8 new inputs until 2016
hourly_Iprec=simulation[[1]]
hourly_WindSp=simulation[[2]]
hourly_WindDir=simulation[[3]]
hourly_RelHum=simulation[[4]]
hourly_AirT=simulation[[5]]
hourly_Swglobal=simulation[[6]]

#=============================================
# plots hourly
dygraph(hourly_Iprec)%>% dyRangeSelector()
dygraph(hourly_WindSp)%>% dyRangeSelector()
dygraph(hourly_WindDir)%>% dyRangeSelector()
dygraph(hourly_RelHum)%>% dyRangeSelector()
dygraph(hourly_AirT)%>% dyRangeSelector()
dygraph(hourly_Swglobal)%>% dyRangeSelector()

#=============================================
# hourly data for variable sim 2 # simulation 9 old inputs ultil 2013
hourly_Iprec2=simulation2[[1]]
hourly_WindSp2=simulation2[[2]]
hourly_WindDir2=simulation2[[3]]
hourly_RelHum2=simulation2[[4]]
hourly_AirT2=simulation2[[5]]
hourly_Swglobal2=simulation2[[6]]

#=============================================
# hourly data difference sim 1 - 2

diff_Iprec = hourly_Iprec[1:nrow(hourly_Iprec),1:9] - hourly_Iprec2
diff_WindSp = hourly_WindSp[1:nrow(hourly_Iprec),1:9] - hourly_WindSp2
diff_WindDir = hourly_WindDir[1:nrow(hourly_Iprec),1:9] - hourly_WindDir2
diff_RelHum = hourly_RelHum[1:nrow(hourly_Iprec),1:9] - hourly_RelHum2
diff_AirT = hourly_AirT[1:nrow(hourly_Iprec),1:9] - hourly_AirT2
diff_Swglobal = hourly_Swglobal[1:nrow(hourly_Iprec),1:9] - hourly_Swglobal2

# plots hourly diff
dygraph(diff_Iprec)%>% dyRangeSelector()
dygraph(diff_WindSp)%>% dyRangeSelector()
dygraph(diff_WindDir)%>% dyRangeSelector()
dygraph(diff_RelHum)%>% dyRangeSelector()
dygraph(diff_AirT)%>% dyRangeSelector()
dygraph(diff_Swglobal)%>% dyRangeSelector()



#=============================================
# daily data
daily_Iprec=aggregate(hourly_Iprec,by=substring(index(hourly_Iprec),1,10), sum)
index(daily_Iprec)=as.POSIXct(index(daily_Iprec))
daily_WindSp=aggregate(hourly_WindSp,by=substring(index(hourly_WindSp),1,10), mean)
index(daily_WindSp)=as.POSIXct(index(daily_WindSp))
daily_WindDir=aggregate(hourly_WindDir,by=substring(index(hourly_WindDir),1,10), mean)
index(daily_WindDir)=as.POSIXct(index(daily_WindDir))
daily_RelHum=aggregate(hourly_RelHum,by=substring(index(hourly_RelHum),1,10), mean)
index(daily_RelHum)=as.POSIXct(index(daily_RelHum))
daily_AirT=aggregate(hourly_AirT,by=substring(index(hourly_AirT),1,10), mean)
index(daily_AirT)=as.POSIXct(index(daily_AirT))
daily_Swglobal=aggregate(hourly_Swglobal,by=substring(index(hourly_Swglobal),1,10), mean)
index(daily_Swglobal)=as.POSIXct(index(daily_Swglobal))

# plots daily
dygraph(daily_Iprec)%>% dyRangeSelector()
#dygraph(daily_Swglobal)%>% dyRangeSelector()

#=============================================
# monthly
monthly_Iprec=aggregate(hourly_Iprec,by=substring(index(hourly_Iprec),1,7), sum)
index(monthly_Iprec)=as.POSIXct(paste(index(monthly_Iprec),"-15",sep = ""))
monthly_WindSp=aggregate(hourly_WindSp,by=substring(index(hourly_WindSp),1,7), mean)
index(monthly_WindSp)=as.POSIXct(paste(index(monthly_WindSp),"-15",sep = ""))
monthly_WindDir=aggregate(hourly_WindDir,by=substring(index(hourly_WindDir),1,7), mean)
index(monthly_WindDir)=as.POSIXct(paste(index(monthly_WindDir),"-15",sep = ""))
monthly_RelHum=aggregate(hourly_RelHum,by=substring(index(hourly_RelHum),1,7), mean)
index(monthly_RelHum)=as.POSIXct(paste(index(monthly_RelHum),"-15",sep = ""))
monthly_AirT=aggregate(hourly_AirT,by=substring(index(hourly_AirT),1,7), mean)
index(monthly_AirT)=as.POSIXct(paste(index(monthly_AirT),"-15",sep = ""))
monthly_Swglobal=aggregate(hourly_Swglobal,by=substring(index(hourly_Swglobal),1,7), mean)
index(monthly_Swglobal)=as.POSIXct(paste(index(monthly_Swglobal),"-15",sep = ""))

dygraph(monthly_Iprec)%>% dyRangeSelector()
dygraph(monthly_WindSp)%>% dyRangeSelector()
dygraph(monthly_WindDir)%>% dyRangeSelector()
dygraph(monthly_RelHum)%>% dyRangeSelector()
dygraph(monthly_AirT)%>% dyRangeSelector()
dygraph(monthly_Swglobal)%>% dyRangeSelector()

#=============================================
# year
year_Iprec=aggregate(hourly_Iprec,by=substring(index(hourly_Iprec),1,4), sum)
index(year_Iprec)=as.POSIXct(paste(index(year_Iprec),"-06-15",sep = ""))
year_WindSp=aggregate(hourly_WindSp,by=substring(index(hourly_WindSp),1,4), mean)
index(year_WindSp)=as.POSIXct(paste(index(year_WindSp),"-06-15",sep = ""))
year_WindDir=aggregate(hourly_WindDir,by=substring(index(hourly_WindDir),1,4), mean)
index(year_WindDir)=as.POSIXct(paste(index(year_WindDir),"-06-15",sep = ""))
year_RelHum=aggregate(hourly_RelHum,by=substring(index(hourly_RelHum),1,4), mean)
index(year_RelHum)=as.POSIXct(paste(index(year_RelHum),"-06-15",sep = ""))
year_AirT=aggregate(hourly_AirT,by=substring(index(hourly_AirT),1,4), mean)
index(year_AirT)=as.POSIXct(paste(index(year_AirT),"-06-15",sep = ""))
year_Swglobal=aggregate(hourly_Swglobal,by=substring(index(hourly_Swglobal),1,4), mean)
index(year_Swglobal)=as.POSIXct(paste(index(year_Swglobal),"-06-15",sep = ""))

dygraph(year_Iprec)%>% dyRangeSelector()
dygraph(year_WindSp)%>% dyRangeSelector()
dygraph(year_WindDir)%>% dyRangeSelector()
dygraph(year_RelHum)%>% dyRangeSelector()
dygraph(year_AirT)%>% dyRangeSelector()
dygraph(year_Swglobal)%>% dyRangeSelector()

#=============================================
# test cumulate
library(plyr) 
library(ggplot2) 
library(lubridate) 


ddd=hourly_Iprec
for(k in 1:ncol(hourly_Iprec)){
ddd[is.na(ddd[,k]),k]=0
}
cumulate_Iprec=cumsum(ddd)

dygraph(cumulate_Iprec)%>%dyRangeSelector()



