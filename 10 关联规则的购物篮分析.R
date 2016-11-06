# 用于关联规则学习的Aprior算法：高效搜索大型数据库的最广泛使用的方法
# 管理事务型数据处理的特性？

#Aprior算法采用一个极其简单的先验信念作为准则来减少关联规则的搜索空间：
# 一个频繁项集的所有子集必须也是频繁的
# 1 度量规则兴趣度——支持度和置信度
# 2 Apriori原则建立规则

# 案例分析——用关联规则确定经常一起购买的食品杂货
# 加载工作空间
# 1 2
library(arules)
g <- read.transactions("groceries.csv", sep = ",")
summary(g)

inspect(g[1:5])


# 可视化商品的支持度————商品的频率图
itemFrequency(g[, 1:3])
itemFrequencyPlot(g, support = 0.1)
itemFrequencyPlot(g, topN = 20)


# 可视化交易数据————绘制稀疏矩阵
image(g[1:5])
image(sample(g, 100))


# 3 基于数据训练模型
# 
apriori(g)

grules <- apriori(g, parameter = 
                    list(support = 0.006, confidence = 0.25, minlen = 2))

grules


# 4 评估模型的性能
summary(grules)

inspect(grules[1:3])



# 5 提高模型的性能

#1）用关联规则集合排序
inspect(sort(grules, by = "lift")[1:5])


#2）提取关联规则的子集
berryrules <- subset(grules, items %in% "berries")
inspect(berryrules)



#3）将关联规则保存到文件或者数据框中
write(grules, file = "groceryrules.csv", 
      sep = ",", quote = TRUE, row.names = FALSE)

grules_df <- as(grules, "data.frame")

str(grules_df)



