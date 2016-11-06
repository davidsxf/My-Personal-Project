# 决策树和规则学习
# 通过将数据集划分为较小的子集来确定用于预测的方式，
# 这些知识之后将以逻辑结构的形式呈现，不需要任何统计知识就可以理解
# 几种实现算法：C5.0算法、1R算法和RIPPER算法
# 决策树本质上是一个流程图，根节点——叶节点，适合透明化的分类机制
# 决策树的建立使用一种称为“递归划分”的探索法

# 决策树最知名的算法是——C5.0算法，
# 也已经成为生成决策树的行业标准，适用于大多数类型的问题，可以直接使用
# 该算法易理解和易部署，缺点较小，可以避免
# C5.0算法：高度自动化的学习过程，可以处理数值型数据、名义特征和缺失数据






# 1 选择最佳的分割
#   决策树面临的第一个挑战就是需要确定根据哪个特征进行分割。
#   C5.0算法使用熵度量纯度：样本数据的熵表示分类值如何混杂在一起，
#                           最小值0表示的样本是完全同质的
#                           1表示样本凌乱的最大数量

# 信息增益：决策树算法使用熵值来计算由每一个可能特征的分割所引起的同质性（均匀性）变化
#           称为信息增益


# 2 修剪决策树
# 决策树增长过大，将会是许多决策过于具体，模型将会过度拟合训练数据
# 修剪决策树的过程涉及到减小它的大小，使决策树更好的推广到未知的数据
#　分为：预剪枝决策树法和后剪枝决策树法
# C5.0算法的优点之一就是它可以自动修剪，关注许多决策，能自动使用相当合理的默认值。
#                       该算法的总体策略是过度拟合训练数据的大决策树，然后删除
#                       对分类误差影响不大的节点和分支。
# 权衡过度拟合与不足拟合一颗决策树是一门学问。

# 案例分析：使用C5.0决策树识别高风险银行贷款——建立简单的信贷审批模型
# 决策树的准确性高，以通俗易懂的方法建立统计模型的能力强，广泛应用于银行业

# 1 收集数据
# 2 探索和准备数据
credit <- read.csv("credit.csv")
str(credit)
#1000条记录，17个变量

# 表示支票和储蓄账户余额（单位是DM马克），并记为分类变量
table(credit$checking_balance)
table(credit$savings_balance)


#贷款的特征是数值型变量，比如贷款期限和信贷申请的金额
summary(credit$months_loan_duration)
summary(credit$amount)


#default表示贷款申请者是否未能符合约定的付款条件而陷入违约，
#所有申请贷款的有30%陷入违约
table(credit$default)

##############数据准备，创建随机的训练数据集和测试数据集
#在划分数据前，通过随机排列信贷数据框来解决这个问题，
# order()函数以升序或者降序的方式对数据列表进行重新排列
# 将order()与随机数函数runif()相结合，就可以生成一个随机排序的列表
# 随机数的产生，使用函数runif()产生0~1之间的随机数序列
set.seed(12345)
credit_rand <- credit[order(runif(1000)), ] 
#runif(1000)生成了一个含有1000个随机数的列表
#order()函数返回一个数值向量
#order(c(0.25,0.5,0.75,0.1))


#显示主要的统计量
summary(credit$amount)
summary(credit_rand$amount)

#使用head()函数查看每一个数据框前几个值
head(credit$amount)
head(credit_rand$amount)

#将数据分为训练数据和测试数据
credit_train <- credit_rand[1:900, ]
credit_test <- credit_rand[901:1000, ]

# 每个数据集的比例成分
prop.table(table(credit_train$default))
prop.table(table(credit_test$default))

# 3 基于数据训练模型
library(C50)

# C5.0算法的规则
# 1）创建分类器
#m<-C5.0(train, class, trials = 1, 
#     rules= FALSE, 
#     weights = NULL, 
#     control = C5.0Control(), 
#     costs = NULL, ...)
#train：一个包含训练数据的数据框
#class：包含训练数据每一行的分类的一个因子向量
#trial：为一个可选数值，用于控制自主法循环的次数（默认为1）
#costs：可选矩阵，用于给出与各种类型错误相对应的成本


# 2）进行预测
#p<-predict(m,test,type="class")
# m：有函数C5.0()训练的一个模型
# test：一个包含测试数据的数据框，该数据框和用来创建分类器的训练数据有同样的特征
# type：取值为class和prob，标识预测是最可能的类别值或者是原始的预测概率

#第17列类变量default作为自变量从训练数据框中排除，作为因子变量
credit_model <- C5.0(credit_train[-17], credit_train$default)
credit_model
#决策树的简单情况，生成决策树的
#  函数调用、特征数predictiors和用于决策树增长的案例samples。
# 决策树大小size=67

#查看决策树：决策树是一种过度拟合训练数据模型的倾向，
#            训练数据中报告的错误率可能过于乐观，
# 基于测试数据集来评估决策树模型是非常重要的
summary(credit_model)
#训练案例的错误率为13.9%






# 4 评估模型的性能
# 决策树应用于测试数据集，使用predict()函数，产生预测分类值的向量
credit_pred <- predict(credit_model, credit_test)

#使用crosstable()函数将预测分类值向量与真实的分类值比较
library(gmodels)
CrossTable(credit_test$default, 
           credit_pred, 
           prop.chisq = FALSE, 
           prop.c = FALSE, 
           prop.r = FALSE, 
           dnn = c('actual default', 'predicted default'))
# 结果显示：100个贷款申请者的记录测试中，模型预测了57个申请者确实没有违约
#           而16个申请者确实违约，模型准确率为73%，而错误率为23%
#　　　　　训练数据上模型的性能略差，并不意外，对于未知的数据，模型的性能往往会差些





# 5 提高模型的性能
# 1）提高决策树的准确性
# 自适应增强（adaptive boosting）
# boosting算法广泛应用于任何机器学习算法
#核心思想：将很多能力较弱的学习算法组合在一起，就可以创建一个团队
#          比任何单独的学习算法都强得多

# 将boosting算法添加至C5.0决策树中，添加额外的一个参数trials:
# 表示在模型增强团队中使用的独立决策树的数量，参数trials设置了一个上限
# 如果该算法识别出额外的实验似乎并没有提高模型的准确性，将会停止添加决策树
credit_boost10 <- C5.0(credit_train[-17], credit_train$default, 
                       trials = 10)
credit_boost10
#通过10次迭代，决策树变小67变成56
summary(credit_boost10)
# 训练案例的错误率为3.4%

credit_boost_pred10 <- predict(credit_boost10, credit_test)
CrossTable(credit_test$default, credit_boost_pred10, 
           prop.chisq = FALSE, 
           prop.c = FALSE, 
           prop.r = FALSE, 
           dnn = c('actual default', 'predicted default'))
#错误率由之前的27%下降至23%，但已经降低近25%的标准，
#但是模型在预测贷款违约方面仍然做的不好，15/32=47%是错误的


# 2）犯一些比其他错误更严重的错误
# 代价矩阵
error_cost <- matrix(c(0, 1, 4, 0), nrow = 2)
error_cost

credit_cost <- C5.0(credit_train[-17], credit_train$default, costs = error_cost)
credit_cost_pred <- predict(credit_cost, credit_test)
CrossTable(credit_test$default, credit_cost_pred, 
           prop.chisq = FALSE, 
           prop.c = FALSE, 
           prop.r = FALSE, 
           dnn = c('actual default', 'predicted default'))






