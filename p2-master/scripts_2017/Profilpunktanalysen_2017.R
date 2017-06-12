setwd("/home/fabs/Data/paper2_lenny/data_paper2/data2017/")
require(xtable)
source("/home/fabs/Data/paper1_lenny/fabians_and_rossiters_functions.R")
substratgenesecode <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/substratgenesecode_ohneleerzeichn.csv",header=T, sep=",")
geogenesecode <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/geogenesecode.csv",header=T, sep="\t")
legende_kartierer_gegen_karte <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/legede_kartierer_gegen_karte_04042017.txt",sep="\t",header=T)
geounitlegend <- legende_kartierer_gegen_karte[,3:4]


geounitdescription <- c("recent and pleistocenic deposits of silt, sand and gravels",
                        "footslope deposits",
                        "limestones and dolomites",
                        "recent conic deposits from debris flows and gulleys",
                        "(fine) sand deposits with dropstones",
                        "clast-supported gravels",
                        "silt- and sandstones",
                        "recent and pleistocenic silt and peat deposits",
                        "pleistocenic deposits from debris flows and gulleys","rhyolite and rhyodazite tuffs and ignimbrites",
                        "recent and pleistocenic blocky deposits",
                        "recent and pleistocen debris on slopes",
                        "compacted sub-glacial sediment",
                        "sandstones and siltstones",
                        "undifferentiated glacial sediment")
geounitlegend[,3] <- geounitdescription
names(geounitlegend) <- c("geounit","Abbrev.","short description")
geounitlegend
xtable(geounitlegend,caption = "Table of the generalised parent material geounits with abbreviations and a short description.",label="geounits")
##########################################################
thalheimer <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/ueberetsch_profile_thalheimer.csv",sep="\t",header=T)
thalheimer_AGM <- thalheimer[c("Nr","AGM_thal","geomorphologie_kart_thalheimer")]
##########################################################
wlm <- sqliteGRASS(location="projtestepsg3003_northing",mapset = "fabs",vector = "eich2007_gelaende")
wlmpunkte <- unique(wlm$IDENT)
wlm_subst<-wlm[c("IDENT","SUBST1","DECK")]
summary(wlm_subst$DECK)
wlm_subst$AGM <-ifelse(wlm_subst$DECK %in% c("","-"),wlm_subst$SUBST1,wlm_subst$DECK)
wlm_subst <- merge(wlm_subst,substratgenesecode,by.x="AGM",by.y="Kurz_NT",all.x=T)
wlm_AGM <- wlm_subst[c("IDENT","AGM","geomorphologie")]
names(wlm_AGM) <- c("IDENT","AGM_wlm","geomorphologie_kart_wlm")
wlm_AGM[wlm_AGM$IDENT == "qa01","geomorphologie_kart_wlm"] <- "Alluviale Ablagerung"
#######################################################
rebo_AGM_geomorph <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/rebo_AGM_geomorphologie.csv",sep="\t",header=T)
rebo_AGM <- rebo_AGM_geomorph[,1:2]
names(rebo_AGM) <- c("ID","geomorphologie_kart_rebo")
#######################################################
standort <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/STANDORT.csv",sep=",",header=T)
aufnahme <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/AUFNAHMEN.csv",sep=",",header=T)
bodendeflist<- read.table("/home/fabs/Data/paper2_lenny/data_paper2/bodentyp_deflist.csv",sep="\t",header=T)
names(bodendeflist) <- paste(names(bodendeflist),"_bod",sep="")
substratdeflist<-read.table("/home/fabs/Data/paper2_lenny/data_paper2/substrat_deflist.csv",sep="\t",header=T)
names(substratdeflist) <- paste(names(substratdeflist),"_sub",sep="")
deckdeflist<-read.table("/home/fabs/Data/paper2_lenny/data_paper2/substrat_deflist.csv",sep="\t",header=T)
names(deckdeflist) <- paste(names(deckdeflist),"_deck",sep="")
humusformdeflist <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/humusform_deflist.csv",sep="\t",header=T)
names(humusformdeflist) <- paste(names(humusformdeflist),"_hum",sep="")
forstdb<-merge(standort,aufnahme,by="AufID")
forstdb_humus <- merge(forstdb,humusformdeflist,by.x="Humus", by.y="Code_hum",all.x=T)
forstdb_humus <- forstdb_humus[c("AufID","Bezeichnung_hum")]
forstdb_humus <- forstdb_humus[order(forstdb_humus$AufID),]
#write.table(forstdb_humus,file="forstdb_humus")
forstdb_humus$Bezeichnung_hum[forstdb_humus$AufID == 12857]
forst_geomorph <- forstdb[c("AufID","DeckSchi","Subst","SubstBod")]
na_deck <- forst_geomorph[(is.na(forst_geomorph$DeckSchi) || forst_geomorph$DeckSchi==0),] 
o_deck <- forst_geomorph$DeckSchi== 0
forst_geomorph$Substausdeck <- ifelse(forst_geomorph$DeckSchi %in% c(NA,0),forst_geomorph$Subst,forst_geomorph$DeckSchi)
forst_geomorph<- merge(forst_geomorph,substratgenesecode,by.x="Substausdeck",by.y="substrat_code",all.x=T)
forst_geomorph$AGM <- forst_geomorph$Kurz_NT
forst_geomorph$geomorphologie_kart <- forst_geomorph$geomorphologie
forstdb_AGM <- forst_geomorph[c("AufID","AGM","geomorphologie_kart")]
names(forstdb_AGM) <-c("AufID","AGM_forstdb","geomorphologie_kart_forstdb")

#########################################################
boden <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/data2017/Gebiet1_bodenprofile_ohnedoppelte_2017.csv",sep="\t",header=T)
rebopunkte  <-  c("1_U","2_U","3_U","4_U","5_U","6_U","7_U","8_U","9_U","10_U","11_U","12_U","13_U","14_U","15_U","16_U","17_U",
                "18_U","19_U","20_U","21_U","22_U","23_U","24_U","25_U","26_U","27_U","28_U","29_U","30_U","31_U","32_U","33_U",
                "34_U","35_U","36_U","37_U","38_U","39_U","40_U","41_U","42_U","43_T","44_T","45_T","46_T","47_T","48_T",
                "49_T","50_T","51_T","52_T","53_T","54_T","55_T","56_T","57_T","58_T","59_T")
geolegende <-read.table("/home/fabs/Data/paper2_lenny/Docs_paper2/wiedergeotest.csv",sep=";",header=T,stringsAsFactors = F)
boden <- merge(x=boden,y=geolegende,by.x="gebiet1_parentmaterial_numerogis",by.y="NUMEROGIS",all.x=T)
boden$Beschreibung <- as.factor(boden$Beschreibung)
boden <-droplevels(boden)
str(boden)
#write.table(boden,"profilpunkts_mit_geo_2017.txt",sep=";",row.names=F)
bbundhoehe <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/chemiereferenzpunkte_bbundhoehenstufe.txt",sep=",",header=T)
bbundhoehe <- bbundhoehe[c("ID","bodenbedeckung","hoehenstufen")]
boden<- merge(boden,bbundhoehe,by="ID",all.x=T )
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

#hinzufügen von  forstdb_AGM, wlm_AGM zu "boden" data.frame

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
#save(boden,file="boden_UE_2017.RData")

geomorphologieundboden <- boden[c("ID","geomorphologie_kartiert","geomorphologie_beschreibung")]
geomorphologieundboden <- merge(geomorphologieundboden,legende_kartierer_gegen_karte,by.x="geomorphologie_kartiert",by.y="geomorphologieklasse",all.x=T)

names(geomorphologieundboden) <- c("geomorphologie_kartiert","ID","geomorphologie_beschreibung","geomorphologieklasse_kurz_kartiert","GKeng_kartiert","GKEK_kartiert")
geomorphologieundboden <- merge(geomorphologieundboden,legende_kartierer_gegen_karte,by.x="geomorphologie_beschreibung",by.y="geomorphologieklasse",all.x=T)
names(geomorphologieundboden) <- c("geomorphologie_beschreibung","geomorphologie_kartiert","ID","geomorphologieklasse_kurz_kartiert",
                                   "GKeng_kartiert","GKEK_kartiert","geomorphologieklasse_kurz_CARG","GKeng_CARG","GKEK_CARG")
kartierergegenkarte<-  as.data.frame.matrix(table(geomorphologieundboden$GKEK_kartiert,geomorphologieundboden$GKEK_CARG))
#write.table(kartierergegenkarte,file="kartierer_gegen_Karte_2017.txt",sep="\t")

xtable(kartierergegenkarte,caption="Tabular comparison of parent material geounits as observed by soil surveyor (rows) and in the geologic map",label="kartiergegenkarte")
#################################################################################################################                                                          
#terrain parameters of interest for geological units                                                                             # 
#################################################################################################################
tabelle_bodentypen_red_vs_geomorph <- as.data.frame.matrix(table(boden$geomorphologie_beschreibung,boden$TYP)) #
#write.table(tabelle_bodentypen_red_vs_geomorph,file="tabelle_bodentyp_red_vs_geomorph")                        #
#                                                                                                               #
tabelle_bodentypen_diff_vs_geomorph <- as.matrix(table(boden$geomorphologie_beschreibung,boden$TYP))           #
#write.table(tabelle_bodentypen_diff_vs_geomorph,file="tabelle_bodentyp_diff_vs_geomorph")                      #
#                                                                                                               #
tabelle_bodentypen_detailliert <- as.matrix(table(boden$Beschreibung,boden$TYP))                               #
#write.table(tabelle_bodentypen_detailliert,file="tabelle_bodentypen_detailliert",sep=";")                      #
#                                                                                                               #  
####add substrate data and cover layer where available/existent for wlmpoints                                   #


#boden <- merge(boden,wlm_subst,by.x="ID",by.y="IDENT",all.x=T)                                                 #
#################################################################################################################



#Interessnte Parameter für : Festgestein; 
geomorphons <- c("geom_DTM_50m_avg_fl8_L1500m","geom_DTM_50m_avg_fl10_L400m","geom_10m_fl10_L3","geom_DTM_50m_avg_fl10_L150m","geom_DTM_50m_avg_fl1_L1100m","geom_DTM_50m_avg_fl10_L300m")
rli <- c("geom_hr_L50m_fl10_r_li_dominance_UE_hr_40cells","geom_hr_L3m_fl10_r_li_dominance_UE_hr_40cells",
         "geom_hr_L3_fl1_r_li_richness_UE_hr_40cells","geom_hr_L3_fl10_r_li_richness_UE_hr_40cells",
         "geom_hr_L3_fl10_r_li_simpson_UE_hr_40cells","geom_hr_L50m_fl10_r_li_richness_UE_hr_40cells")
roughness <- c("TRI_hr_ws26","terraintexture_hr_ws57_tp5")
heights <- c("Maximum_Height_hr","Normalized_Height","Vertical_Distance_to_Channel_Network")
localterrain <- c("slope_DTM_50m_avg_ws7","Longitudinal_Curvature","Convexity","profc_DTM_50m_avg_ws7")
regionalterrain <- c("ChannelNetworkBaseLevel","VerticalDistancetoChannelNetwork","Channel_Network_Base_Level","TPI_i0m_o500m")

