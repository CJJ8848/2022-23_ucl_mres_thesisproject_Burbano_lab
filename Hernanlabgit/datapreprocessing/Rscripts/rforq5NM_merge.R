
samples=c('27.ESP_1975','30.ESP_1983b','33.ESP_1985b','34.ESP_1985c_S36','64.GBR_1933b_S36','75.LTU_1894_S30'
          ,'76.LTU_2009_S19','86.NOR_1911_S7','109.NOR_1990','120.RUS_1860')
library(ggplot2)
n=0
p=list()
for (i in samples){
  print(i)
  data<-read.table(paste("/Users/cuijiajun/Desktop/others/NMs/NM_readlength_combined/",i,"_NM.txt",sep = ''))
  mode(data)
  colnames(data)<-c('NM','count')
  data$NM<-round(data$NM)
  
  n=n+1
  p<-  ggplot(data,aes(x=factor(NM),y=count))+geom_bar(stat = 'identity')
  setwd('/Users/cuijiajun/Desktop/others/NMs/NM_readlength_combined/plotsNM')
  ggsave(filename=paste(i,".png",sep=""),plot=p,width =17,height=10)
}

#combine them together
samples=c('27.ESP_1975','30.ESP_1983b','33.ESP_1985b','34.ESP_1985c_S36','64.GBR_1933b_S36','75.LTU_1894_S30'
          ,'76.LTU_2009_S19','86.NOR_1911_S7','109.NOR_1990','120.RUS_1860')
HBsamples=c('HB0737','HB0766','HB0814','HB0841','HB0828','HB0840'
          ,'HB0863')

library(ggplot2)
n=0
p=list()
datas=data.frame()

for (i in HBsamples){
  print(i)
  data<-read.table(paste("/Users/cuijiajun/Desktop/others/NMs/NM_readlength37/",i,"_NM.txt",sep = ''))
  mode(data)
  colnames(data)<-c('NM','count')
  data$NM<-round(data$NM)
  data$Sample<-i
  data$proportion<-data$count/sum(data$count)
  datas<-rbind(datas,data)
}
for (i in samples){
  print(i)
  data<-read.table(paste("/Users/cuijiajun/Desktop/others/NMs/NM_readlength_combined/",i,"_NM.txt",sep = ''))
  mode(data)
  colnames(data)<-c('NM','count')
  data$NM<-round(data$NM)
  data$Sample<-i
  data$proportion<-data$count/sum(data$count)
  datas<-rbind(datas,data)
}
count=datas$count
Sample=datas$Sample
#datass<-datas[order(Sample,-count),]
p<-  ggplot(datas,aes(x=factor(NM),y=proportion))+geom_bar(aes(fill=Sample), position = "dodge",stat = 'identity')+xlab('NM edit distance')+ylab('Proportion')+ggtitle('NM edit distance to the reference genome')
p
setwd('/Users/cuijiajun/Desktop/others/NMs/plotsNM')
ggsave(filename=paste('merge',".png",sep=""),plot=p,width =17,height=10)
