# Function to load GEOtop point simulation output
#
# Developed by J. Brenner
# improved by C. Brida and G. Bertoldi
# added compatibility with multiple point output and no soil files 

# needed until is not placed in a R package
library(geotopbricks)

GEOtop_ReadPointData_Generalized <- function(wpath, 
											 soil_info=TRUE,
											 soil_files=TRUE,
                       soil_output_files=c("SoilLiqContentProfileFile","SoilIceContentProfileFile", "SoilLiqWaterPressProfileFile", "SoilAveragedTempProfileFile"), 
											 snow_info=FALSE,
											 save_rData=TRUE)
{
  
  
  # get x- , y-coordinates of output points
  if (file.exists(file.path(wpath,"listpoints.txt")))
  {
    listpoints <- read.csv(file.path(wpath,"listpoints.txt"))
    xpoints <- listpoints$xcoord
    ypoints <- listpoints$ycoord
  } else {
    xpoints <- get.geotop.inpts.keyword.value("CoordinateX",wpath=wpath,numeric=T)
    ypoints <- get.geotop.inpts.keyword.value("CoordinateY",wpath=wpath,numeric=T)
  }
  
  level <- 1:length(xpoints)
  
  # level <- 3
  out=vector("list",length(xpoints))
  for(i in 1:length(xpoints)){
    # read point data with specified keyword  
    
    point_data <- get.geotop.inpts.keyword.value(keyword="PointOutputFile", wpath=wpath,
                                                 raster=FALSE,
                                                 data.frame=TRUE,
                                                 level=level[i], 
                                                 date_field="Date12[DDMMYYYYhhmm]",
                                                 tz="Etc/GMT+1")
    
    dt <- as.data.table(point_data)
    
    #LWnet.W.m2. and SWnet.W.m2. is below the canopy, also LE and H 
    
    
    # get variables direct or postprocessed from point data 
    
    out_df <-
      dt %>%
     # Evapotranspiration
    dplyr::mutate(Evapotranspiration.mm. = Evap_surface.mm. + Trasp_canopy.mm.) %>%
     # partitioning: 1 means full evaporation - 0 means full transpiration
     dplyr::mutate(Evapotranspiration_Partitioning = Evap_surface.mm. / Evapotranspiration.mm.) %>%
     # precipitation
     dplyr::mutate(PrainPsnow_over_canopy.mm. = Psnow_over_canopy.mm. + Prain_over_canopy.mm.)  %>%
     # partitioning: 1 means full rain - 0 means full snow
     dplyr::mutate(Precipitation_part_over_canopy = Prain_over_canopy.mm. / PrainPsnow_over_canopy.mm.) %>%
     # net shortwave energy flux
     dplyr::mutate(Net_shortwave_flux_W.m2. = SWin[W/m2] - SWup.W.m2.) %>%
     # net shortwave energy flux
     dplyr::mutate(Net_longwave_flux_W.m2. = LWin.W.m2. - LWup.W.m2.) %>%
     # net radiation
     dplyr::mutate(Net_radiation_W.m2. = Net_shortwave_flux_W.m2. + Net_longwave_flux_W.m2.) %>%
     # latent heat flux in air
     dplyr::mutate(Latent_heat_flux_over_canopy_W.m2. = Canopy_fraction... * (LEg_veg.W.m2. + LEv.W.m2.) + (1-Canopy_fraction...) * LEg_unveg.W.m2.) %>%
     # sensible heat flux in air
     dplyr::mutate(Sensible_heat_flux_over_canopy_W.m2. = Canopy_fraction... * (Hg_veg.W.m2. + Hv.W.m2.) + (1-Canopy_fraction...) * Hg_unveg.W.m2.) %>%
     # energy budget
     dplyr::mutate(Energy_budget_storage_W.m2. = Net_radiation_W.m2. - Latent_heat_flux_over_canopy_W.m2. - Sensible_heat_flux_over_canopy_W.m2. - Soil_heat_flux.W.m2.)


	# get available keywords
    keywords <- declared.geotop.inpts.keywords(wpath = wpath)$Keyword
    
    if(soil_info==TRUE){
      
      # get soil information
      if (soil_files) {
        soil_input <- get.geotop.inpts.keyword.value(keyword="SoilParFile", wpath=wpath, data.frame=TRUE)
        soil_thickness <- soil_input[,1]
      } else {
        Dz <- soil_thickness <- get.geotop.inpts.keyword.value("SoilLayerThicknesses", numeric = T, wpath=wpath)
        Kh <-     get.geotop.inpts.keyword.value("NormalHydrConductivity", numeric = T, wpath=wpath)
        Kv <-     get.geotop.inpts.keyword.value("LateralHydrConductivity", numeric = T, wpath=wpath)
        vwc_r <-  get.geotop.inpts.keyword.value("ThetaRes", numeric = T, wpath=wpath)
        vwc_w <-  get.geotop.inpts.keyword.value("WiltingPoint", numeric = T, wpath=wpath)
        vwc_fc <- get.geotop.inpts.keyword.value("FieldCapacity", numeric = T, wpath=wpath)
        vwc_s <-  get.geotop.inpts.keyword.value("ThetaSat", numeric = T, wpath=wpath)
        alpha <-  get.geotop.inpts.keyword.value("AlphaVanGenuchten", numeric = T, wpath=wpath) 
        n <-      get.geotop.inpts.keyword.value("NVanGenuchten", numeric = T, wpath=wpath)
        soil_input <- data.frame(Dz,Kh,Kv,vwc_r,vwc_w,vwc_fc,vwc_s,alpha,n)
      }
      
      # output depth in mm
      soil_head <- diff(c(0,cumsum(soil_thickness)))/2 + c(0,cumsum(soil_thickness))[-length(soil_thickness)-1]
      
      # soil moisture content liquid, soil moisture content ice, ...
      # add liquid and ice water content
      if ("SoilLiqContentProfileFile" %in% soil_output_files & "SoilIceContentProfileFile" %in% soil_output_files &
          "SoilLiqContentProfileFile" %in% keywords & "SoilIceContentProfileFile" %in% keywords) {
        
        soil_file_liq <- get.geotop.inpts.keyword.value(keyword="SoilLiqContentProfileFile", wpath=wpath, level=level[i], data.frame=TRUE)
        names(soil_file_liq)[7:length(soil_file_liq)] <-  paste(substr("SoilLiqContentProfileFile",1,14), soil_head, sep="")
        
        soil_file_ice <- get.geotop.inpts.keyword.value(keyword="SoilIceContentProfileFile", wpath=wpath, level=level[i], data.frame=TRUE)
        names(soil_file_ice)[7:length(soil_file_ice)] <-  paste(substr("SoilIceContentProfileFile",1,14), soil_head, sep="")
        
        soil_file_tot <- soil_file_liq[,7:length(soil_file_liq)] + soil_file_ice[,7:length(soil_file_ice)]
        names(soil_file_tot) <-  paste("TotalSoilWaterContent", soil_head, sep="")
        soil_file_tot <- data.frame(soil_file_liq[,1:6],soil_file_tot)
        
        out_df <- 
          out_df %>% 
          dplyr::left_join(as.data.table(soil_file_liq[,-1])) %>% 
          dplyr::left_join(as.data.table(soil_file_ice[,-1]))%>% 
          dplyr::left_join(as.data.table(soil_file_tot[,-1]))
        
        soil_output_files <- soil_output_files[-c(grep("SoilLiqContentProfileFile",soil_output_files),grep("SoilIceContentProfileFile",soil_output_files))]
        
      }
      
      for (i in soil_output_files) {
        if (i %in% keywords)
        {
          soil_file <- get.geotop.inpts.keyword.value(keyword=i, wpath=wpath, data.frame=TRUE)
          soil_header <- paste(substr(i,1,14), soil_head, sep="")
          names(soil_file)[7:length(soil_file)] <- soil_header
          
          out_df <- 
            out_df %>% 
            dplyr::left_join(as.data.table(soil_file[,-1]))
        }
      }
    }
    # zoo object
    out[[i]] <- zoo(out_df[,-c(1:5)], time(point_data))  
  }
  # out_data=list(out,length(xpoints))
  
  # save or not    
  if(save_rData) save(list = "out", file = file.path(wpath,"PointOut.RData"))
  return(out)
}
