#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   GEOtop_Plot_Point.R
# Description:  Plot using dygraph different variables of a single point  
#               Other interactive scripts are available in https://github.com/EURAC-Ecohydro/AnalyseGEOtop/tree/master/inst/Rmd
# Autors:        Christian Brida, Giacomo Bertoldi, based  on scripts developed by Johannes Brenner (https://github.com/JBrenn)
#               Institute for Alpine Environment
# Data:         06/06/2017
#------------------------------------------------------------------------------------------------------------------------------------------------------

# Select simulation folder (wpath <- ...):
wpath <- "/home/elisa/Scrivania/MHPC/CRYOMON_sim_1D_204_v004"

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

library(ggplot2)

library(AnalyseGeotop)

#- Read "tabs/point" files of simulations -----------------------------------------------------------------------------------------------------------------

# get available keywords
keywords <- declared.geotop.inpts.keywords(wpath = wpath)$Keyword


# Import data
# to add here a user confirmation if you load existing data
# it does not work any more in the more complete case of soil_info = T
out <- GEOtop_ReadPointData_Generalized(wpath,soil_info = F,save_rData = F) # function using as args the previously declared wpath

# Import points coordinates
xpoints <- get.geotop.inpts.keyword.value("CoordinatePointX",wpath=wpath,numeric=T)
ypoints <- get.geotop.inpts.keyword.value("CoordinatePointY",wpath=wpath,numeric=T)

n_points_available <- as.numeric(length(xpoints))

#- Select inputs ------------------------------------------------------------------------------------------------------------------------------------------

# Select the sigle point to plot
# to add here an interactive choiche
cat(paste("Number of points available:",n_points_available))
point = 1 # <-- Select the point here ( value = 1, ... , n_point_available) 
out_new <- out[[point]] 

# List the variable to plot
choices = names(out[[point]])
paste("Variables:",choices)

#- Plot variables for single point -------------------------------------------------------------------------------------------------------------------------

# --------------------------------------------------
# (1) Snow height plot
input_variables = c("snow_depth.mm.", # <-- Select variables here ( value = 1, ... , n_point_available)                       
                  "Psnow_over_canopy.mm.",
                  "Prain_over_canopy.mm.")
mydata <- out_new[,input_variables] 

myfigure <- dygraph(mydata) %>%
  dyRangeSelector() %>%
  dyRoller()

myfigure

p <- ggplot(data = mydata,mapping = aes(x=as.POSIXct(index(mydata)), y=snow_depth.mm.))+
  geom_line()+
  geom_line(aes(y=Psnow_over_canopy.mm.), color="blue")+
  geom_line(aes(y=Prain_over_canopy.mm.), color="red")
p
ggsave(plot = p, filename=file.path(wpath ,"out","1_snow_height.jpeg"), device = "jpeg") # the folder "out" MUST already be there!

# --------------------------------------------------
# (2) Snow water equivalent plot
input_variables = c("snow_water_equivalent.mm.", # <-- Select variables here ( value = 1, ... , n_point_available)                       
                  "snow_melted.mm.",
                  "snow_subl.mm.")
mydata <- out_new[,input_variables] 

myfigure <- dygraph(mydata) %>%
  dyRangeSelector() %>%
  dyRoller()

myfigure

p<-ggplot(data = mydata,mapping = aes(x=as.POSIXct(index(mydata)), y=snow_water_equivalent.mm.))+
  geom_line()+
  geom_line(aes(y=snow_melted.mm.), color="blue")+
  geom_line(aes(y=snow_subl.mm.), color="red")
p
ggsave(plot = p, filename=file.path(wpath ,"out","2_snow_water_equivalent.jpeg"), device = "jpeg") 

# --------------------------------------------------
# (3) Snow density plot
input_variables = c("snow_density.kg.m3.")
mydata <- out_new[,input_variables] 

myfigure <- dygraph(mydata) %>%
  dyRangeSelector() %>%
  dyRoller()

myfigure

# p<-ggplot(data = mydata,mapping = aes(x=as.POSIXct(index(mydata)), y=snow_density.kg.m3.))+
#   geom_line()
# p # ===> Error in FUN(X[[i]], ...) : oggetto "snow_density.kg.m3." non trovato
# ggsave(plot = p, filename=file.path(wpath ,"out","3_snow_density.jpeg"), device = "jpeg") 

# --------------------------------------------------
# (4) Snow temperature plot
input_variables = c( "snow_temperature.C.")
mydata <- out_new[,input_variables] 

myfigure <- dygraph(mydata) %>%
  
  
  dyRangeSelector() %>%
  dyRoller()

myfigure

# p<-ggplot(data = mydata,mapping = aes(x=as.POSIXct(index(mydata)), y=snow_temperature.C.))+
#   geom_line()
# p ===> Error in FUN(X[[i]], ...) : oggetto "snow_temperature.C." non trovato
# ggsave(plot = p, filename=file.path(wpath ,"out","4_snow_temperature.jpeg"), device = "jpeg") 
# --------------------------------------------------
# (5) Plots and saves one snow plot as file
point = 4 
out_new <- out[[point]] 
input_variables = c("snow_depth.mm.", # <-- Select variables here ( value = 1, ... , n_point_available)                       
                  "Psnow_over_canopy.mm.",
                  "Prain_over_canopy.mm.")
mydata <- out_new[,input_variables] 


p<-ggplot(data = mydata,mapping = aes(x=as.POSIXct(index(mydata)), y=snow_depth.mm.))+
  geom_line()+
  geom_line(aes(y=Psnow_over_canopy.mm.), color="blue")+
geom_line(aes(y=Prain_over_canopy.mm.), color="red")
p
ggsave(plot = p, filename=file.path(wpath ,"out","5_snow_depth.jpeg"), device = "jpeg")

# --------------------------------------------------
# (6) Plots and saves many snow plot as file
input_variables = c("snow_depth.mm.", # <-- Select variables here ( value = 1, ... , n_point_available)                       
                  "Psnow_over_canopy.mm.",
                  "Prain_over_canopy.mm.")
lapply(seq(from=1,to=n_points_available,by=1), GEOtop_Plot_loop, out=out, input_variables=input_variables,"6_snow_depth")
# This should produce 9 pics but only one empty figure "6_snow1_depth.jpeg" is generated!
# --------------------------------------------------
# (7) Et partitioning plot
input_variables = c("Evap_surface.mm.", # <-- Select variables here ( value = 1, ... , n_point_available)                       
                  "Trasp_canopy.mm.",
                  "Evapotranspiration.mm.")
mydata <- out_new[,input_variables] 

dygraph(mydata) %>%
  dyRangeSelector() %>%
  dyRoller()

p<-ggplot(data = mydata,mapping = aes(x=as.POSIXct(index(mydata)), y=Evap_surface.mm.))+
  geom_line()+
  geom_line(aes(y=Trasp_canopy.mm.), color="blue")+
  geom_line(aes(y=Evapotranspiration.mm.), color="red")
p
ggsave(plot = p, filename=file.path(wpath ,"out","7_Evap_surface.jpeg"), device = "jpeg")



