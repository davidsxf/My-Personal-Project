# 聚类分析是一种无监督的机器学习任务，自动将数据划分成类cluster；
# 聚类分析不需要提前告知所划分的组应该是什么样的，我们自己甚至都不知道在寻找什么
# 聚类分析是用于发现知识而不是预测，体现从数据内部发现自然分组的深刻洞察！


# 聚类分析创建了新数据，给无标签案例一个类标签，并完全根据数据的内部关系进行推断。
# 无监督分类
# k均值聚类算法：是聚类分析最常用的分析方法
# 优点：高度灵活性运行良好
# 缺点：使用随机的元素，不能保证找到最佳的类，需要合理的猜测数据需要多少个类

# K均值聚类算法涉及将n个案例中的每一个案例分配到k个类中的一个，其中k是一个提前定义好的数，
# 其目标是最小化每一个类内部的差异，最大化类之间的差异

# 1 使用距离来分配和更新类
# 2 选择适当的聚类数k：
#   如果没有先验知识，一个经验规则建议设置k等于N/2开根，
#                     n数据集中案例总数，但是可能聚类数庞大
# 肘部法：肘部点，
# 一般在k值设定上不要花费太大的时间才是明智的！

# 案例分析——青少年市场细分
# 1 收集数据
#加载工作目录
# 2 准备数据
teens <- read.csv("snsdata.csv")
str(teens)
#sns社交网络服务，30000案例，40变量，其中4个变量表示个人特征，36个变量表示兴趣

table(teens$gender)
table(teens$gender, useNA = "ifany")   #处理缺失值

summary(teens$age)

teens$age <- ifelse(teens$age >= 13 & teens$age < 20, teens$age, NA)

summary(teens$age)



#1）数据准备——缺失值的虚拟编码
# 排除具有缺失值的记录——简单粗暴  不建议使用
teens$female <- ifelse(teens$gender == "F" & !is.na(teens$gender), 1, 0)
teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)

table(teens$gender, useNA = "ifany")
table(teens$female, useNA = "ifany")
table(teens$no_gender, useNA = "ifany")


#2）数据准备——插补缺失值——建议使用
#找到具有代表性的值——计算平均值
mean(teens$age)    #对包含缺失数据的向量，其均值是无法定义的，因为年龄包含缺失值，所以
#mean()返回一个缺失值

#所以我们的处理方法是：在计算均值之前，添加额外的参数去除缺失值，修正这个问题
mean(teens$age, na.rm = TRUE)


#aggravate()计算取出NA后，计算毕业年份gradyear的不同水平值的年龄均值
aggregate(data = teens, age ~ gradyear, mean, na.rm = TRUE)

#ave()返回一个具有重复的组均值的向量中，使得结果在长度上等于原始向量的长度
ave_age <- mean(teens$age, na.rm = TRUE)
ave_age


# 将均值插补到缺失值中，需要使用ifelse()函数，当原始的年龄值为NA时，调用ave_age的值
teens$age <- ifelse(is.na(teens$age), ave_age, teens$age)

# 现在已经消除了缺失值
summary(teens$age)


# 3 基于数据训练模型
#开始聚类时，我们考虑36个特征
interests <- teens[5:40]


#使用z-score将特征标准化，是每个特征具有相同的尺度，调整后均值为0标准差为1
interests_z <- as.data.frame(lapply(interests, scale))

teen_clusters <- kmeans(interests_z, 5)


# 4评估模型的性能
# 查看落在每一组的案例数
teen_clusters$size

# 查看聚类质心的坐标
teen_clusters$centers

# 5 提高模型的性能
teens$cluster <- teen_clusters$cluster

teens[1:5, c("cluster", "gender", "age", "friends")]

aggregate(data = teens, age ~ cluster, mean)
aggregate(data = teens, female ~ cluster, mean)
aggregate(data = teens, friends ~ cluster, mean)
