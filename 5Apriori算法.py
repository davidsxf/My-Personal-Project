# -*- coding: utf-8 -*-
'''
Apriori算法：
Scikit-Learn没有提供关联分析的算法，使用机器学习库Orange实现关联分析算法
Orange是一个基于组件的额数据挖掘和机器学习的套装，支持可视化编程前端，提供大量可视化方法。
'''
import Orange
data=Orange.data.Table("lenses")   # 加载数据集
print data.domain.features         # 打印数据集特征
print data.domain.class_var        # 打印目标变量
for d in data[: 3]:                # 打印数据特征值的前三列
    print d

rules=Orange.associate.AssociationRulesInducer(data,support=0.3)
for r in rules:
    print "% 5.3f % 5.3f % s" % (r.support,r.confidence,r)
    