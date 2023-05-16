

# straincheckfinal
setwd('/Users/cuijiajun/Desktop/strainchecks/inputforRmodified17/')
list <- list.files()
nor <- data.frame()
#savepath='/Users/cuijiajun/Desktop/strainchecks/imgs/imgsnomodified/'
#nor$X1stminfreq
savepath='/Users/cuijiajun/Desktop/strainchecks/imgs/imgsmodified17/'
library(ggplot2)
for(i in list){
  path <- i
  nor <-read.table(path,header = T)
  name=strsplit(i,'_straincheckmodified')[[1]][1]
  ggplot(data = nor,aes(nor$modifiedfreq))+geom_histogram(aes(y = after_stat(count / sum(count))))+scale_y_sqrt()+ggtitle(name)#the proportion y axis
  ggsave(paste(savepath,'100newhistsqrt/',name,'.png',sep='_'))
}
