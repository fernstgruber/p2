library(RCurl)
library(rgrass7)
library(repmis)
require(xtable)
myfunctions <- getURL("https://raw.githubusercontent.com/fernstgruber/Rstuff/master/fabiansandrossitersfunctions.R", ssl.verifypeer = FALSE)
eval(parse(text = myfunctions))
geogenesecode <-  read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/geogenesecode_2017.csv"),header=T, sep="\t")
substratgenesecode <-  read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/substratgenesecode_ohneleerzeichn_2017.csv"),header=T, sep=",")
boden <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/Gebiet1_bodenprofile_ohnedoppelte_2017.csv"),header=T, sep="\t")
profilpunkte <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/Profilpunkte_p2.csv"),header=T, sep=",")
geolegendeng <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/geolegendeng.txt"),sep="\t",header=T)
thalheimer <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/ueberetsch_profile_thalheimer_2017.csv"),sep="\t",header=T)
thalheimer_AGM <- thalheimer[c("Nr","AGM_thal","geomorphologie_kart_thalheimer")]
wlm_AGM <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/wlm_AGM_2107.csv"),sep="\t",header=T)
rebo_AGM_geomorph <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/rebo_AGM_geomorphologie.csv"),sep="\t",header=T)
rebo_AGM <- rebo_AGM_geomorph[,1:2]
names(rebo_AGM) <- c("ID","geomorphologie_kart_rebo")
forstdb_AGM <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/forstdb_AGM.csv"),sep="\t",header=T)
geolegende <- read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/wiedergeotest.csv"),sep=";",header=T,stringsAsFactors = F)
boden <- merge(x=boden,y=geolegende,by.x="gebiet1_parentmaterial_numerogis",by.y="NUMEROGIS",all.x=T)
boden$Beschreibung <- as.factor(boden$Beschreibung)
boden <-droplevels(boden)
bbundhoehe <-  read.table(text=getURL("https://raw.githubusercontent.com/fernstgruber/p2/master/data2017/chemiereferenzpunkte_bbundhoehenstufe_2017.txt"),sep=",",header=T)
bbundhoehe <- bbundhoehe[c("ID","bodenbedeckung","hoehenstufen")]
boden<- merge(boden,bbundhoehe,by="ID",all.x=T )
summary(boden)
#################################################################################################################                                                          
#ERSTELLEN VON KONTINGENZTABELLEN                                                                               # 
#################################################################################################################
tabelle_bodentypen_red_vs_geomorph <- as.data.frame.matrix(table(boden$geomorphologie_beschreibung,boden$TYP)) #
#write.table(tabelle_bodentypen_red_vs_geomorph,file="tabelle_bodentyp_red_vs_geomorph")                        #
#                                                                                                               #
tabelle_bodentypen_diff_vs_geomorph <- as.matrix(table(boden$geomorphologie_beschreibung,boden$TYP))           #
#write.table(tabelle_bodentypen_diff_vs_geomorph,file="tabelle_bodentyp_diff_vs_geomorph")                      #
#                                                                                                               #
tabelle_bodentypen_detailliert <- as.matrix(table(boden$Beschreibung,boden$TYP))                               #
#write.table(tabelle_bodentypen_detailliert,file="tabelle_bodentypen_detailliert",sep=";")                      #
tabelle_bodentypen_detailliert#                                                                                                               #  
####add substrate data and cover layer where available/existent for wlmpoints                                   #


#boden <- merge(boden,wlm_subst,by.x="ID",by.y="IDENT",all.x=T)                                                 #
#################################################################################################################
boden <- merge(boden,forstdb_AGM,by.x="ID",by.y="AufID",all.x=T)
boden <- merge(boden,wlm_AGM,by.x="ID",by.y="IDENT",all.x=T)
boden <- merge(boden,rebo_AGM,by="ID",all.x=T)
boden <- merge(boden,thalheimer_AGM,by.x="ID",by.y="Nr",all.x=T)
kartiert_wlm <- !(is.na(boden$geomorphologie_kart_wlm))
boden[kartiert_wlm,"geomorphologie_kartiert"] <- as.character(boden$geomorphologie_kart_wlm[kartiert_wlm])
kartiert_forst <- !(is.na(boden$geomorphologie_kart_forstdb))
boden[kartiert_forst,"geomorphologie_kartiert"] <- as.character(boden$geomorphologie_kart_forst[kartiert_forst])
kartiert_rebo <- !(is.na(boden$geomorphologie_kart_rebo))
boden[kartiert_rebo,"geomorphologie_kartiert"] <- as.character(boden$geomorphologie_kart_rebo[kartiert_rebo])
kartiert_thal <- !(is.na(boden$geomorphologie_kart_thalheimer))
boden[kartiert_thal,"geomorphologie_kartiert"] <- as.character(boden$geomorphologie_kart_thalheimer[kartiert_thal])
boden$geomorphologie_kartiert <- as.factor(boden$geomorphologie_kartiert)
levels(boden$geomorphologie_kartiert)
levels(boden$geomorphologie_beschreibung)
levels(boden$geomorphologie_kartiert) %in% levels(boden$geomorphologie_beschreibung)
summary(boden$geomorphologie_kartiert)

geomorphologieundboden <- boden[c("ID","geomorphologie_kartiert","geomorphologie_beschreibung")]
#legende_kartierer_gegen_karte <- read.table("legede_kartierer_gegen_karte.txt",sep="\t",header=T)
geomorphologieundboden <- merge(geomorphologieundboden,geolegendeng,by.x="geomorphologie_kartiert",by.y="geomorphologie_deutsch",all.x=T)
names(geomorphologieundboden) <- c("geomorphologie_kartiert","ID","geomorphologie_beschreibung","geounit_kart","geomorphologieklasse_kurz_kartiert","short.description_kart","code_kart")
geomorphologieundboden <- merge(geomorphologieundboden,geolegendeng,by.x="geomorphologie_beschreibung",by.y="geomorphologie_deutsch",all.x=T)
names(geomorphologieundboden) <- c("geomorphologie_beschreibung","geomorphologie_kartiert","ID","geounit_kart","geomorphologieklasse_kurz_kartiert","short.description_kart","code_kart","geounit_gk","geomorphologieklasse_kurz_gk","short.description_gk","code_gk")
kartierergegenkarte<-  as.data.frame.matrix(table(geomorphologieundboden$geomorphologieklasse_kurz_kartiert,geomorphologieundboden$geomorphologieklasse_kurz_gk))
