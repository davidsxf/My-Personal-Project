#为了检验两个名义变量之间的关系，使用 双向交叉表
library(gmodels)
#加载工作目录
usedcars<-read.csv("usedcars.csv",stringsAsFactors=FALSE)
usedcars
# model与color之间的关系，观察一个交叉表，table()函数用在单向表中
# 把9种颜色分为两类，第一组"Black","Grey","Silver","White"和第二组Blue Gold Green Red，
usedcars$conservative<-usedcars$color %in% c("Black","Grey","Silver","White")
# %in%操作符：它根据左边的值是否在右边的向量中，为操作符左边向量中的每一个值返回TRUE或者FALSE
table(usedcars$conservative)
CrossTable(x=usedcars$model,y=usedcars$conservative,chisq = TRUE)



