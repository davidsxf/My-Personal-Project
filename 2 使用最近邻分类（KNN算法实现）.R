# KNN算法：用于分类的近邻方法是通过KNN算法实现的
# 优点：简单且有效；对数据的分布没有要求；训练阶段很快
# 缺点：不产生模型；在发现特征之间关系上的能力有限；需要大量的内存；名义变量特征和缺失数据需要额外处理


# KNN算法将特征处理为一个多维特征空间内的坐标。

# 1 计算距离：距离函数（欧式距离——直线距离）
# 2 选择合适的K值：确定用于KNN算法的邻居数量将决定把模型推广到未来数据时模型的好坏。
#                  k的选取取决于要学习概念的难度和训练数据中案例的数量，通常取3~10，常见做法是取
#                  训练集中案例数量的平方根。
# 3 准备KNN算法使用的数据：使用一种重新缩放各种特征的方法，使得每个特征对距离贡献相对平均，
#           对KNN算法的特征进行重新调整的传统方法是min-max标准化，将特征转化为0~1的范围内
#                                      或者使用Z-score标准化方法
# 4 欧式距离转化为数值型变量——哑变量编码，1表示一个类别，0表示其他类别
# KNN算法是懒惰的，没有抽象化——一般化过程，高度依赖于训练案例或实例，不需要建立模型，非参数学习

# 案例分析：用KNN算法诊断乳腺癌


# 1 收集数据

# 2 探索和准备数据
# 1）加载工作目录
# 2）读入数据
wbcd<-read.csv("wisc_bc_data.csv",stringsAsFactors=FALSE)
wbcd
# 使用str()可以确认数据是由569个案例和32个特征构成的
str(wbcd)

# 3）处理第一个变量名为ID 的整型变量，
#    这是每个病人在数据中唯一的表示符，它不能提供有用的信息，需要从模型中剔除
#    不管是什么机器学习算法，ID变量总要被剔除的
wbcd<-wbcd[-1]   #剔除第一列ID

# 4）处理diagnosis特征，表示我们希望预测的结果
table(wbcd$diagnosis)
# 我们要将他编码为因子类型
wbcd$diagnosis<-factor(wbcd$diagnosis,levels = c("B","M"),
                       labels = c("Benign","Malignant"))

# prop.table()显示比例
round(prop.table(table(wbcd$diagnosis))*100,digits = 1)

# 5)其它30个特征都为数值型，与预期一样，有10个细胞核特征的3种不同测量构成
# 观察3个特征的描述性统计量：发现特征的测量尺度（min和max相差较大，需要标准化），
# 其中area_mean比smoothness_mean影响大很多
summary(wbcd[c("radius_mean","area_mean","smoothness_mean")])

# 6)标准化normalize
#   自定义函数normalize
normalize<-function(x) {
  return((x-min(x))/(max(x)-min(x)))
}
wbcd_n<-as.data.frame(lapply(wbcd[2:31],normalize))
summary(wbcd_n$area_mean)

# 7) 训练数据集和测试数据集
# 由于缺少数据，我们将569个案例数据分成两部分来模拟
# 一部分：用来建立KNN模型的训练数据集；
# 另一部分：用来估计模型预测准确性的测试数据集。
# 前469条记录作为训练数据集，剩下100条记录用来模拟新的病人

wbcd_train<-wbcd_n[1:469, ]      #训练数据集，第1——469行所有列
wbcd_test<-wbcd_n[470:569, ]     #测试数据集，第470——569行所有列

# 该代码使用wbcd数据框第一列的diagnosis因子，
# 并且创建了wbcd_train_labels和wbcd_test_labels两个标签向量
wbcd_train_labels<-wbcd[1:469,1]
wbcd_test_labels<-wbcd[470:569,1]

# 3 基于数据训练模型
# 加载class包,提供了包中的knn()函数
# knn(train, test, cl, k = 1, l = 0, prob = FALSE, use.all = TRUE)
library(class)   
# 因为训练数据集为469，所以k=21，开根，用奇数减少各个投票中所包含的邻居数量
wbcd_test_pred<-knn(train=wbcd_train,test=wbcd_test,
                    cl=wbcd_train_labels,
                    k=21)
# knn()返回一个因子向量，测试数据集中的每一个案例返回一个预测标签，wbcd_test_pred


# 4 评估模型的性能
# 评估wbcd_test_pred向量中预测的分类与wbcd_test_labels向量中已知的值的匹配程度如何
library(gmodels)
CrossTable(x=wbcd_test_labels,y=wbcd_test_pred,prop.chisq = T)

# 主对角线：knn算法与真实标签一致
# 副对角线：knn算法与真实标签不一致
# 尽管KNN是一个简单的算法，但是却能够处理极其复杂的任务










# 5 提高模型的性能
# 重新调整数值特征或尝试几个不同的k值
# 法一：转换——Z-score标准化
#       使用scale()函数提供的一个额外好处就是能够直接应用于数据框
wbcd_z<-as.data.frame(scale(wbcd[-1]))
summary(wbcd_z$area_mean)
#使用z-score标准化后的均值应该始终为0，而且其值域应该非常紧凑
wbcd_train<-wbcd_z[1:469, ]
wbcd_test<-wbcd_z[470:569, ]
wbcd_train_labels<-wbcd[1:469,1]
wbcd_test_labels<-wbcd[470:569,1]
wbcd_test_pred<-knn(train = wbcd_train,test = wbcd_test,
                    cl=wbcd_test_labels,
                    k=21)
CrossTable(x=wbcd_test_labels,y=wbcd_test_pred,prop.chisq = T)


# 法二：测试其他K值
































