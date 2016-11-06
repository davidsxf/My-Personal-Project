#3.1 数据处理的基本函数
data=read.table("salary.txt",header=T)
data
mean(Salary)    #求均值
length(Salary)  #数据长度（个数）
cumsum(Salary)  #累积工资
#1数据分组
salary1=cut(Salary,3)
table(salary1)
#2数据分组并给每个区间设置标签
salary1=cut(Salary,3,labels=c("low","medium","high"))
table(salary1)


#3自定义区间长度
breakpoints=c(0,30,40,50,60,70)
salary2=cut(Salary,breaks=breakpoints)
table(salary2)

#4常用数据统计图(一张图表展示)
#自定义的函数
pic=function(x){
  par(mfrow=c(2,2))  #绘图区域分割为四部分
  hist(x)            #直方图
  dotchart(x)        #点图
  boxplot(x)         #箱线图
  qqnorm(x);qqline(x)#正态概率图
  par(mfrow=c(1,1))  #恢复单图区域
}
pic(Salary)          #调用编写好的函数pic()



#################################################################3.2 数据修改
#3.2.1 修改数据标签
data=read.table("salary.txt",header=T,stringsAsFactors=F)
data
names(data)=c("CITY","WORK","PRICE","SALARY")
names(data)
data

#3.2.2 行列删除(使用[]来提取数据的子集，使用中括号来上删除某一行与某一列，只需要在前面加个负号)
#删除第一行和第三列
data2=data[-1,-3]
data2

###################################3.3缺失值处理（数据处理重中之重）
#数据缺失主要原因：
#（1）在数据搜集阶段，某些记录或字段丢失
#（2) 调查访问中，被访问者拒绝透漏相关信息，导致数据的无效性
#（3）由于机械原因，导致数据存储的失败


#3.3.1 判断缺失数据
#R中缺失值以NA表示，判断数据是否存在缺失值的函数有两个，


#最基本的函数是：   is.na(),可以应用于向量、数据框等多种对象
data=read.table("d:/data/salary.txt",header=T,stringsAsFactors=F)
names(data)=c("CITY","WORK","PRICE","SALARY")
names(data)
data
#将data文件中工资指数大于65的值替换为缺失值(缺失值为TRUE)
attach(data)
data$SALARY=replace(SALARY,SALARY>65,NA)
data

#方法一：
is.na(SALARY)
sum(is.na(SALARY))


################################################################
#方法二：另一个判断缺失值的函数是complete.cases(),同样返回逻辑值向量
#值与is.na()的相反，缺失值为FALSE，正常数据TRUE
complete.cases(data$SALARY)
################################################################

#3.3.2 判断缺失模式
#存在数据缺失，需要进一步判断数据的缺失模式，判断是否是随机的，然后
#才能确定处理的办法
#程序包mice是利用链式方程进行多元插补，可以处理混合变量类型的数据缺失
#自动产生填补变量的预测变量，是处理缺失值的重要工具

data$PRICE=replace(PRICE,PRICE>80,NA)

#从数值的角度：显示缺失数据的模式
library(mice)
md.pattern(data)
#从可视化的角度：显示缺失数据的模式
#利用aggr()函数
#判断数据模式使用其中的函数aggr(),它能对缺失数据进行整合
#  aggr(x,delimiter=NULL,plot=TRUE,...)
#  X表示一个向量、矩阵和数据框；
#  y用于区分插补变量，如果给出相应的值，其被用来说明变量的值已被插补
#  plot是逻辑值，指明是否绘制图形，默认为TRUE,相当于内嵌了一个绘图函数
library(VIM)
aggr(data)


#3.3.3 处理缺失数据
#方法一：删除缺失样本

#过滤掉缺失样本是最简单的方式，其前提是缺失数据的比例较少，而且缺失数据时随机出现的，
#这样删除缺失数据后对数据分析结果影响不大



#R可以使用complete.cases()指令选取完整的记录，
#有缺失值的行则删除不要
data1=data[complete.cases(data$SALARY),]
dim(data1)


#对于有多个变量缺失的数据，通过na.omit()函数来完成，
#这样就删除了SALARY和PRICE缺失的所有记录，剩下8行完整数据
data3=na.omit(data)
dim(data3)


#方法二：替换缺失值
# 缺点：非随机出现会产生偏差

# mean函数是对非NA值的SALARY数据求平均
data[is.na(data)]=mean(SALARY[!is.na(SALARY)])   


#方法三：多重插补法
#FSC方法：没有合适的多位分布也可以使用
#在R语言中通过程序包mice中的函数mice()可以实现该方法
#它随机模拟多个完整数据集并存入imp，
#再对imp进行线型回归
#最后利用pool函数对回归结果进行汇总
data=read.table("d:/data/salary.txt",header=T)
names(data)=c("CITY","WORK","PRICE","SALARY")
attach(data)
data$SALARY=replace(SALARY,SALARY>65,NA)
data

#随机模拟，多元回归
library(mice)
imp=mice(data,seed=1)  #随机模拟数据
fit=with(imp,lm(SALARY~WORK+PRICE))  #线性回归
pooled=pool(fit)  #回归结果
options(digits=3)  #显示小数点后三位
summary(pooled)

data.pre=data[is.na(data$SALARY),][,2:3]  #选取缺失样本的WORK和PRICE值
data.pre=as.matrix(cbind(rep(1,4),data.pre))
q=pooled$qbar  #通过拟合回归预测SALARY
pre=data.pre%*%q;pre  #预测结果
index=is.na(data$SALARY)
data$SALARY[index]=pre   #替换缺失值
data[index,]

#3.4 数据整理
#3.4.1 数据合并
#R语言中数据合并多种形式，三类函数
#（1）函数cbind(),rbind()
a=c("Hongkong",1910,75.0,41.8)

#增加一行记录：使用过rbind
data1=rbind(data,a)
data1[14:16,]
# (2) 构造data.frame
weight=c(150,135,210,140)  #数值型向量
height=c(65,61,70,65)
gender=c("F","F","M","F")  #字符型向量
stu=data.frame(weight,height,gender)
row.names(stu)=c("Alice","Bob","Cal","David")
stu[,"weight"]
stu["Cal",]  #获取行
stu[1:2,1:2]
stu$weightt  # ”$”用于取列
stu[["weight"]]  #双括号+名称
stu[[1]]  #双括号+下标，用于数据框和列表数据的获取


# (3)函数merge()
index=list("City"=data$City,"Index"=1:15)
index
data.index=merge(data,index,by="City")
data.index


#3.4.2
data[data$Salary>65,]
data[c(2,4),]
data[data$Price==65.6,]


#3.4.3
order.salary=order(data$Salary)
order.salary
sort.list(data$Salary)
data[order.salary,]
rank(data$Salary)

#3.5长宽各式的转换
###############3.5.1 揉数据函数
#R中两个揉数据函数stack()和unstack(),用于数据长格式和宽格式之间的转换
#stack():把一个数据框转换成两列（一列为数据，另一列为数据对应的列名称）

t(data)#行列转置

x=data.frame(A=1:4,B=seq(1.2,1.5,0.1),C=rep(1,4))
x

x1=stack(x)
x1

#unstack()是stack()的逆过程，被转换的对象包含两列，他把数据列
#按照因子列的不同水平重新以实现类似的效果
unstack(x1,form=values~ind)


#####################3.5.2 揉数据的最佳伴侣：reshape2程序包
library("reshape2")
#与stack()一样
melt(x)

#用melt()处理复杂数据框时，需要进行参数设置
data(airquality)
str(airquality)  #显示R对象的内部结构，功能类似于summary()
longdata=melt(airquality,id.vars=c("Ozone","Month","Day"),measure.vars=2:4)
str(longdata)


#scale=”free_y”设置每个图形自动调整y轴范围
library(ggplot2)
p=ggplot(data=longdata,aes(x=Ozone,y=value,color=factor(Month)))
p+geom_point(shape=20,size=4)+facet_wrap(~variable,scales="free_y")+ 
  geom_smooth(aes(group=1), fill="gray80")  

#利用reshape2进行数据汇总
shortdata=dcast(longdata,formula=Ozone+Month+Day~variable)
head(shortdata,5)