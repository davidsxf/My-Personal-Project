# 规则学习：应用在导致机械设备出现硬件故障的条件，描述人群的界定特征用于客户细分，
#           发现先于股票市场上股票价格大跌或者大涨的市况

# 分类规则代表的是if-else逻辑语句形式的知识，可以来对未标记的案例指定一个分类，
# 未标记的案例依据前件和后件的概念而指定，而前件和后件就构成了一个假设：
# 如果前件发生，那么那种情况就会发生


#案例分析：识别有毒蘑菇
# 1 收集数据
m <- read.csv("mushrooms.csv", stringsAsFactors = TRUE)
m$veil_type <- NULL

# 2 探索和准备数据
table(m$type)

# 3 基于数据训练模型：单规则（1R）算法
library(RWeka)
# One R rule learner
m_1R <- OneR(type ~ ., data = m)
m_1R


# 4 评估模型的性能
summary(m_1R) 



# 5 提高模型的性能——RIPPER分类规则算法
# RIPPER algorithm
m_JRip <- JRip(type ~ ., data = m)
m_JRip




