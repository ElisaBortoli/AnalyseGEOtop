#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   GEOtop_Plot_Basin.R
# TITLE:        test to plot discharge and basin averaged GEOtop output files
#               available in https://github.com/EURAC-Ecohydro/AnalyseGEOtop/tree/master/GEOtopPlot3D/
# Autor:        Giacomo Bertoldi
#               Institute for Alpine Environment
# Data:         06/06/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

# Specify working path where are simulations data
wpath <- "/home/elisa/Scrivania/MHPC/CRYOMON_sim_157_v017"

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

library(ggplot2)
library(AnalyseGeotop)

#------------------------------------------------------------------------
# read data from folder wpath

# get available keywords
keywords <- declared.geotop.inpts.keywords(wpath = wpath)$Keyword # open geotop.inpts

basin_data <- get.geotop.inpts.keyword.value(keyword="BasinOutputFile", wpath=wpath,
                                             raster=FALSE,
                                             data.frame=TRUE,
                                             formatter ="",
                                             date_field="Date12.DDMMYYYYhhmm.",
                                             tz="Etc/GMT+1")
# The following file is NOT present 
# discharge_data <- get.geotop.inpts.keyword.value(keyword="DischargeFile", wpath=wpath,
#                                              raster=FALSE,
#                                              data.frame=TRUE,
#                                              formatter ="",
#                                              date_field="Date12.DDMMYYYYhhmm.",
#                                              tz="Etc/GMT+1")

##------------------------------------------------------------------------
# plot basin data
#if(!is.null(basin_data)){
  
  # list avaliable variables
  choices = names(basin_data)
  paste("Variable in BasinOutputFile:", choices)
  
  # +++++ select inputs
  
  # ============================================================
  # precipitation plot at output time step
  input_variables = c ("Prain_below_canopy.mm.",
                       "Psnow_below_canopy.mm.",
                       "Prain_above_canopy.mm.",
                       "Pnet.mm.")                    
  forplot <- input_variables
  data <- basin_data[,forplot] 
  # +++++ plot time series
  dygraph(data) %>%
  dyRangeSelector() %>%
  dyRoller()

  p <- ggplot(data = data, mapping = aes(x=as.POSIXct(index(data)), y=Prain_below_canopy.mm.))+
    geom_line()+
    geom_line(aes(y=Psnow_below_canopy.mm.), color="blue")+
    geom_line(aes(y=Prain_above_canopy.mm.), color="red")+
    geom_line(aes(y=Prain_above_canopy.mm.), color="green")+
    geom_line(aes(y=Pnet.mm.), color="black")
  p
  ggsave(filename=file.path(wpath ,"out","1_precipitation.jpeg"), device = "jpeg") # the folder "out" MUST already be there!
  
  # ============================================================
  # temperature plot at output time step
  input_variables = c ("Tair.C.",
                       "Tsurface.C.",
                       "Tvegetation.C.")
  forplot <- input_variables
  data <- basin_data[,forplot] 
  # +++++ plot time series
  dygraph(data) %>%
    dyRangeSelector() %>%
    dyRoller()
  
  p <- ggplot(data = data, mapping = aes(x=as.POSIXct(index(data)), y=Tair.C.))+
    geom_line()+
    geom_line(aes(y=Tsurface.C.), color="blue")+
    geom_line(aes(y=Tvegetation.C.), color="red")
  p
  ggsave(filename=file.path(wpath ,"out","2_temperature.jpeg"), device = "jpeg") 
  
  # ============================================================
  # evaporation plot at output time step
  input_variables = c ("Evap_surface.mm.",
                       "Transpiration_canopy.mm.")
  mycolors = c ("red","green")
  forplot <- input_variables
  data <- basin_data[,forplot] 
  # +++++ plot time series
  dygraph(data) %>%
    dyRangeSelector() %>%
    dyRoller() %>%
    dyOptions(colors=mycolors)
  
  # ============================================================
  # turbulent heat fluxes plot at output time step
  input_variables = c ("LE.W.m2.",
                       "H.W.m2.",
                       "LEv.W.m2.",
                       "Hv.W.m2.")
  #mycolors = c ("red","green")
  forplot <- input_variables
  data <- basin_data[,forplot] 
  # +++++ plot time series
  dygraph(data) %>%
    dyRangeSelector() %>%
    dyRoller()
    #dyOptions(colors=mycolors)
  
  # ============================================================
  # shortwave fluxes plot at output time step
  input_variables = c ("SWin.W.m2.",
                       "SW.W.m2.",
                       "SWv.W.m2.")
  #mycolors = c ("red","green")
  forplot <- input_variables
  data <- basin_data[,forplot] 
  # +++++ plot time series
  dygraph(data) %>%
    dyRangeSelector() %>%
    dyRoller()
  #dyOptions(colors=mycolors)
  
  # ============================================================
  # LONGWAVE fluxes plot at output time step
  input_variables = c ("LWin.W.m2.",
                       "LW.W.m2.",
                       "LWv.W.m2.")
  #mycolors = c ("red","green")
  forplot <- input_variables
  data <- basin_data[,forplot] 
  # +++++ plot time series
  dygraph(data) %>%
    dyRangeSelector() %>%
    dyRoller()
  #dyOptions(colors=mycolors)
  
  
  # ============================================================
  # Mass balance error plot at output time step
  input_variables = c ("Mass_balance_error.mm.")
  forplot <- input_variables
  data <- basin_data[,forplot] 
  # +++++ plot time series
  dygraph(data) %>%
    dyRangeSelector() %>%
    dyRoller()
  
  # ============================================================
  # Mass Mean time step plot at output time step
  input_variables = c ("Mean_Time_Step.s.")
  forplot <- input_variables
  data <- basin_data[,forplot] 
  # +++++ plot time series
  dygraph(data) %>%
    dyRangeSelector() %>%
    dyRoller()
  
  
#}




