# -*- coding: utf-8 -*-
"""
Created on Thu Oct 20 22:39:34 2016

@author: zydeve
"""

# K最邻近  KNN（K-Nearest Neighbor）
'''
导入numpy matplotlib.pyplot   matplotlib.colors    以及sklearn内置的数据集datasets和KNN算法包   
'''
import numpy as np
import matplotlib.pylab as plt
from matplotlib.colors import ListedColormap
from sklearn import neighbors,datasets

# 1
# 加载内置的数据集iris
iris=datasets.load_iris()

# 内置的数据集分别datasetName.data和datasetName.target中
print(iris.data)[0:5]    #打印前五行
print(iris.target)       #target包含数据集的类别标签，150个值


# 2
X=iris.data[:,: 2]       #取出数据集的前两个属性所在的列存储到变量X中
Y=iris.target            #取出类别标签所在的列到变量y中
clf=neighbors.KNeighborsClassifier(n_neighbors=15,weights='uniform').fit(X,Y) 
 #训练KNN分类器，设置最近邻数为15，权重参数为uniform（每个点被赋予相等的权重），导入数据到fit()对模型进行训练

print clf   #查看模型参数设置情况

# 3
# 为了将不同类别点所在的区域用不同的颜色进行填充，我们需要通过创建网格来方便绘图。
h= .02      #设置步长为0.02

# 设置网络横纵坐标的最小值和最大值，限定范围
x_min,x_max=X[: , 0].min()-1,X[: , 0].max()+1
y_min,y_max=X[: , 1].min()-1,X[: , 1].max()+1

# np.arange(x_min,x_max,h)生成起始值x_min，终值为x_max，且步长为0.02的等差数列，
# meshgrid()将生成两个矩阵，将两个等差数列分别以行和列进行填充
xx,yy=np.meshgrid(np.arange(x_min,x_max,h),np.arange(y_min,y_max,h))

# ravel()两个矩阵变为按顺序输出的一维数组，np_c()两组一维数组，两两组队，形成网格中的点
# clf.predict()预测这些点所属的类别
Z=clf.predict(np.c_[xx.ravel(),yy.ravel()])

#查看网络的创建过程
xx
yy
xx.ravel()
yy.ravel()
np.c_[xx.ravel(),yy.ravel()]
Z


# 4 设定网格和点的填充颜色，分别用三种颜色表示
cmap_light=ListedColormap(['#FFAAAA','#AAFFAA','#AAAAFF'])
#cmap_bold=ListedColormap('#FF0000','#00FF00','#0000FF')
Z=Z.reshape(xx.shape)
plt.figure()                             #调用figure创建一个绘图对象，并且使它成为当前的绘图对象

plt.pcolormesh(xx,yy,Z,cmap=cmap_light)  #按照预测结果为网格填充颜色

#plt.scatter(X[: , 0],X[: , 1],c=Y,cmap=cmap_bold,marker='o')   #按照原始类别标签为所有的点填充颜色
plt.scatter(X[: , 0],X[: , 1],c=Y,marker='o')
plt.xlim(xx.min(),xx.max())   #画出横坐标的刻度
plt.ylim(yy.min(),yy.max())   #画出纵坐标的刻度

plt.title("3-Class classification (k=% i,weights='distance')")

plt.show()                    #最后调用plt.show()显示创建的所有绘图对象




# 5 计算一下正确率
correct=0.0
for i in range(len(iris.data)):    #计算正确标记的个数
    if Z[i]==iris.target[i]:
        correct+=1

correct/len(iris.data)             #正确率=正确标记个数/总数