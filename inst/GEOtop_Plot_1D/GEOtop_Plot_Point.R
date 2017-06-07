#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   extract_Analyse GEOtop point simualtion.R
# TITLE:        test on script Analyse GEOtop point simualtion.Rmd 
#               available in https://github.com/EURAC-Ecohydro/AnalyseGEOtop/tree/master/inst/Rmd
# Autor:        Christian Brida  
#               Institute for Alpine Environment
# Data:         06/06/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------


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
# read data from folder wpath
source("GEOtop_ReadPointData_Generalized.R")
#wpath <-  "C:/Users/CBrida/Desktop/Simulations_GEOtop/CRYOMON_sim_157_v002/"
wpath <-  "C:/Users/GBertoldi/Documents/Simulations_local/Kaltern_veg/Kaltern_veg_004"

# sim data
if (file.exists(file.path(wpath,"PointOut.RData"))) {
  load(file.path(wpath,"PointOut.RData"))
} else {
  out <- GEOtop_ReadPointData_Generalized(wpath = wpath, save_rData = F,soil = F)
}

# +++++ select inputs
choises_point=as.numeric(length(out))
point=1                                 # see geotop.inpts  -> POINT SETTINGS  to explore the point position
choices = names(out[[point]])
choices
input_variable1 = "snow_depth.mm."          #   <-- put here one of variables that you can show runnung the row before
input_variable2 = "snow_water_equivalent.mm." 
input_variable3 = "snow_density.kg.m3."
input_variable4 = "snow_temperature.C."  
input_variable5 = "n.a."
input_fromabove = "normal"              # choices = c("normal","from above")
# +++++ plot time series
out_new <- out[[point]]
forplot <- c(input_variable1, input_variable2, input_variable3, input_variable4, input_variable5)
forplot <- forplot[forplot != "n.a."]

data <- out_new[,forplot] 

if (input_variable5 == "n.a.") {
  
  dygraph(data) %>%
    dyRangeSelector() %>%
    dyRoller()
  
} else {
  
  if (input_fromabove == "from above") {
    data[,input_variable5] <- data[,input_variable5] * (-1)
    dygraph(data) %>%
      dyRangeSelector() %>%
      dyRoller() %>%
      dySeries(name = input_variable5, axis = "y2", stepPlot = TRUE, fillGraph = TRUE)
  } else {
    dygraph(data) %>%
      dyRangeSelector() %>%
      dyRoller()
  }
  
  
}
