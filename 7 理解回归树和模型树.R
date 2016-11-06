# 决策树用于数值预测分为两类：回归树CART     和     模型树MT（功能更强大）
# 将回归加入到决策树：
# 能够进行数值预测的决策树提供了一个引人注目的，可以取代
#                  回归模型的方法
# 回归决策树适用于预测复杂，非线性关系的任务。
# 常见分割标准：标准偏差减少SDR

# 案例分析：用回归树和模型树预测葡萄酒的质量
# 加载工作目录
# 第一步：收集数据
# 第二步：探索和准备数据
wine <- read.csv("whitewines.csv")#全部是数值型变量

str(wine)
#4898个案例，11个特征变量和1个结果变量quality
hist(wine$quality)
# 相比较其他类型的机器学习模型，决策树的优点之一就是
#             可以处理多种类型的数据而无需预处理数据
#             不需要标准化
# 从直方图看出quality呈现正态的钟形分布


# 将数据分为训练数据集和测试数据集
wine_train <- wine[1:3750, ]
wine_test <- wine[3751:4898, ]

# 第三步：基于数据训练模型
# 几乎决策树的所有实现都可以用来进行回归树建模，但是rpart(递归划分)提供了CART最可靠的回归树实现
library(rpart)
m <- rpart(quality ~ ., data = wine_train)
#rpart()函数可以拟合决策树回归树，使用点符号.使得wine_train训练数据集中的其他所有列
#作为预测变量（自变量），quality作为因变量
m
#n= 3750 
#
#node), split, n, deviance, yval
#* denotes terminal node

#1) root 3750 2945.53200 5.870933  
#  2) alcohol< 10.85 2372 1418.86100 5.604975  
#    4) volatile.acidity>=0.2275 1611  821.30730 5.432030  
#      8) volatile.acidity>=0.3025 688  278.97670 5.255814 *
#      9) volatile.acidity< 0.3025 923  505.04230 5.563380 *
#    5) volatile.acidity< 0.2275 761  447.36400 5.971091 *
#  3) alcohol>=10.85 1378 1070.08200 6.328737  
#    6) free.sulfur.dioxide< 10.5 84   95.55952 5.369048 *
#    7) free.sulfur.dioxide>=10.5 1294  892.13600 6.391036  
#     14) alcohol< 11.76667 629  430.11130 6.173291  
#       28) volatile.acidity>=0.465 11   10.72727 4.545455 *
#       29) volatile.acidity< 0.465 618  389.71680 6.202265 *
#     15) alcohol>=11.76667 665  403.99400 6.596992 *

# 结果分析：对于决策时的每个节点，到达决策点的案例数量都列出来了
# 2372个案例的alcohol<1085,1378个案例的alcohol>=10.85，alcohol唯一最重要的指标
#  用*表示的节点是终端或者叶节点，会产生预测，
#  例如alcohol<10.85且volatile.acidity<0.2275,那么它的质量预测为5.97


#查看决策树拟合更详细信息，每一个节点的均方误差和整体特征重要度度量
summary(m)








##########可视化决策树
library(rpart.plot)
#rpart.plot()函数生成决策树图形
rpart.plot(m, digits = 3)

rpart.plot(m, digits = 4, fallen.leaves = TRUE, 
           type = 3, extra = 101)



# 第四步：评估模型的性能
p <- predict(m, wine_test)
summary(p)
summary(wine_test$quality)

#预测质量quality与真实的质量quality值之间的相关关系
cor(p, wine_test$quality)



#用平均绝对误差度量性能MAE
MAE <- function(a, p) {
  return(mean(abs(a - p)))
}
#预测的回归树误差MAE为0.59
MAE(p, wine_test$quality)

#训练数据中的平均度量等级
mean(wine_train$quality)

#平均绝对误差MAE估算为0.67
MAE(5.87, wine_test$quality)

# 第五步：提高模型的算法
# 尝试构建一棵模型树，比回归树更精确的结果
# 目前模型树中最先进的算法是M5'算法，在RWeka中
# Model tree using the M5 algorithm





library(RWeka)

m <- M5P(quality ~ ., data = wine_train)

m

summary(m)


p <- predict(m, wine_test)

summary(p)

cor(p, wine_test$quality)

MAE(wine_test$quality, p)






















