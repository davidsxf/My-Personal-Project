# 朴素贝叶斯分类——概率学习
# 依据概率原则进行分类的朴素贝叶斯算法
# ：利用先前事件的有关数据来估计未来事件发生的概率
# 贝叶斯分类器应用：文本分类（垃圾邮件、作者识别和主题分类）
#               在计算机网络中进行入侵检测或者异常检测
#               根据一组观察到的症状，诊断身体状况


# 贝叶斯方法的基本思想：一个事件的似然估计应建立在手中已有的证据的基础上，
#             事件：就是可能的结果；
#             试验：就是事件发生一次的机会
# 贝叶斯定理：概率 联合概率 条件概率
#            后验概率=似然概率*先验概率/边际似然概率

# 1 朴素贝叶斯算法：Naive Bayes NB(已经成为文本分类的准则)
#   在NB中使用将数值型特征值离散化，将数值分到不同的分段中。




# 2 案例分析：基于贝叶斯算法的手机垃圾短信过滤

# 1）收集数据
# 2）探索数据和准备数据
##################   加载工作目录并读取数据集
sms_raw <- read.csv("sms_spam.csv", stringsAsFactors = FALSE)
str(sms_raw)
# 使用数据结构探索函数str()，可以看到数据文件包含了5559条短信，
# 每条短信有两个特征type和text

# type 是字符型变量，是个分类变量 转化为因子
sms_raw$type <- factor(sms_raw$type)

#变量重新编码为因子
str(sms_raw$type)

#747条短信被标记为spam
table(sms_raw$type)


####################数据准备——处理和分析文本数据
library(tm)  #短信是由词、空格、数字和标点符号组成的文本字符串，加载tm文本数据挖掘包

##################创建一个语料库
sms_corpus <- Corpus(VectorSource(sms_raw$text))
# 函数corpus()创建了一个R对象来存储文本文档，
# 用函数vectorsource()来指示函数corpus()使用向量sms_raw$text的信息

print(sms_corpus)  #用函数print()输出我们刚刚创建的语料库，我们将会看到语料库训练数据中5559条
# 查看语料库的内容，使用函数inspect()，查看第一二三短信具体内容
inspect(sms_corpus[1:3])

################# tm_map()提供一种用来转换tm语料库的方法，
#                         将使用一系列转换函数来清理我们的语料库
##所有短信的字母变成小写字母，并去除所有的数字
corpus_clean <- tm_map(sms_corpus, tolower)  
corpus_clean <- tm_map(corpus_clean, removeNumbers)

##去除填充词
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords())

##去除标点符号
corpus_clean <- tm_map(corpus_clean, removePunctuation)

##去除额外的空格
corpus_clean <- tm_map(corpus_clean, stripWhitespace)

################## 函数DocumentTermMatrix()将一个语料库作为输入，
#                  并创建一个称为稀疏矩阵的数据结构，将语料库标记化
sms_dtm <- DocumentTermMatrix(corpus_clean)

# 分解原始数据框
sms_raw_train <- sms_raw[1:4169, ]
sms_raw_test <- sms_raw[4170:5559, ]


#输出文档单词矩阵
sms_dtm_train <- sms_dtm[1:4169, ]
sms_dtm_test <- sms_dtm[4170:5559, ]


#得到语料库
sms_corpus_train <- corpus_clean[1:4169]
sms_corpus_test <- corpus_clean[4170:5559]

prop.table(table(sms_raw_train$type))
prop.table(table(sms_raw_test$type))

#可视化文本数据——词云，观察社交媒体网站上的热门话题的方式
library(wordcloud)
library(RColorBrewer)
#wordcloud(words,freq,scale=c(4,.5),min.freq=3,max.words=Inf,
#         random.order=TRUE, random.color=FALSE, rot.per=.1,
#         colors="black",ordered.colors=FALSE,use.r.layout=FALSE,
#         fixed.asp=TRUE, ...)
wordcloud(sms_corpus_train, min.freq = 40, random.order = FALSE)
# 词云中的单词在语料库中出现的最小次数为40，random.order=FALSE非随机的顺序排列


#获取子集
spam <- subset(sms_raw_train, type == "spam")
ham <- subset(sms_raw_train, type == "ham")

#绘制垃圾短信spam和非垃圾短信ham的词云
wordcloud(spam$text, max.words = 40, scale = c(3, 0.5))
wordcloud(ham$text, max.words = 40, scale = c(3, 0.5))

findFreqTerms(sms_dtm_train, 5)

# build a dictionary
sms_dict <- Dictionary(findFreqTerms(sms_dtm_train, 5))

# limit the training and test sets to only words from the dictionary
sms_train <- DocumentTermMatrix(sms_corpus_train, list(dictionary = sms_dict))
sms_test <- DocumentTermMatrix(sms_corpus_test, list(dictionary = sms_dict))

#转换成因子
convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x, levels = c(0, 1), labels = c("No", "Yes"))
  return(x)
}


sms_train <- apply(sms_train, MARGIN = 2, convert_counts)
sms_test <- apply(sms_test, MARGIN = 2, convert_counts)



# 3 基于数据训练模型：应用朴素贝叶斯算法
# need e1071 package for Naive Bayes
library(e1071)
sms_classifier <- naiveBayes(sms_train, sms_raw_train$type)

# 4 评估模型的性能
sms_test_pred <- predict(sms_classifier, sms_test)


library(gmodels)
CrossTable(sms_test_pred, sms_raw_test$type, 
           prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))


# 5 提升模型的性能

sms_classifier2 <- naiveBayes(sms_train, sms_raw_train$type, 
                              laplace = 1)
sms_test_pred2 <- predict(sms_classifier2, sms_test)
CrossTable(sms_test_pred2, sms_raw_test$type, 
           prop.chisq = FALSE, 
           prop.t = FALSE, prop.r = FALSE, dnn = c('predicted', 'actual'))







