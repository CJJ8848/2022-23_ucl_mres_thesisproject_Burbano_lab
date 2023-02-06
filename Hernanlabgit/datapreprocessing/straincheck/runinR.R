#conda activate R
setwd('/SAN/ugi/plant_genom/jiajucui/datapreprocessing/straincheck/inputforR')
list <- list.files()
data <- data.frame()
print('initilized done')
for(i in list){
  path <- i
  print(i)
  datashort <-read.table(path,header = T)
  datashort$firstmin=999
  datashort$secondmin=999
  datashort$firstminfreq=999
  datashort$motified_1stfreq=999
  ##1stmini and 2ndmini
  #first situation:
  #when depth is equal to ref, then the minimum alter frequency should be 0
  firstsit<-datashort[which(datashort$depth==datashort$ref),]
  firstsit$firstmin<-0
  firstsit$secondmin<-0
  firstsit$firstminfreq<-0
  firstsit$motified_1stfreq<-0
  
  #second situation:
  #when depth is not equal to ref, means there is alt, then the freq should be the min among 4 alts
  secondsit<-datashort[which(datashort$depth!=datashort$ref),]
  #replace 0 with 999 to calculate the min among nonzero values
  secondsit[which(secondsit$A==0),]$A<-999
  secondsit[which(secondsit$C==0),]$C<-999
  secondsit[which(secondsit$G==0),]$G<-999
  secondsit[which(secondsit$T==0),]$T<-999
  
  for (i in 1:nrow(secondsit)){
    #calculate first minimum among alts
    secondsit[i,]$firstmin<-min(secondsit[i,]$A,secondsit[i,]$C,secondsit[i,]$G,secondsit[i,]$T)
    #calculate second minimum via subtract ref and first min by depth
    secondsit[i,]$secondmin<-secondsit[i,]$depth-secondsit[i,]$ref-secondsit[i,]$firstmin
    #freq=min/depth
    secondsit[i,]$firstminfreq<-secondsit[i,]$firstmin/secondsit[i,]$depth
  }
  #modify_1stfreq modify freq that above 0.5 to below.
  # the mean is the same, like 0.25 means the third strains (other than 0&1 and 1/2)
  secondsit$motified_1stfreq<-secondsit$firstminfreq
  secondsit[which(secondsit$firstminfreq > 0.5 & secondsit$firstminfreq < 1),]$motified_1stfreq <- 1-secondsit[which(secondsit$firstminfreq > 0.5 & secondsit$firstminfreq < 1),]$firstminfreq
  
  #rbind two situations
  finaldatashort<-rbind(firstsit,secondsit)
  finaldatashort[finaldatashort==999]<-0
  write.table(finaldatashort, file =paste("/SAN/ugi/plant_genom/jiajucui/datapreprocessing/straincheck/outputfromR/",path,'straincheckfromR.txt', sep='_'), sep =" ", row.names =F, col.names =TRUE, quote =F)
  
  #data visualization
  
  #ggplot(data = finaldatashort,aes(finaldatashort$motified_1stfreq))+geom_histogram(aes(y=..ndensity..))+ggtitle(i)
  #ggsave(paste(i,'hist.png'))
  #ggplot(data = finaldatashort,aes(finaldatashort$motified_1stfreq))+geom_density(aes(y=..ndensity..))+ggtitle(i)
  #ggsave(paste(i,'density.png'))
}
