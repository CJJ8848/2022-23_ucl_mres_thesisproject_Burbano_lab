data<-read.table("/Users/cuijiajun/Desktop/tmreads.txt",head=F)
colnames(data)=c('samplename', 'trimedandmerged', 'allreadsfq', 'dist_tmreads')
library(ggplot2)
library(dplyr)
library(forcats)
ggplot(data,aes(x=dist_tmreads))+geom_histogram(binwidth = 0.05)+ggtitle('dist_tmreads')+theme(plot.title = element_text(hjust = 0.5))
data<- data %>% 
  mutate(samplename = fct_reorder(samplename, dist_tmreads))
p1<-ggplot(data,aes(x=samplename,y=dist_tmreads))+geom_point(stat = 'identity')+ggtitle('tmreads_percent')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())
p1


data<-read.table("/Users/cuijiajun/Desktop/tmreads.txt",head=T)
data2<-read.table("/Users/cuijiajun/Desktop/col1.txt",head=F)

colnames(data2)=c('samplename2', 'average_read_length')
data3<-cbind(data,data2[])
library(ggplot2)
library(dplyr)
library(forcats)

ggplot(data3,aes(x=average_read_length,y=dist_tmreads))+geom_point()+ggtitle('correlation')+theme(plot.title = element_text(hjust = 0.5))
