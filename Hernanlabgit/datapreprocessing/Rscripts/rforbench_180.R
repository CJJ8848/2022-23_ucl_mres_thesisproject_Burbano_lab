multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
library(ggplot2)
library(dplyr)
library(forcats)
#install.packages('forcats')
#data<-read.table("/Users/cuijiajun/Desktop/allincludepth.txt",head=T)
data<-read.table("/Users/cuijiajun/Desktop/2022-2023_ucl_mres/Hernanlab/Hernanlabgit/datapreprocessing/tableforplot/180samplestableforplot.txt",head=T)

data<- data %>% 
  mutate(samplename = fct_reorder(samplename, Ps_atleast1read))
p1<-ggplot(data,aes(x=At_percent))+geom_histogram(aes(y = after_stat(count / sum(count))), colour="black", fill="white")+ggtitle('A.theliana genome proportion')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(),axis.ticks.x=element_blank())+geom_vline(xintercept=mean(data$At_percent),linetype='dashed',color='dark red')+scale_y_continuous(labels=scales::percent)+ylab('percent')
p2<-ggplot(data,aes(x=Ps_percent))+geom_histogram(aes(y = after_stat(count / sum(count))), colour="black", fill="white")+ggtitle('Pseudomonas genome proportion')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(), axis.ticks.x=element_blank())+geom_vline(xintercept=mean(data$Ps_percent),linetype='dashed',color='dark red')+scale_y_continuous(labels=scales::percent)+ylab('percent')
p3<-ggplot(data,aes(x=Ps_atleast1read))+geom_histogram(aes(y = after_stat(count / sum(count))), colour="black", fill="white")+ggtitle('Pseudomonas genome coverage')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(), axis.ticks.x=element_blank())+geom_vline(xintercept=mean(data$Ps_atleast1read),linetype='dashed',color='dark red')+scale_y_continuous(labels=scales::percent)+ylab('percent')
p4<-ggplot(data,aes(x=averagedepth))+geom_histogram(aes(y = after_stat(count / sum(count))), colour="black", fill="white")+ggtitle('Pseudomonas genome depth')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(), axis.ticks.x=element_blank())+geom_vline(xintercept=mean(data$averagedepth),linetype='dashed',color='dark red')+scale_y_continuous(labels=scales::percent)+ylab('percent')
pdf('/Users/cuijiajun/Desktop/2022-2023_ucl_mres/Hernanlab/thesis_draft/imgs/all180stat.pdf')
multiplot(p1, p2,p3,p4,cols=2)
dev.off()
#df1<-data.frame(samplename=data$samplename,value=data$At_percent,group='A.theliana genome %')
#df2<-data.frame(samplename=data$samplename,value=data$Ps_percent,group='Pseudomonas genome %')
#df3<-data.frame(samplename=data$samplename,value=data$Ps_atleast1read,group='Pseudomonas coverage')
#df4<-data.frame(samplename=data$samplename,value=data$averagedepth,group='Pseudomonas depth')
#df<-rbind(df1,df2,df3,df4)
#ggplot(data,aes(x=Ps_percent,y=Ps_atleast1read))+geom_point()+ggtitle('Ps atleast 1read')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(), axis.text.x=element_blank(),axis.ticks.x=element_blank())
#average
print('Atheliana percentage')
mean(data$At_percent)
print('Pseudomonas percentage')
mean(data$Ps_percent)
print('Remain unannotated')
mean(data$unannotated)
print('Pseudomonas >=1 reads')
mean(data$Ps_atleast1read)

print('top in Pseudomonas >=1 reads')
data[data$Ps_atleast1read>=0.65,]
data2<-data[data$Ps_atleast1read>=0.65,]
data2<- data2 %>% 
  mutate(samplename = fct_reorder(samplename, Ps_percent))
p1<-ggplot(data2,aes(x=samplename,y=At_percent))+geom_bar(stat = 'identity')+ggtitle('A.theliana genome proportion')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 40, hjust = 1, vjust = 1))+ylab('proportion')
p2<-ggplot(data2,aes(x=samplename,y=Ps_percent))+geom_bar(stat = 'identity')+ggtitle('Pseudomonas genome proportion')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 40, hjust = 1, vjust = 1))+ylab('proportion')
p3<-ggplot(data2,aes(x=samplename,y=Ps_atleast1read))+geom_bar(stat = 'identity')+ggtitle('Pseudomonas genome coverage')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 40, hjust = 1, vjust = 1))+ylab('coverage')+geom_hline(yintercept=0.65,linetype='dashed',color='dark red')
p4<-ggplot(data2,aes(x=samplename,y=averagedepth))+geom_bar(stat = 'identity')+ggtitle('Pseudomonas genome depth')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 40, hjust = 1, vjust = 1))+ylab('depth')
pdf('/Users/cuijiajun/Desktop/2022-2023_ucl_mres/Hernanlab/thesis_draft/imgs/17stat.pdf')
multiplot(p1, p2,p3,p4,cols=2)
dev.off()

