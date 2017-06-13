#datapreparation
setwd("/home/fabs/Data/paper2_lenny/data_paper2")
load("geotopodata_hundredpergeomorph.RData")
rm(modeldata)
hundredpergeomorph <-  read.table("/home/fabs/Data/paper2_lenny/data_paper2/twohundredpergeomorph.csv",sep=",",header=T)
dependents <- c("Basisbodenkarte_gebiet1","geologie_JAPT", "geomorph_gebiet1")
geocode <- read.table("/home/fabs/Data/paper2_lenny/scripts_paper2/geogenesecode.csv",sep="\t",header=T)
geodata <- merge(hundredpergeomorph,geocode,by.x="geologie_JAPT",by.y="NUMEROGIS")
geomorphcode <-  read.table("/home/fabs/Data/paper2_lenny/scripts_paper2/geomorphologie_legende",sep="\t",header=T)
names(geomorphcode) <- c("geomorphologie_beschreibung","geomorph")
geodata <- merge(geodata,geomorphcode,by.x="geomorph_gebiet1", by.y="geomorph")
geodata$geomorphologie_beschreibung <- droplevels(geodata$geomorphologie_beschreibung)
###ACHTUNG!!!!! hier noch schaun wo sagatopo ist!
hrcols <- names(geodata)[c(241,442:451)]
for (i in hrcols){
  geodata[[paste(i,"_hr",sep="")]] <- geodata[[i]]
}
geodata <- geodata[!(names(geodata) %in% hrcols)]
extradata <- read.table("/home/fabs/Data/paper2_lenny/data_paper2/twohundredpergeomorph_res10m.csv",sep=",",header=T)
geodata <- merge(geodata,extradata,by="ID")
geospalten <- c("geomorphologie_beschreibung","Lithologie","Textur","Festgestein")
rlicols %in% names(geodata) #TRUE
terraincols_hr %in% names(geodata) #TRUE
terraincols_hr <- terraincols_hr[terraincols_hr %in% names(geodata)]
roughnesscols_hr %in% names(geodata) #TRUE
heights %in% names(geodata) #TRUE
############hierweitermachen
geomcols_10m %in% names(geodata)  #TRUE
TPIcols_10m %in% names(geodata)  #TRUE
sagacols_50m %in% names(geodata)  #TRUE
terraincols_50m %in% names(geodata)  #TRUE
absheight <- "DTM_50m_avg" #TRUE
geomcols_50m %in% names(geodata)  #TRUE

allterraincols <- c(terraincols_50m,terraincols_hr,TPIcols_10m,sagacols_50m)
allgeoms <- c(geomcols_10m,geomcols_50m)

paramsets <- list(allterraincols,rlicols,roughnesscols_hr,heights,
                  allgeoms)
#badones200 <- vector()
#for (p in paramsets){ 
#  for(pp in unlist(p)){
#    if(nrow(geodata[is.na(geodata[[pp]]),]) > 10) {
#      badones200 <-c(badones200,pp)
#    }
#  }
#}
#save(badones200,file="badones200.RData")

load("badones200.RData")
allterraincols <- allterraincols[!(allterraincols %in% badones200)]
rlicols <-rlicols[!(rlicols %in% badones200)]
roughnesscols_hr <- roughnesscols_hr[!(roughnesscols_hr %in% badones200)]
paramsets <- list(allterraincols,rlicols,roughnesscols_hr,heights,
                  allgeoms)
paramsetnames <-c("allterraincols","rlicols","roughnesscols_hr","heights",
                  "allgeoms") 
allpreds <- c(rlicols,terraincols_hr,roughnesscols_hr,heights,
              geomcols_10m,TPIcols_10m,sagacols_50m,terraincols_50m,
              geomcols_50m,absheight)
modeldata <- geodata[c(dependents,geospalten,allpreds)]


save(modeldata,geospalten,allpreds,paramsets,paramsetnames,rlicols,terraincols_hr,roughnesscols_hr,heights,
     geomcols_10m,TPIcols_10m,sagacols_50m,terraincols_50m,
     geomcols_50m,absheight,file="geotopodata_twohundredpergeomorph.RData")