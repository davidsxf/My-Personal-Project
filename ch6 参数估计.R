#我们通过对数据的描述性分析之后，对样本的分布就有了大致了解
#下一步就是根据样本去推断总体的分布与特征，称之为统计推断。
# 统计推断：参数估计和假设检验

####参数估计





#6.6.1 矩估计


############# 1一个参数的距估计
#估计值：
num=c(rep(0:5,c(1532,581,179,41,10,4)))
#用rep()函数生成样本，样本值有0~5的数字构成，
#函数中的第二个向量对应表示每个数字的重复次数

lambda=mean(num)  #泊松的似然估计值即样本均值
lambda
#根据估计的参数值，画图比较损失次数的估计值和样本值之间的差别
k=0:5
ppois=dpois(k,lambda)
poisnum=ppois*length(num)  #由poisson分布生成的损失次数
plot(k,poisnum,ylim=c(0,1600))
#画图比较，为图形效果更好，用参数ylim设置纵轴的范围，
#最小值为0，最大值要大于样本的最值，选取1600


#样本值：
samplenum=as.vector(table(num))  #样本的损失次数
points(k,samplenum,type="p",col=2)
legend(4,1000,legend=c("num","poisson"),col=1:2,pch="o")





############## 2  多个参数的矩估计

#rootSplve包中函数multiroot()用于解方程组
#multiroot()求解的是函数值为0时方程组的根，所以编写函数function要注意减去样本均值和方差

x=c(4,5,4,3,9,9,5,7,9,8,0,3,8,0,8,7,2,1,1,2)
m1=mean(x)  #样本均值
m2=var(x)  #样本方差
model=function(x,m1,m2){
  c(f1=x[1]+x[2]-2*m1,
    f2=(x[2]-x[1])^2/12-m2)
}
library(rootSolve)
multiroot(f=model,start=c(0,10),m1=m1,m2=m2)
m1-sqrt(3*m2);m1+sqrt(3*m2)


#6.1.2 MLE极大似然估计
#  1 极值函数计算
library(MASS)
head(geyser,5)#黄石公园喷泉泉水持续时间和喷发相隔时间
attach(geyser)
hist(waiting,freq=FALSE)



#在R中编写对数似然函数时，需要估计出函数中的5个参数，都存放在向量para中
#
ll=function(para)
{
  f1=dnorm(waiting,para[2],para[3])
  f2=dnorm(waiting,para[4],para[5])
  f=para[1]*f1+(1-para[1])*f2
  ll=sum(log(f))
  return(-ll)
}
geyser.est=nlminb(c(0.5,50,10,80,10),ll,lower=c(0.0001,-Inf,0.0001,-Inf,0.0001),upper=c(0.9999,Inf,Inf,Inf,Inf))
options(digits=3)
geyser.est$par  #查看拟合的参数结果：5个参数值
p=geyser.est$par[1]
mu1=geyser.est$par[2];sigma1=geyser.est$par[3]
mu2=geyser.est$par[4];sigma2=geyser.est$par[5]
x=seq(40,120)
#将估计的参数函数代入原密度函数
f=p*dnorm(x,mu1,sigma1)+(1-p)*dnorm(x,mu2,sigma2)
hist(waiting,freq=F)
lines(x,f)  #画出拟合曲线






# 2 函数maxLik()计算：最常用专门程序包用作求解似然函数
num=c(rep(0:5,c(1532,581,179,41,10,4)))
loglik=function(para){
   f=dnbinom(num,para[1],1/(1+para[2]))#注意第二个参数不是beta，是prob
   ll=sum(log(f))
   return(ll)
 }

library(maxLik)
para=maxLik(loglik,start=c(0.5,0.4))$estimate  #极大似然估计
r=para[1];beta=para[2]
l=length(num)
nbinomnum=dnbinom(0:5,r,1/(1+beta))*l;nbinomnum

plot(0:5,nbinomnum,ylim=c(0,1600))  #画图比较
points(0:5,nbinomnum,type="p",col=2)
legend(3,1000,legend=c("num","poisson"),col=1:2,lty=1)


############# 6.2 单正态总体的区间估计
############# 6.2.1 均值的区间估计
# 1）方差已知

# R中没有计算方差已知时均值置信区间的内置函数，
# 需要自己编写，代码也比较简单
# x为数据样本；sigma是已知总体的标准差；alpha是显著性水平；
# 通常我们做区间估计，都会估计出双侧的置信区间，因为它为待估参数
# 提供上下限两个参考值
conf.int=function(x,sigma,alpha)
{
  mean=mean(x)
  n=length(x)
  z=qnorm(1-alpha/2,mean=0,sd=1,lower.tail=TRUE)
  c(mean-sigma*z/sqrt(n),mean+sigma*z/sqrt(n))
}

set.seed(111)                     #设定随机种子
x=rnorm(20,10,2)                  #从均值为10，标准差为2的总体中抽取20个样本，
###################################方差已知的正态分布样本

conf.int(x,2,0.05)                #计算置信水平95时x的置信区间，首先调用自行编写的函数
##################################conf.int(),显著性水平为a=0.05





#BSDA包中提供函数z.test()，基于正态分布的单样本和双样本进行假设检验和区间估计

#  z.test()函数格式：

#  z.test(x, y = NULL, 
#  alternative = "two.sided", mu = 0, sigma.x = NULL,
#  sigma.y = NULL, conf.level = 0.95)
# x和y是数值向量，默认为Y=NULL,即进行的单样本假设检验
# alternativE用于指定所求置信区间的类型，默认为two.sided,
#                                       表示求双尾的置信区间
# less求置信上限，greater求置信下限
# mu表示均值，默认为0
# sigma.x和sigma.y分别指定两个样本总体的标准差
# conf.level指定区间估计的置信水平



# 
library("BSDA")
z.test(x,sigma.x=2)$conf.int

# 2）方差未知
# 用t分布的统计量来替代z
# R中实现方差未知的区间估计非常容易
# 参数估计和假设检验有着密不可分的关系，
# 调用t检验的函数就可以直接求出置信区间

# t.test()格式：
# t.test(x, y = NULL,
#       alternative = c("two.sided", "less", "greater"),
#       mu = 0, paired = FALSE, var.equal = FALSE,
#       conf.level = 0.95, ...)
t.test(x)         #直接输出将会输出很多东西
t.test(x)$conf.int#只要求输出区间估计结果，用符号“$"链接conf.int


################## 6.2.2 方差的区间估计
################## 1)均值已知
################## 2)均值未知
# 由于R中没有直接计算方差的置信区间的函数，可以把上述两种情况编写成自定义函数
# 用if语句进行判断，只要是方差的区间估计，都调用这个函数var.conf.int()
var.conf.int=function(x,mu=Inf,alpha){
  n=length(x)
  if(mu<Inf){
    s2=sum((x-mu)^2)/n
    df=n
  }
  else{
    s2=var(x)
    df=n-1
  }
  c(df*s2/qchisq(1-alpha/2,df),df*s2/qchisq(alpha/2,df))
}

# 实际分析中，均值基本都是未知的情形。例如计算样本X的方差的置信区间时，
# 若均值未知，调用函数就不需要指定Mu的值了
var.conf.int(x,alpha=0.05)
#得到总体方差的置信区间为[3.41,12.58],置信水平95%






######################6.3 两正态总体间的区间估计
######################6.3.1 均值差的区间估计
# 1）两总体方差已知
sales=read.table("sales.txt",header=T)
head(sales)
attach(sales)
par(mfrow=c(1,2))
hist(prior)  #分别绘制计划前后销售额的直方图
hist(post)



# 方法一：自定义函数
#R中编写计算置信区间的函数twosample.ci()如下：
# 输入参数为样本x,y,置信度a和两个样本的标准差
twosample.ci=function(x,y,alpha,sigma1,sigma2){
  n1=length(x);n2=length(y)
  xbar=mean(x)-mean(y)
  z=qnorm(1-alpha/2)*sqrt(sigma1^2/n1+sigma2^2/n2)
  c(xbar-z,xbar+z)
}


#调用上面写好的函数，计算样本均值差在置信水平1-a下的置信区间
twosample.ci(post,prior,alpha=0.05,8,12)


#  方法二：直接使用z.test()函数编写
library(DBSA)
z.test(post,prior,sigma.x=8,sigma.y=12)$conf.int







# 2）两总体方差未知但相等
#与单正态总体均值的置信区间，
#R中的函数t.test()还可以用来求两总体均值差的置信区间
#由于总体方差相等，需要将其中的参数var.equal设为TRUE
t.test(post,prior,var.equal=TRUE)
t.test(post,prior,var.equal=TRUE)$conf.int




# 3)两总体方差未知且不等
# 显然第三种最复杂，R中没有直接的函数使用，需要自定义函数twosample.ci2()

twosample.ci2=function(x,y,alpha){
  n1=length(x);n2=length(y)
  xbar=mean(x)-mean(y)
  S1=var(x);S2=var(y)
  nu=(S1/n1+S2/n2)^2/(S1^2/n1^2/(n1-1)+S2^2/n2^2/(n2-1))
  z=qt(1-alpha/2,nu)*sqrt(S1/n1+S2/n2)
  c(xbar-z,xbar+z)
}

####注意实际分析中：两总体的方差未知且不等是最常见的，一定要掌握
twosample.ci2(post,prior,0.05)


############################6.3.2 两方差比的区间估计
#实际分析中，总体均值通常是未知的，尤其涉及到两个总体时
#比较两个总体的方差，采用“比的形式”，
#而不是差值，这与统计量的构造有关

#方差比的区间估计与方差的假设检验密不可分，所以R中的函数var.test()直接计算
#var.test()函数格式
#var.test(x, y, ratio = 1,
#         alternative = c("two.sided", "less", "greater"),
#         conf.level = 0.95, ...)

var.test(prior,post)$conf.int

#6.4 比率的区间估计
#比率的估计在R中实现起来也比较简单，函数prop.test()可以直接完成对p的估计和检验
#格式：
#prop.test(x, n, p = NULL,
#          alternative = c("two.sided", "less", "greater"),
#          conf.level = 0.95, correct = TRUE)
prop.test(214,2000)#大样本，正态分布
binom.test(214,2000)#小样本，二项分布