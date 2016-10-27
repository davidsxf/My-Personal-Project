# -*- coding: utf-8 -*-

# Naive Bayesian朴素贝叶斯

# python提供了三种的朴素贝叶斯方法：
# GaussianNB   （MultinomialNB   BernoulliNB）
# 连续值                离散数据 

import numpy as np
from sklearn.naive_bayes import GaussianNB
from sklearn import  metrics
from sklearn.preprocessing import  StandardScaler
from sklearn.cross_validation import train_test_split
from sklearn.datasets import  load_iris
iris=load_iris()

X=iris.data
Y=iris.target 
idx=np.arange(X.shape[0])
np.random.seed(13)
np.random.shuffle(idx)    #打乱数据集
X=X[idx]
Y=Y[idx]
X=StandardScaler().fit_transform(X) #标准化数据

#利用 scikit-learn提供的方法分割数据集
X_train,X_test,Y_train,Y_test=train_test_split(X,Y,test_size= .25)  
gnb=GaussianNB()   #建模
pre=gnb.fit(X_train,Y_train).predict(X_test)    #训练数据并预测
print(metrics.classification_report(Y_test,pre,target_names=iris.target_names))
