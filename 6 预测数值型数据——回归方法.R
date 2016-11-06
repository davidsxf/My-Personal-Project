#线性回归方法来拟合数据方程的基本统计原则和它们如何描述数据元素之间的关系；
#用R做回归模型
#使用回归树和模型树的混合模型，使得决策树可以用来预测数值型数据

# 案例分析：线性回归预测医疗费用（保险公司设定年度保费）

#加载工作空间


# 1 收集数据
# insurance.csv美国病人的医疗费用



# 2 探索和准备数据 
ins <- read.csv("insurance.csv", stringsAsFactors = TRUE)
str(ins)
# 包含1338个案例，即目前已经登记过的保险计划受益者以及
#                 表示病人特点和历年计划收入的总的医疗费用的特征
# 7个变量：age sex bmi(身体质量指数) children smoker region charges
# 其中age sex smoker为因子类型

# 因变量
summary(ins$charges)
hist(ins$charges)
#保险费用严重左偏，因为线性回归假设因变量的分布为正态分布，这种分布不理想

table(ins$region)


#1）探索特征之间的关系——相关系数矩阵
cor(ins[c("age", "bmi", "children", "charges")])


#2）可视化特征之间的关系——散点图矩阵
pairs(ins[c("age", "bmi", "children", "charges")])

#改进后的散点图
library(psych)
pairs.panels(ins[c("age", "bmi", "children", "charges")])
# 在对角线上方，散点图被相关系数矩阵所取代
# 对角线上，直方图描绘了每个特征的数值分布
# 对角线下方，散点图带有额外的可视化信息
# 解释：每个散点图呈椭圆形的对象称为相关椭圆，
#       它提供了一种变量之间是如何密切相关的可视化信息，
#       椭圆中心的点表示x轴变量的均值和y轴变量的均值所确定的点
# 两个变量之间的相关性有椭圆的形状确定，椭圆越被拉伸，相关性越强
# 散点图中绘制的曲线称为“局部回归平滑”，它表示x轴和y轴变量之间的一般关系。


# 3 基于数据训练模型
# 用R对数据拟合一个线性回归，可以使用lm()函数，该函数包含在stats添加包
ins_model <- lm(charges ~ age + children + bmi + sex + smoker + region, data = ins)
ins_model
#ins_model <- lm(charges ~ ., data = ins)  #等价于上面的，因为符号.可以指定所有的特征



# 4 评估模型的性能
summary(ins_model)



# 5 提高模型的性能
# 回归模型和其他机器学习方法的一个关键区别就在于回归会让使用者选择特征和设定模型

# 1）模型的设定——添加非线性关系
ins$age2 <- ins$age^2                   #将非线性年龄添加到模型中，创建一个新的变量
#当我们建立改进后的模型时，我们将把age和age2都添加到lm()公式中


# 2）转换——将一个数值型变量转换为一个二进制指标
ins$bmi30 <- ifelse(ins$bmi >= 30, 1, 0)
#大于等于30，返回1，否则返回0
#改进的模型中包含bmi30变量，是取代原来的bmi,还是补充，
#方法是包含他并检验其显著性水平，变量在统计上不显著，那么就有证据支持在将来排除该变量



# 3）模型的设定——加入相互作用的影响
# 当两个特征存在共同的影响时，称为相互作用
#肥胖指标bmi30与吸烟指标smoker的相互作用bmi30*smoker


######## 4）全部放在一起——一个改进的回归模型

ins_model2 <- lm(charges ~ age + age2 + children + bmi + sex + bmi30*smoker + region, 
                 data = ins)

summary(ins_model2)


#与ins_models2,还是ins_models2显著，但是比ins_models1显著
ins_model3 <- lm(charges ~ age + age2 + children + bmi30 + sex + smoker + region, 
                 data = ins)

summary(ins_model3)









