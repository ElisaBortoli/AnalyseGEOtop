#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   GEOtop_Plot_Point.R
# Description:  Plot using dygraph different variables of a single point  
#               Other interactive scripts are available in https://github.com/EURAC-Ecohydro/AnalyseGEOtop/tree/master/inst/Rmd
# Autor:        Christian Brida, based  on scripts developed by Johannes Brenner (https://github.com/JBrenn)
#               Institute for Alpine Environment
# Data:         06/06/2017
#------------------------------------------------------------------------------------------------------------------------------------------------------

#- Install and import packages and functions ----------------------------------------------------------------------------------------------------------

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

if(!require("geotopbricks"))
{
  install.packages(geotopbricks)
  require("geotopbricks")
}

if(!require("data.table"))
{
  install.packages(data.table)
  require("data.table")
}

source("GEOtop_ReadPointData_Generalized.R") # this function is available in folder AnalyseGEOtop/ins/GEOtop_Plot_1D

#- Read "tabs/point" files of simulations -----------------------------------------------------------------------------------------------------------------

# Select simulation folder (wpath <- ...):
wpath <-  "C:/Users/CBrida/Desktop/Simulations_GEOtop/CRYOMON_sim_157_v002/"     
# wpath <-  "C:/Users/GBertoldi/Documents/Simulations_local/Kaltern_veg/Kaltern_veg_004"


# Import data
if (file.exists(file.path(wpath,"PointOut.RData"))) {
  load(file.path(wpath,"PointOut.RData"))
} else {
  out <- GEOtop_ReadPointData_Generalized(wpath,soil_parameters = F,save_rData = T)
}

# Import points coordinates

xpoints <- get.geotop.inpts.keyword.value("CoordinatePointX",wpath=wpath,numeric=T)
ypoints <- get.geotop.inpts.keyword.value("CoordinatePointY",wpath=wpath,numeric=T)

n_points_available <- as.numeric(length(xpoints))

#- Select inputs ------------------------------------------------------------------------------------------------------------------------------------------

# Select the sigle point to plot
cat(paste("Number of point available:",n_points_available))
point=1                                                            # <-- Select the point here ( value = 1, ... , n_point_available) 

# Select the sigle point to plot
choices = names(out[[point]])
paste("Variable:",choices)

cat(paste("Advice: to plot maximum 5 variables on the same graph!"))
input_variables=c("snow_depth.mm.",                                  # <-- Select variables here ( value = 1, ... , n_point_available)                       
                  "snow_water_equivalent.mm.",
                  "snow_water_equivalent.mm." ,
                  "snow_density.kg.m3.",
                  "snow_temperature.C.")

#- Plot variable for single point -------------------------------------------------------------------------------------------------------------------------

out_new <- out[[point]]
forplot <- input_variables

mydata <- out_new[,forplot] 

dygraph(mydata) %>%
  dyRangeSelector() %>%
  dyRoller()






