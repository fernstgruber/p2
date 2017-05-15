###############################################################################################################
# Vorbereitung in GRASS:                                                                                      #
#location= "SUEDTIROL_DTM_NEU"                                                                                #
#mapset="EPPAN_parentmaterial"                                                                                #
# r.to.vect input=gebiet1_parentmaterial_geomorph output=geounits type=area column=geounit                    #
#                                                                                                             #
#inside GRASS with ipython                                                                                    #
#import os                                                                                                    #
#os.system('v.category %s output=%s_neigh layer=2 type=boundary option=add'%(vector,vector))                  #
#os.system('v.db.addtable %s_neigh layer=2 col="left integer,right integer"'%(vector))                        #
#os.system('v.to.db map=%s_neigh option=sides columns=left,right layer=2'%(vector))                           #
#                                                                                                             #
###############################################################################################################
library(RCurl)
library(rgrass7)
library(repmis)

myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))

geounits<-sqlite_df("/media/fabs/Volume/Data/GRASSDATA/SUEDTIROL_DTM_NEU/EPPAN_parentmaterial/sqlite/sqlite.db",vector="geounits_neigh")
geounits_neigh2<-sqlite_df("/media/fabs/Volume/Data/GRASSDATA/SUEDTIROL_DTM_NEU/EPPAN_parentmaterial/sqlite/sqlite.db",vector="geounits_neigh_2")
geomorphlegende <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/geomorphologie_legende"),header=T, sep="\t")
geounits <- merge(geounits,geomorphlegende,by.x="geounit", by.y="geomorph")
source_data("https://github.com/fernstgruber/p2/raw/master/data2017/geoeinhetenlegende.RData?raw=True")
names(geounits)
geounits <- merge(geounits,geolegendeng,by.x="geomorphologie", by.y="geomorphologie_beschreibung",all.x=TRUE)
geounits <- geounits[c("cat","Abbrev.")]
