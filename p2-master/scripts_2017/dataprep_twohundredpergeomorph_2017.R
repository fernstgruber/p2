#datapreparation
setwd("/home/fabs/Data/paper2_lenny/data_paper2/data2017/")
load("/home/fabs/Data/paper2_lenny/data_paper2/geotopodata_hundredpergeomorph.RData")
rm(modeldata)
hundredpergeomorph <-  read.table("/home/fabs/Data/paper2_lenny/data_paper2/twohundredpergeomorph.csv",sep=",",header=T)
dependents <- c("Basisbodenkarte_gebiet1","geologie_JAPT", "geomorph_gebiet1")
geocode <- read.table("/home/fabs/Data/paper2_lenny/scripts_paper2/geogenesecode.csv",sep="\t",header=T)
geodata <- merge(hundredpergeomorph,geocode,by.x="geologie_JAPT",by.y="NUMEROGIS")
geomorphcode <-  read.table("/home/fabs/Data/paper2_lenny/scripts_paper2/geomorphologie_legende",sep="\t",header=T)
names(geomorphcode) <- c("geomorphologie_beschreibung","geomorph")
geodata <- merge(geodata,geomorphcode,by.x="geomorph_gebiet1", by.y="geomorph")
geodata$geomorphologie_beschreibung <- droplevels(geodata$geomorphologie_beschreibung)
sqlite_df <- function(dbpath,vector){
  require(RSQLite)
  drv <- dbDriver("SQLite")
  con <- dbConnect(drv, dbname = dbpath)
  statement= paste("SELECT * FROM '",as.character(vector),"'",sep="")
  df<- dbGetQuery(con,statement)
  return(df)
}
newdata1 <- sqlite_df(dbpath = "/home/fabs/Data/paper2_lenny/data_paper2/data2017/sqlite_vhr_TRI_TEXTURE_test/vhr_vhr_TRI_TEXTURE.db",vector="twohundredpergeomorph_vhr_TRI_TEXTURE")
names(newdata1)
vhrcols <- names(newdata1)[c(4:12,37:43)]
###ACHTUNG!!!!! hier noch schaun wo) sagatopo ist!
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
geomcols_10m %in% names(geodata)  #TRUE
TPIcols_10m %in% names(geodata)  #TRUE
sagacols_50m %in% names(geodata)  #TRUE
terraincols_50m %in% names(geodata)  #TRUE
absheight <- "DTM_50m_avg" #TRUE
geomcols_50m %in% names(geodata)  #TRUE
allterraincols <- c(terraincols_50m,terraincols_hr,TPIcols_10m,sagacols_50m)
localterraincols<- allterraincols[c(1:126,157:163,165,167:170,172,174,177,184:187,189,191:192,194:195,197,199)]
regionalterraincols <- allterraincols[c(127,156,164,166,171,173,176,179:182,188,190,193,196,198,200)]
#roughnesscols ist Texture (allterraincols175) dabei?; 178 ist heights,deprression brauchmaned, 
roughnesscols <- c(roughnesscols_hr,allterraincols[175])
allgeoms <- c(geomcols_10m,geomcols_50m)
paramsets <- list(allterraincols,localterraincols,regionalterraincols,rlicols,roughnesscols,heights,
                  allgeoms,vhrcols)
geodata <- merge(geodata,newdata1[c("ID",vhrcols)],by="ID",all.x=TRUE)
paramsetnames <-c("allterraincols","localterrain", "regionalterrain","rlicols","roughnesscols","heights",
                  "allgeoms","vhrcols") 
allpreds <- c(rlicols,terraincols_hr,roughnesscols_hr,heights,
              geomcols_10m,TPIcols_10m,sagacols_50m,terraincols_50m,
              geomcols_50m,absheight,vhrcols)
modeldata <- geodata[c("ID",dependents,geospalten,allpreds)]


save(modeldata,geospalten,allpreds,paramsets,paramsetnames,rlicols,terraincols_hr,roughnesscols_hr,heights,
    geomcols_10m,TPIcols_10m,sagacols_50m,terraincols_50m,
     geomcols_50m,absheight,file="geotopodata_twohundredpergeomorph_2017.RData")

