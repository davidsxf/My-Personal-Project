#5.1 R内置的分布
#R内嵌了常用的统计分布，四大函数：
# 概率密度函数density
# 累计分布函数probability
# 分位数quantile
# 伪随机数random
# 在R中分别用d/p/q/r表示四个项目，
#                               后面接分布的英文名称或缩写
#例如正态分布的4个函数：dnorm/pnorm/qnorm/rnorm


#5.2 集中趋势的分布
######################################################
#5.2.2 R语言实现数据的集中分布
data=read.csv("中国人寿股价.csv")
data
attach(data)
##############################
##############################获得价格向量，同时去掉缺失数据
price=Clsprc[!is.na(Clsprc)] 
price
##############################
#四大描述数据集中趋势的指标:平均数、中位数、众数、分位数
mean(price)
median(price)
which.max(table(price))
quantile(price)
#分位数通过quantile()计算，x是数值向量，prob给出相应的百分位数
#默认值为（0.25,0.5,075,1），na.rm=FALSE表示不允许包含缺失数据



#五数：最小值，25%的四分位数，中位数，75%的四分位数，和最大值
fivenum(price)

#最小值和最大值
min(price);max(price)


#输出一组数据的五数和均值
summary(price)
##############################################################


#5.3  离散趋势的分析
#5.3.2 离散趋势
#描述数据分布的离散程度:极差、四分差、方差、标准差、变异系数等统计指标
#变异系数:标准差与平均数之比，又叫离散系数，刻画数据相对分散性的一种度量CV。

#极差range()
m=range(price);m[2]-m[1]
max(price)-min(price)

#四分位差fivenum()
q=fivenum(price);q[4]-q[2]


#方差var()和标准差sd()
var(price);sd(price)

#标准差计算公式
sqrt((sum(price^2)-(sum(price))^2/length(price))/(length(price)-1))

#离差mad()
mad(price)






############################5.4 数据的分布分析
#5.4.1 分布情况的测度
#当采用“集中趋势”和“离散趋势”两个指标仍旧无法判断数据的分布形态
#使用“偏态”和“峰度”
#偏度（水平）：判断样本的偏斜程度SK
#峰度（垂直）：数据分布的平坦或尖峰程度，峰度系数K



#5.4.2 偏度/峰度
data=read.csv("中国人寿股价.csv")
data
attach(data)
library(timeDate)  #加载程序包
skewness(price)  #计算偏度系数
kurtosis(price)  #计算峰度系数





##############################
#手动计算SK和K
SK=function(x){
  n=length(x);m=mean(x)
  C=n/((n-1)*(n-2))*sum((x-m)^3)/(sd(x))^3;C
}
SK(price)  #手动计算偏度系数

kurtosis(price)
K=function(x){
  n=length(x);m=mean(x);s=sd(x)
  g2=((n*(n+1))/((n-1)*(n-2)*(n-3))*sum((x-m)^4)/s^4-(3*(n-1)^2)/((n-2)*(n-3)))
  g2
}
K(price)
#################################
#5.5 图形分析及R实现
#5.5.1 直方图和密度函数图

#参数breaks设置直方图的组距，prob=T规定绘制密度直方图
hist(price,breaks=50)  
hist(price,breaks=50,prob=T)
#利用核密度估计函数density()，绘制密度曲线图
lines(density(price),col="blue")  

#5.5.2 QQ图
#验证散点图是否服从于正态分布


#price并不符合正态分布
#绘制正太QQ散点图
qqnorm(price)
#正太QQ散点图及其相应的直线
qqline(price)


#服从正态分布:散点均匀分布在直线两侧
a=c(21.0,21.4,22.5,21.6,19.6,20.6,20.3,19.2,20.2,21.3)
qqnorm(a);qqline(a)


#5.5.3 茎叶图
set.seed(111)  #设置抽样种子
s=sample(price,50)  #从数据集price中抽取50个样本
stem(s)
#函数stem()绘制茎叶图
stem(x,scale=1,width=80,atom=le-08)








#5.5.4 箱线图
boxplot(price,main="Boxplot of price")

#5.5.5 经验分布图
#经验分布函数，R给出样本的经验分布函数ecdf()，通过plot()函数绘制
#ecdf(x)
#plot(x,...,ylab="Fn(x)",verticals=FALSE,col.01line="grey70",pch=19)

plot(ecdf(price),main="empirical cdf",xlab="price",ylab="Fn(price)")
x=min(price):max(price)
#正态分布函数曲线
lines(x,pnorm(x,mean(price),sd(price)),col="red")  
legend(60,0.4,legend=c("样本分布","正态分布"),lty=1,col=1:2)





#多组数据分析及R实现
#5.6.1 多组数据

#读取数据集
group=read.csv("09-11股价.csv")
#忽略缺失样本
group=na.omit(group)  


#直接使用summary()可以得到各组数据的均值和“五数”
summary(group)


#设置显示格式：数字只显示3位
options(digits=3) 


#得到各组元素之间的协方差阵
var(group)
#或者使用cov(group)
cov(group)


#R中使用函数cor()计算相关系数矩阵
#计算相关系数来度量变量之间的线型相关程度
cor(group,method="spearman")


#5.6.2 多组数据的图形分析
#二维散点图
#lowess(x,y=NULL,f=2/3,iter=3,delta=0.01*diff(range(x)))
#x,y指定两个向量，f是平滑的跨度值越大，曲线的平滑程度越高，
#iter是控制执行的迭代次数
attach(group)
plot(Price10~Price09,xlab="Price of 2009",ylab="Price of 2010")
lines(lowess(Price09,Price10),col="red",lwd=2)  #拟合曲线

#等高线图
library(MASS)
a=kde2d(Price09,Price10)
contour(a,
        col="blue",
        main="Contour plot",
        xlab="Price of 2009",
        ylab="Price of 2010")
persp(a)



#矩阵散点图
plot(group,
     main="Scatterplot Matrices")
pairs(group)

#矩阵图
matplot(group,
        type="l",
        main="Matplot")  #type=”l”表示绘制曲线而不是散点
legend(0,35,
       legend=2009:2011,
       pch="——",
       cex=0.6,
       col=1:3)  #cex指定字体大小

#箱线图
boxplot(group,cex.axis=0.6)

#星图
#读入数据
score=read.table("score.txt",header=T)  
stars(score)  #绘制星图，所有参数均设置为默认值
stars(score,
      full=FALSE,
      draw.segments=TRUE,
      key.loc=c(5,0.5),
      mar=c(2,0,0,0)) 
#full=F表示绘制成半圆的图形，
#draw.segments=T表示画出弧线

#折线图
outline=function(x){
  if(is.data.frame(x)==TRUE)
    x=as.matrix(x)  #若x为数据框，则先转换为矩阵形式
  m=nrow(x);n=ncol(x)  #提取x的行列数
  plot(c(1,n),c(min(x),max(x)),type="n",main="The outline graph of data",xlab="Number",ylab="Value")
  for(i in 1:m){
    lines(x[i,],col=i)
  }
}
outline(score)

#调和曲线图
unison=function(x){
  if (is.data.frame(x)==TRUE)
    x=as.matrix(x)  #若x为数据框，则先转换为矩阵形式
  t=seq(-pi, pi, pi/30)  #设置t的变化范围
  m=nrow(x); n=ncol(x)   #提取x的行列数
  f=array(0, c(m,length(t)))  #f赋值为一个数组
  for(i in 1:m){
    f[i,]=x[i,1]/sqrt(2)
    for( j in 2:n){
      if (j%%2==0)
        f[i,]=f[i,]+x[i,j]*sin(j/2*t)
      else
        f[i,]=f[i,]+x[i,j]*cos(j%/%2*t)
    }
  }
  plot(c(-pi,pi),c(min(f),max(f)),type="n",main ="The Unison graph of Data",xlab="t",ylab="f(t)")
  for(i in 1:m) lines(t,f[i,],col=i)
}
unison(score)