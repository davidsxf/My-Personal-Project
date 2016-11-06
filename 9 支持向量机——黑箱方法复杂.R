# 支持向量机SVM
# SVM可以想象成一个平面，该平面定义了各个数据点之间的界线，
# 而这些数据点代表根据它们的特征值绘制在多维空间中的案例
# SVM的目标是创建一个平面边界，称为一个超平面，使得任何一边的数据都是相当均匀

# SVM集合了最近邻学习和线性回归建模两个方面，功能及其强大，对于非常复杂的关系进行建模

# SVM几乎可以适用于所有的学习任务，包括分类和数值预测两个方面，
# 许多算法的实现都是来自模式识别
# 如：鉴定文档或者组织文档的语言、事件检测等等

# 支持向量机SVM用于二元分类时，最容易理解，我们专注于SVM分类器

# 1 超平面分类
# 支持向量机算法的任务就是确定一条用于分割两个类别的线，
# 圆形组和正方形组之间的分割线不止一种选择，怎么选择

# 2 寻找最大间隔
# 创建两个类之间最大间隔的 最大间隔平面MMH


# 1）线性可分的数据情况：在类是线性可分的假设下，容易理解
#    MMH就是两组凸包之间最短距离直线的垂直平分线

# 2）非线性可分的数据情况
# 引入松弛变量



# 3 对非线性空间使用核函数
# 使用核技巧将问题映射到一个更高维的空间中，非线性问题转化成线性问题了
# 获得看数据的新的视角，如：俯瞰——————侧看
# 具有非线性核的SVM是及其强大的分类器！！！！！！

# 优点：准确性高，数据挖掘中经常使用，比神经网络更容易使用；
# 缺点：需要测试不同的核函数和模型参数的组合,训练缓慢，复杂的黑箱问题

# 常用核函数：
#           线性核函数、多项式核函数、S形核函数、高斯RBF核函数

# 案例分析：用SVM进行光学字符识别
# SVM非常适合处理图像数据带来的挑战，能够学习复杂的图案而不需要对噪声过度敏感，
#     能够以非常高的准确度识别光学图案。

#加载工作目录
# 1 收集数据
let <- read.csv("letterdata.csv")
str(let)
#支持向量机要求所有的特征都是整数型的，
#而且每一个特征需要缩小到一个相当小的区间中，不需要将任意一个因子转换成数字



#训练和测试
let_train <- let[1:16000, ]
let_test <- let[16001:20000, ]


# 3 基于数据训练模型：著名的包e1071/klaR/kernlab

# linear kernel (vanilla)

# kernlab包可以与caret包一起使用，
# 允许支持向量机模型可以使用各种自动化方法进行训练和评估
library(kernlab)
let_classifier <- ksvm(letter ~ ., data = let_train, kernel = "vanilladot")
let_classifier
# kernel:给出隐式非线性映射，
# rbfdot径向基函数、polydot多项式函数、tanhdot双曲正切函数、vanilladot线性函数


# 4 评估模型的性能
let_pred <- predict(let_classifier, let_test)

head(let_pred)
table(let_pred, let_test$letter)#测试数据集中的预测值与真实值进行比较



#返回一个元素T或F值的向量，表示在测试数据集中，模型预测的字母是否与真实的字母的相符
agreement <- let_pred == let_test$letter
table(agreement)
prop.table(table(agreement))


# 5 提高模型的性能
# RBF kernel

let_classifier2 <- ksvm(letter ~ ., data = let_train, kernel = "rbfdot")
let_classifier2
let_pred2 <- predict(let_classifier2, let_test)



agreement2 <- let_pred2 == let_test$letter
table(agreement2)
prop.table(table(agreement2))
#识别模型的准确度从0.84提高到0.93














