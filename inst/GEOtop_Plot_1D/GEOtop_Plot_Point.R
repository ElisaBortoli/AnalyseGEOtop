#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   GEOtop_Plot_Point.R
# Description:  Plot using dygraph different variables of a single point  
#               Other interactive scripts are available in https://github.com/EURAC-Ecohydro/AnalyseGEOtop/tree/master/inst/Rmd
# Autor:        Christian Brida, based  on scripts developed by Johannes Brenner (https://github.com/JBrenn)
#               Institute for Alpine Environment
# Data:         06/06/2017
#------------------------------------------------------------------------------------------------------------------------------------------------------

# Select simulation folder (wpath <- ...):
# wpath <-  "C:/Users/CBrida/Desktop/Simulations_GEOtop/CRYOMON_sim_157_v002/"     
# wpath <-  "C:/Users/GBertoldi/Documents/Simulations_local/Kaltern_veg/Kaltern_veg_004"
# wpath  <-  "C:/Users/GBertoldi/Documents/Simulations_local/Snow_Cryomon/CRYOMON_sim_157_v021/"

wpath  <-  "C:/Users/GBertoldi/Documents/Simulations_local/Montacini_elisa/1D/Matsch_P2_Ref_001"
#wpath  <-  "C:/Users/GBertoldi/OneDrive - Scientific Network South Tyrol/Simulations/Johannes/1D/B2_P2_Giacomo/B2_BeG_012S"


#- Install and import packages and functions ----------------------------------------------------------------------------------------------------------

if(!require("AnalyseGeotop"))
{
  if(!require("devtools"))
  {
    install.packages("devtools")
    require("devtools")
  }
  install_github("AnalyseGeotop", "EURAC-Ecohydro")
  require("AnalyseGeotop")
}

if(!require("dygraphs"))
{
  install.packages("dygraphs")
  require("dygraphs")
}

if(!require("geotopbricks"))
{
  install.packages("geotopbricks")
  require("geotopbricks")
}

if(!require("data.table"))
{
  install.packages("data.table")
  require("data.table")
}

# Loads functions (until this is not in an R package)
source("../../R/GEOtop_ReadPointData_Generalized.R") # this function is available in folder AnalyseGEOtop/ins/GEOtop_Plot_1D


#- Read "tabs/point" files of simulations -----------------------------------------------------------------------------------------------------------------

# get available keywords
keywords <- declared.geotop.inpts.keywords(wpath = wpath)$Keyword


# Import data
# to add here a user confirmation if you load existing data
# it does not work any more in the more complete case of soil_info = T

#if (file.exists(file.path(wpath,"PointOut.RData"))) {
#  load(file.path(wpath,"PointOut.RData"))
#} else {
  out <- GEOtop_ReadPointData_Generalized(wpath,soil_info = F,save_rData = F)
#}

# Import points coordinates

xpoints <- get.geotop.inpts.keyword.value("CoordinatePointX",wpath=wpath,numeric=T)
ypoints <- get.geotop.inpts.keyword.value("CoordinatePointY",wpath=wpath,numeric=T)

n_points_available <- as.numeric(length(xpoints))

#- Select inputs ------------------------------------------------------------------------------------------------------------------------------------------

# Select the sigle point to plot
# to add here an interactive choiche
cat(paste("Number of points available:",n_points_available))
point=1 # <-- Select the point here ( value = 1, ... , n_point_available) 
out_new <- out[[point]] 

# List the variable to plot
choices = names(out[[point]])
paste("Variables:",choices)

#- Plot variables for single point -------------------------------------------------------------------------------------------------------------------------
cat(paste("Advice: to plot maximum 5 variables on the same graph!"))

# --------------------------------------------------
# Snow plot
input_variables=c("snow_depth.mm.",                                  # <-- Select variables here ( value = 1, ... , n_point_available)                       
                  "Psnow_over_canopy.mm.",
                  "Prain_over_canopy.mm.")
mydata <- out_new[,input_variables] 

dygraph(mydata) %>%
  dyRangeSelector() %>%
  dyRoller()

# --------------------------------------------------
# Et partioning plot
input_variables=c("snow_depth.mm.",                                  # <-- Select variables here ( value = 1, ... , n_point_available)                       
                  "Psnow_over_canopy.mm.",
                  "Prain_over_canopy.mm.")
mydata <- out_new[,input_variables] 

dygraph(mydata) %>%
  dyRangeSelector() %>%
  dyRoller()






