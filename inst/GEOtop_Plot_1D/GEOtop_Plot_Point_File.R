#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   GEOtop_Plot_Point_File.R
# Description:  Plot using dygraph different variables of a single point  
#               Other interactive scripts are available in https://github.com/EURAC-Ecohydro/AnalyseGEOtop/tree/master/inst/Rmd
# Autors:       Elisa Bortoli, based  on scripts developed by Johannes Brenner (https://github.com/JBrenn)
#               Institute for Alpine Environment
# Data:         25/03/2019
#------------------------------------------------------------------------------------------------------------------------------------------------------

# Select simulation folder (wpath <- ...):
wpath <- "/home/elisa/Scrivania/MHPC/geotop_3.0/tests/1D/Matsch_B2_Ref_007"

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

#- Read "output-tabs/point" files of simulations -----------------------------------------------------------------------------------------------------------------

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
input_variables = c("Prain_over_canopy.mm.",                     
                    "Prain_under_canopy.mm.",
                    "Prain_rain_on_snow.mm.")

mydata <- out_new[,input_variables] 

myfigure <- dygraph(mydata) %>%
  dyRangeSelector() %>%
  dyRoller()

myfigure

p <- ggplot(data = mydata, mapping = aes(x=as.POSIXct(index(mydata)), y=Prain_over_canopy.mm.))+
  geom_line()+
  geom_line(aes(y=Prain_under_canopy.mm.), color="blue")+
  geom_line(aes(y=Prain_rain_on_snow.mm.), color="red")+
  xlab("") +
  ylab("[mm]") +
  ggtitle("Prain")+
  theme(plot.title = element_text(hjust = 0.5))
p # show the picture that will be saved

ggsave(plot = p, filename=file.path(wpath ,"pics","1_snow_height.jpeg"), device = "jpeg") # the folder "out" MUST already be there!






