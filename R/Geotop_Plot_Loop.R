# GEOtop_Plot_loop
# function to plot as .jpeg same outputs of several points

# ARGUMENTS
# point       point to be plotted
# model_run   multiple points outptut data (as zoo)
# input_variables     number of point outptut
# name        base name of files


GEOtop_Plot_loop<-function(point,out,input_variables,name="myplot"){

  lastname=paste0(name,as.character(point),".jpeg")
  out_new <- out[[point]] 

mydata <- out_new[,input_variables] 
mydata_df<-data.frame(date=index(mydata),mydata)

p<-ggplot(data = mydata_df,mapping = aes(x =date,y=mydata_df[input_variables[1]]) )+
  geom_line()+
  geom_line(aes(y=mydata_df[input_variables[2]]),color="blue")+
  geom_line(aes(y=mydata_df[input_variables[3]]),color="red")
p
ggsave(plot = p,filename = file.path(wpath ,"out",lastname),device = "jpeg")

}




