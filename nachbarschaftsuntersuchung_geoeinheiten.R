library(RCurl)
library(rgrass7)
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))

geounits<-sqlite_df("/media/fabs/Volume/Data/GRASSDATA/SUEDTIROL_DTM_NEU/EPPAN_parentmaterial/sqlite/sqlite.db",vector="geounits_neigh")
geounits_neigh2<-sqlite_df("/media/fabs/Volume/Data/GRASSDATA/SUEDTIROL_DTM_NEU/EPPAN_parentmaterial/sqlite/sqlite.db",vector="geounits_neigh_2")
names(geounits_neigh)
geomorphlegende <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/geomorphologie_legende"),header=T, sep="\t")
geounits <- merge(geounits,geomorphlegende,by.x="geounit", by.y="geomorph")


#JETZT BRAUCH ICH ENGLISCHE legende
