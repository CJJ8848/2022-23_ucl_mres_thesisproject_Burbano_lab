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
#data<-read.table("/Users/cuijiajun/Desktop/allincludepth.txt",head=T)
data<-read.table("/Users/cuijiajun/Desktop/allwithq20combined_143allqaforplot.txt",head=T)

data<- data %>% 
  mutate(samplename = fct_reorder(samplename, Ps_atleast1read))
p1<-ggplot(data,aes(x=At_percent))+geom_histogram(bins = 20)+ggtitle('At percent')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(),axis.ticks.x=element_blank())
p2<-ggplot(data,aes(x=Ps_percent))+geom_histogram(bins = 20)+ggtitle('Ps percent')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(), axis.ticks.x=element_blank())
p3<-ggplot(data,aes(x=Ps_atleast1read))+geom_histogram(bins = 20)+ggtitle('Ps Coverage')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(), axis.ticks.x=element_blank())
p4<-ggplot(data,aes(x=averagedepth))+geom_histogram(bins = 20)+ggtitle('Ps average depth')+theme(plot.title = element_text(hjust = 0.5), axis.title.x=element_blank(), axis.ticks.x=element_blank())

multiplot(p1, p2,p3,p4,cols=2)
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

print('top six in Pseudomonas >=1 reads')
data[data$Ps_atleast1read>=0.65,]
data2<-data[data$Ps_atleast1read>=0.65,]
data2<- data2 %>% 
  mutate(samplename = fct_reorder(samplename, Ps_percent))
p1<-ggplot(data2,aes(x=samplename,y=At_percent))+geom_bar(stat = 'identity')+ggtitle('At percent')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1))
p2<-ggplot(data2,aes(x=samplename,y=Ps_percent))+geom_bar(stat = 'identity')+ggtitle('Ps percent')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1))
p3<-ggplot(data2,aes(x=samplename,y=Ps_atleast1read))+geom_bar(stat = 'identity')+ggtitle('Ps atleast 1read')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1))
p4<-ggplot(data2,aes(x=samplename,y=averagedepth))+geom_bar(stat = 'identity')+ggtitle('Ps average depth')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1))

multiplot(p1, p2,p3,p4,cols=2)

data3<-read.table("/Users/cuijiajun/Desktop/37samples_allqaforplot_withdepth.txt",head=T)
data4<-data3[data3$Ps_atleast1read>=0.65,]
data5<-rbind(data2,data4)
data5<- data5 %>% 
  mutate(samplename = fct_reorder(samplename, Ps_percent))
p1<-ggplot(data5,aes(x=samplename,y=At_percent))+geom_bar(stat = 'identity')+ggtitle('At percent')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1))
p2<-ggplot(data5,aes(x=samplename,y=Ps_percent))+geom_bar(stat = 'identity')+ggtitle('Ps percent')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1))
p3<-ggplot(data5,aes(x=samplename,y=Ps_atleast1read))+geom_bar(stat = 'identity')+ggtitle('Ps atleast 1read')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1))
p4<-ggplot(data5,aes(x=samplename,y=averagedepth))+geom_bar(stat = 'identity')+ggtitle('Ps average depth')+theme(plot.title = element_text(hjust = 0.5))+theme(axis.text.x = element_text(angle = 60, hjust = 1, vjust = 1))

multiplot(p1, p2,p3,p4,cols=2)

