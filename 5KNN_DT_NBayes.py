# -*- coding: utf-8 -*-
"""
Created on Sat Oct 22 11:59:14 2016

@author: zydeve

三中分类方法的总结：KNN     DT     NBayes

"""
import numpy as np
import matplotlib.pylab as plt
from matplotlib.colors import ListedColormap
from sklearn.cross_validation import train_test_split
from sklearn.preprocessing import  StandardScaler
from sklearn.datasets import make_moons,make_circles
from sklearn.datasets import make_classification
from sklearn.neighbors import  KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.naive_bayes import GaussianNB

h= .02
names=["Nearest Neighbors","Decision Tree","Naive Bayes"]
classifiers=[
    KNeighborsClassifier(3),
    DecisionTreeClassifier(max_depth=5),
    GaussianNB()]
    
# 生成三种形态的数据集
X,Y=make_classification(n_features=2,n_redundant=0,n_informative=2,
                        random_state=1,n_clusters_per_class=1)
rng=np.random.RandomState(2)
X+=2*rng.uniform(size=X.shape)
linearly_separable=(X,Y)

datasets=[make_moons(noise=0.3,random_state=0),
          make_circles(noise=0.2,factor=0.5,random_state=1),
          linearly_separable
         ]
         
figure=plt.figure(figsize=(18,6))

i=1
for ds in datasets:
    #处理数据，数据标准化后分为测试集和训练集，测试集占比为30%
    X,Y=ds
    X=StandardScaler().fit_transform(X)
    X_train,X_test,Y_train,Y_test=train_test_split(X,Y,test_size= .3)
    x_min,x_max=X[: , 0].min()- .5,X[: , 0].max()+ .5
    y_min,y_max=X[: , 1].min()- .5,X[: , 1].max()+ .5
    xx,yy=np.meshgrid(np.arange(x_min,x_max,h),
                      np.arange(y_min,y_max,h))
                      
    #画出原始数据点
    cm=plt.cm.RdBu
    cm_bright=ListedColormap(['#FF0000','#0000FF'])
    ax=plt.subplot(len(datasets),len(classifiers)+1,i)
    
    #填充训练集中的点
    ax.scatter(X_train[: , 0],X_train[: , 1],c=Y_train,cmap=cm_bright)
    
    #填充测试集中的点
    ax.scatter(X_test[: , 0],X_test[: , 1],c=Y_test,cmap=cm_bright,alpha=0.6)
    
    #设置x轴和y轴的范围
    ax.set_xlim(xx.min(),xx.max())
    ax.set_ylim(yy.min(),yy.max())
    
    #设置x轴和y轴的刻度
    ax.set_xticks(())
    ax.set_yticks(())
    i+=1
    
    



#画出每个模型的数据点和决策边界
for name,clf in zip(names,classifiers):
    ax=plt.subplot(len(datasets),len(classifiers)+1,i)
    clf.fit(X_train,Y_train)
    score=clf.score(X_test,Y_test)   #计算模型分数
    
    #画出决策边界，为此我们需要为网络中的每一个点预测一个颜色
    Z=clf.predict_proba(np.c_[xx.ravel(),yy.ravel()])[: , 1]
    # Put the result into a color plot
    Z=Z.reshape(xx.shape)
    ax.contourf(xx,yy,Z,cmap=cm,alpha= .8)
    
    #填充训练集中的点
    ax.scatter(X_train[: , 0],X_train[: , 1],c=Y_train,cmap=cm_bright)
    #填充测试集中的点
    ax.scatter(X_test[: , 0],X_test[: , 1],c=Y_test,cmap=cm_bright,alpha=0.6)
    ax.set_xlim(xx.min(),xx.max())
    ax.set_ylim(yy.min(),yy.max())
    ax.set_xticks(())
    ax.set_yticks(())
    ax.set_title(name)
    
    #在图的右下角标记模型分数
    ax.text(xx.max()- .3,yy.min()+ .3,('% .2f'% score).lstrip('0'),
            size=15,horizontalalignment='right')
    i+=1
    
    
figure.subplots_adjust(left= .02,right= .98)
plt.show()



