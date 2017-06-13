###############################################################################################################
# Vorbereitung in GRASS:                                                                                      #
#location= "SUEDTIROL_DTM_NEU"                                                                                #
#mapset="EPPAN_parentmaterial"                                                                                #
# r.to.vect input=gebiet1_parentmaterial_geomorph output=geounits type=area column=geounit                    #
#                                                                                                             #
#inside GRASS with ipython                                                                                    #
#import os                                                                                                    #
#vector=geounits                                                                                              #
#os.system('v.category %s output=%s_neigh layer=2 type=boundary option=add'%(vector,vector))                  #
#os.system('v.db.addtable %s_neigh layer=2 col="left integer,right integer"'%(vector))                        #
#os.system('v.to.db map=%s_neigh option=sides columns=left,right layer=2'%(vector))                           #
#os.system('v.db.addcolumn %s_neigh layer=2 col="length double precision"'%(vector))                          #
#os.system('v.to.db map=%s_neigh option=length columns=length layer=2'%(vector))                              #
#                                                                                                             #
###############################################################################################################
library(RCurl)
library(rgrass7)
library(repmis)

myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
temp <- tempfile()
####aLTE VARIANTE
#download.file(destfile=temp,url="https://github.com/fernstgruber/p2/blob/master/data2017/sqlite_EPPAN_parentmaterial/sqlite.db?raw=true",method="wget")
#geounitsold<-sqlite_df(temp,vector="geounits_neigh")
#geounits_neighbors<-sqlite_df(temp,vector="geounits_neigh_2")
#geounits_neighbors <- geounits_neighbors[c("left","right","length")]
#rm(temp)
download.file(destfile=temp,url="https://github.com/fernstgruber/p2/blob/master/data2017/sqlite_p2_clip/sqlite.db?raw=true",method="wget")
geounits<-sqlite_df(temp,vector="SGUforborders_neigh")
geounits_neighbors<-sqlite_df(temp,vector="SGUforborders_neigh_2")
geounits_neighbors <- geounits_neighbors[c("left","right","length")]
rm(temp)

#geomorphlegende <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/geomorphologie_legende"),header=T, sep="\t")
geolegendeng <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/geolegendeng.txt"),sep="\t",header=T)
names(geolegendeng) <- c("geounit_eng","Abbrev.","short.description","geomorphologie_deutsch","code")
#geounits <- merge(geounits,geomorphlegende,by.x="geounit", by.y="geomorph")
#source_data("https://github.com/fernstgruber/p2/blob/master/data2017/geoeinheitenlegende.RData?raw=true")
geounits <- merge(geounits,geolegendeng,by.x="value", by.y="code",all.x=TRUE)
geounits_min <- geounits[c("cat","Abbrev.")]
geounits_neighbors <- merge(geounits_neighbors,geounits_min, by.x="left",by.y="cat",all.x=T)
names(geounits_neighbors) <- c(names(geounits_neighbors)[1:3], "Abbr_left")
geounits_neighbors <- merge(geounits_neighbors,geounits_min, by.x="right",by.y="cat",all.x=T)
names(geounits_neighbors)[5] <- "Abbr_right"
geounits_neighbors<- na.omit(geounits_neighbors)
geounits_neighbors$bordertype <- as.factor(paste(geounits_neighbors$Abbr_left,"_vs_",geounits_neighbors$Abbr_right))
borderlength <- as.data.frame(tapply(X=geounits_neighbors$length, INDEX=geounits_neighbors$bordertype,FUN=sum))
#write.table(borderlength,file="/home/fabs/Downloads/p2-master/results_2017/borderlength_newshape_16uhr.txt",sep="\t",row.names=T)

#####inzwischen in excel bearbeiten und summen der geoeinheiten berechnen, dann
bordertable <- read.table("/home/fabs/Data/paper2_lenny/results_2017/sgu_borderlengths.txt",sep="\t",header=T,row.names = 1)
bordertable <- bordertable/1000
percentable <- bordertable/sum(bordertable,na.rm=T)*100
require(xtable)
xtable(bordertable,caption = "Length in kilometers of the borders of adjacent SGUs",label = "table:borderlength",digits = 1)
xtable(percentable,caption = "Percent of the borders of adjacent SGUs",label = "table:borderlength",digits = 2)
