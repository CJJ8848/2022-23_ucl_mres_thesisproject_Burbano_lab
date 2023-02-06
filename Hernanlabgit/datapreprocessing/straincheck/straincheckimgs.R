


# straincheckfinal
setwd('/Users/cuijiajun/Desktop/strainchecks/inputforRmodified/')
list <- list.files()
nor <- data.frame()
savepath='/Users/cuijiajun/Desktop/strainchecks/imgs/'
library(ggplot2)
for(i in list){
  path <- i
  nor <-read.table(path,header = T)
  ggplot(data = nor,aes(nor$modifiedfreq))+geom_histogram()+ggtitle(i)
  ggsave(paste(savepath,i,'.png',sep='_'))
  noro<-subset(nor,nor$modifiedfreq!=0)
  ggplot(data = noro,aes(noro$modifiedfreq))+geom_histogram()+ggtitle(i)
  ggsave(paste(savepath,i,'nozero.png',sep='_'))
  #scaled to 1
  ggplot(data = nor,aes(nor$modifiedfreq))+geom_histogram(aes(y=..ndensity..))+ggtitle(i)
  ggsave(paste(savepath,i,'scaledto1.png',sep='_'))
}
