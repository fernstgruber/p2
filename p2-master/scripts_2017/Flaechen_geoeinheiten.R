require(rgrass7)
source("/home/fabs/Data/paper1_lenny/fabians_and_rossiters_functions.R")
setwd("/home/fabs/Data/paper2_lenny/data_paper2/data2017/")
load("geounits_UE_df_2017.RData")
require(rgdal)
##FLAECHE DER GEOEINHEITEN
geotable <- table(bodenkarten_df$geomorph_gebiet1)
geotable_df <-  as.data.frame(geotable)
geomorphlegende <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/geomorphologie_legende",sep="\t",header=T)
geotable_df <- merge(geotable_df,geomorphlegende,by.x="Var1",by.y="geomorph",all.x=T)
geotable_df$area <- geotable_df$Freq*2.5*2.5
geotable_df
############################FLAECHE AUS AKTUELLEM SHAPE
shape<-readOGR(dsn="/home/fabs/Data/paper2_lenny/GIS_p2/shapefiles/SGU.shp", layer="SGU")
data <- shape@data
data <- merge(data,geomorphlegende,by.x="value",by.y="geomorph",all.x=T)
table <- tapply(data$area,INDEX=data$geomorphologie,FUN=sum)
write.table(as.data.frame(table),file="sgu_area_fromshape.txt",sep="\t")
sum(data$area)
##DASPASSTGARNED!!!!!!!!!!!!!!
###AUSGRASS MIT NEUEM SHAPE
sgu <- sqliteGRASS(location="SUEDTIROL_DTM_NEU",mapset="p2_clip",vector="SGU")
sguarea <- as.data.frame(tapply(sgu$area_grass,INDEX=sgu$value,FUN=sum))


gisBase="/usr/local/src/grass70_release/dist.x86_64-unknown-linux-gnu"
gisDbase =  "/home/fabs/Data/GRASSDATA/"
location="SUEDTIROL_DTM_NEU"
mapset="p2_clip"
initGRASS(gisBase = gisBase,gisDbase = gisDbase,location=location,mapset=mapset,override = TRUE)
sgu_df<- readRAST("SGU")
sgu_df_data <- na.omit(sgu_df@data)
geotable <- table(sgu_df_data$SGU)
geotable_df <-  as.data.frame(geotable)
geomorphlegende <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/geomorphologie_legende",sep="\t",header=T)
geotable_df <- merge(geotable_df,geomorphlegende,by.x="Var1",by.y="geomorph",all.x=T)
geotable_df$area <- geotable_df$Freq*2.5*2.5
geotable_df
# IM GRASS PASSTS
