#最强大的两个机器学习算法：神经网络和支持向量机
# 人工神经网络ANN应用于下列问题：输入数据和输出数据比较好理解，
# 但是涉及到输入到输出的过程是极其复杂的，作为黑箱问题，ANN解决的很好

# 1 网络拓扑：神经网络的学习能力来源于它的拓扑结构topology
# 1）层的数目：输入节点、输出节点、单层网络、多层网络、隐藏层
# 2）信息传播的方向：前馈网络 递归网络 深度学习
# 3）每一层的节点数


# 后向传播训练神经网络:采用后向传播算法的多层前馈网络在数据挖掘领域是常见的
# 案例分析：

#加载工作空间

# 1 收集数据
# 2 探索和准备数据
conc <- read.csv("concrete.csv")
str(conc)
#1030个混凝土案例，8个描述混合物成分的特征变量，age整数型结果变量

#标准化：神经网络的运行最好是输入数据缩放到0附近
normalize <- function(x) {
  return((x - min(x))/(max(x) - min(x)))
}


conc_norm <- as.data.frame(lapply(conc, normalize))

summary(conc_norm$strength)
summary(conc$strength)

#划分数据为训练集和测试集
conc_train <- conc_norm[1:773, ]
conc_test <- conc_norm[774:1030, ]



# 3 基于数据训练模型
# 为了对混凝土中使用的原料和最终产品的强度之间的关系建立模型
# 使用一个多层前馈神经网络
library(neuralnet)
#neuralnet(formula, data, hidden = 1, threshold = 0.01,        
#          stepmax = 1e+05, rep = 1, startweights = NULL, 
#          learningrate.limit = NULL, 
#          learningrate.factor = list(minus = 0.5, plus = 1.2), 
#          learningrate=NULL, lifesign = "none", 
#          lifesign.step = 1000, algorithm = "rprop+", 
#          err.fct = "sse", act.fct = "logistic", 
#          linear.output = TRUE, exclude = NULL, 
#          constant.weights = NULL, likelihood = FALSE)


# deault: 1 hidden nodes:默认隐藏层中神经元的数目为1
conc_model <- neuralnet(strength ~ 
                          cement + slag + ash + water + superplastic + coarseagg + fineagg + age, 
                        data = conc_train)
# 可视化网络拓扑结构
plot(conc_model)
# 8个输入节点，1个隐藏节点和1个输出节点，
# 偏差项带有1，误差平方和SSE的度量指标，训练步数steps


# 4 评估模型的性能
# 基于测试集使用compute()函数生成预测
# compute()与predict()不一样，它返回一个带有两个分量的列表
# $neurons(存储网络中每一层的神经元)和$net.results(存储预测值)
model_results <- compute(conc_model, conc_test[1:8])

pred_strength <- model_results$net.result

#这是数值预测问题而不是分类问题，获取预测值与真实值之间的相关性
cor(pred_strength, conc_test$strength)
#cor=0.80

# 5 通过模型的性能
conc_model2 <- neuralnet(strength ~ 
                           cement + slag + ash + water + superplastic + coarseagg + fineagg + age, 
                         data = conc_train, 
                         hidden = 5)
plot(conc_model2)

model_results2 <- compute(conc_model2, conc_test[1:8])

pred_strength2 <- model_results2$net.result

cor(pred_strength2, conc_test$strength)
# cor=0.93


# 结果发现SSE减少，steps增大（隐藏层变为5个，复杂多了），而cor明显提高





