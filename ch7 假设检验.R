#参数估计与假设检验是统计推断的两个重要组成部分
#都是利用样本信息对总体进行某种推断

#参数估计是一种数理统计方法，估计的参数值是对总体参数或分布形式的一种假设
#但是他是否准确描述了总体的分布，还需要假设检验构造合适的统计量
#利用样本信息对所提供的假设进行检验，从而判断是否接受假设

#假设检验采用逻辑上的反证法，依据统计上的小概率原理，判断估计数值与总体真实值
#之间是否存在显著差异



############### 7.2 单正态总体的检验
############### 7.2.1 均值的假设检验
# 1）方差已知
# R中自带的函数中提供了t检验的函数t.test(),而没有Z检验的函数
# 仿照t.test()函数自己编写函数z.test(),用于计算Z统计量的值以及P值
#方法一：
z.test=function(x,mu,sigma,alternative="two.sided"){
  n=length(x)
  result=list()                #构造一个空的list，用于存放输出结果
  mean=mean(x)
  z=(mean-mu)/(sigma/sqrt(n))  #计算z统计量的值
  options(digits=4)            #结果显示至小数点后4位
  result$mean=mean;result$z=z  #将均值、z值存入结果
  result$P=2*pnorm(abs(z),lower.tail=FALSE)  #根据z计算P值
  
  #若是单侧检验，重新计算P值
  if(alternative=="greater") result$P=pnorm(z,lower.tail=FALSE)
  else if(alternative=="less") result$P=pnorm(z)
  result  
}

bj=c(102.5,102.4,102.0,101.8,101.8,102.1,102.3,102.5,102.6,102.8,103.4,104.2)
hist(bj)
z.test(x=bj,mu=102.4,sigma.x=0.67,alternative="two.sided")

#基于正态分布的单样本和双样本进行假设检验：方法二
library(BSDA)
z.test(x=bj,mu=102.4,sigma.x=0.67,alternative="two.sided")

# 2）方差未知：在R中实现起来比较简单，直接调用t检验函数t.test()

#均值的区间估计与假设检验紧密相连，本质上对同一问题从不同角度进行讨论
#所以t.test()既可以做区间估计，也可以做假设检验

t.test(x=bj,mu=102.4,alternative="less")
#格式：
t.test(x, y = NULL,
alternative = c("two.sided", "less", "greater"),
mu = 0, paired = FALSE, var.equal = FALSE,
conf.level = 0.95, ...)
# x为样本数据，若仅出现x，则进行单样本t检验，若x和y同时出现，则进行双样本t检验
# alternative为置信区间的类型，默认为two.sided，双尾的置信区间
# less置信上限，greater置信下限
# mu表示均值，原假设中实现判定的均值默认为0
# paired是逻辑值，表示是否进行配对样本t检验，默认为不配对
# var.equal是逻辑值，表示双样本检验时两个总体的方差是否相等
# conf.level表示置信区间的水平



#分析结果：
One Sample t-test

data:  bj
t = 0.7, df = 10, p-value = 0.7
alternative hypothesis: true mean is less than 102
95 percent confidence interval:
  -Inf  103
sample estimates:
  mean of x 
103
#结果分析：t对应的概率值p为0.7>0.05，因此在0.05的显著性水平之下，
#          不能拒绝原假设，接受原假设，认为均值为102.4的正态分布








#####################7.2.2方差的假设检验
# R中没有直接的函数可以做样本方差的卡方检验，把均值已知还是未知（多）
# 自定义函数chisq.var.test()中，调用它就可以做各种单样本方差检验
chisq.var.test=function(x,var,mu=Inf,alternative="two.sided"){
  n=length(x)
  df=n-1                      #均值未知时的自由度
  v=var(x)                    #均值未知时的方差估计值
  #总体均值已知的情况
  if(mu<Inf){df=n;v=sum((x-mu)^2)/n}
  chi2=df*v/var               #卡方统计量
  options(digits=4)
  result=list()               #产生存放结果的列表
  result$df=df;result$var=v;result$chi2=chi2;
  result$P=2*min(pchisq(chi2,df),pchisq(chi2,df,lower.tail=F))
  #若是单侧检验，重新计算P值
  if(alternative=="greater") result$P=pchisq(chi2,df,lower.tail=F)
  else if(alternative=="less") result$P=pchisq(chi2,df)
  result
}

chisq.var.test(bj,0.25,alternative="less")





################7.3 两正态总体的检验
#################7.3.1 均值差的假设检验
# 1）两总体方差已知：方法一：
z.test2=function(x,y,sigma1,sigma2,alternative="two.sided"){
  n1=length(x);n2=length(y)
  result=list()                         #构造一个空的list，用于存放输出结果
  mean=mean(x)-mean(y)
  z=mean/sqrt(sigma1^2/n1+sigma2^2/n2)  #计算z统计量的值
  options(digits=4)                     #结果显示至小数点后4位
  result$mean=mean;result$z=z           #将均值、z值存入结果
  result$P=2*pnorm(abs(z),lower.tail=FALSE)  #根据z计算P值
  #若是单侧检验，重新计算P值
  if(alternative=="greater") result$P=pnorm(z,lower.tail=FALSE)
  else if(alternative=="less") result$P=pnorm(z)
  result  
}

sales=read.table("sales.txt",header=T)
z.test2(prior,post,8,12,alternative="less")



#方法二：z.test()函数
library(BDSA)
z.test(prior,post,sigma.x=8,sigma.y=12,alternative="less")

# #####################2) 两总体方差未知且不等，直接通过t.test()，var.equal=FALSE
t.test(prior,post,var.equal=FALSE,alternative="less")



############################ 7.3.2 成对数据t检验:
#   pairs=T就行了
x=c(117,127,141,107,110,114,115,138,127,122)
y=c(113,108,120,107,104,98,102,132,120,114)
t.test(x,y,paired=TRUE,alternative="greater")


#7.3.3两总体方差的检验
var.test(prior,post)


#7.4.1比率的二项分布检验
binom.test(214,2000,p=0.1)
#7.4.2比率的近似检验
prop.test(214,2000,p=0.1)










####################### 非参数检验（重要重要重要！！！！）
#总体分布已知的情况下，
#对总体分布的参数如均值、方差等进行推断的方法统称为参数检验

#问题是：实际的数据分析中我们无法对总体分布的形态做简单的假定，
#此时参数检验就不再适用。
#非参数检验：在总体方差未知情况下，利用样本数据对总体分布形态等进行推断。


#主要介绍几种非参数检验方法：
##########7.5.1 总体分布的卡方检验


#步骤一：直接输入数据向量bj，同时绘制直方图，帮助我们对数据的分布形态初步了解
bj=c(102.5,102.4,102.0,101.8,101.8,102.1,102.3,
     102.5,102.6,102.8,103.4,104.2)
hist(bj)


#步骤二：对数据进行分组，计算各组的频数。主要函数cut()和table()
#        cut()用于将变量的区域分成若干区间，table()计算合并后的数据

#两个函数嵌套使用
A=table(cut(bj,breaks=c(101.4,101.9,102.4,102.9,104.5)))  
A

#步骤三：计算原假设条件下数据落入各区间的理论值
#        由于本例中原假设是正态分布，所以先计算均值和标准差
#   再用正态分布函数pnorm()计算落入各个小区间的理论概率p

br=c(101.5,102,102.5,103,104.5)
p=pnorm(br,mean(bj),sd(bj))  #注意pnorm()计算出的是分布函数
p=c(p[1],p[2]-p[1],p[3]-p[2],1-p[3])
options(digits=2)
p


#步骤四：利用chisq.test()完后Pearson拟合优度卡方检验
chisq.test(A,p=p)


#########7.5.2 KS检验
X=c(420,500,920,1380,1510,1650,1760,2100,2300,2350)
ks.test(X,"pexp",1/1500)  #pxep为指数分布累积分布函数的名称，1/1500为指数分布参数

#双样本KS检验
xx=c(0.61,0.29,0.06,0.59,-1.73,-0.74,0.51,-0.56,0.39,1.64,0.05,-0.06,0.64,-0.82,0.37,1.77,1.09,-1.28,2.36,1.31,1.05,-0.32,-0.40,1.06,-2.47)
yy=c(2.20,1.66,1.38,0.20,0.36,0.00,0.96,1.56,0.44,1.50,-0.30,0.66,2.31,3.29,-0.27,-0.37,0.38,0.70,0.52,-0.71)
ks.test(xx,yy)