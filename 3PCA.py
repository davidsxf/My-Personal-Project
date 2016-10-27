# -*- coding: utf-8 -*-
# 主成分分析法的计算步骤
# 1计算协方差相关系数矩阵
# 2求出相关系数的特征值和相应的正交化单位特征向量
# 3选择主成分
# 4计算主成分载荷：累计贡献率大于85%就能足够反应原来变量的信息了
# 5计算主成分得分
from numpy import *
import matplotlib.pyplot as plt

def loadDataSet(fileName, delim='\t'):
    fr = open(fileName)
    stringArr = [line.strip().split(delim) for line in fr.readlines()]
    datArr = [map(float,line) for line in stringArr]
    return mat(datArr)

def pca(dataMat, topNfeat=9999999):
    meanVals = mean(dataMat, axis=0)
    meanRemoved = dataMat - meanVals          #remove mean减去平均值
    covMat = cov(meanRemoved, rowvar=0)
    eigVals,eigVects = linalg.eig(mat(covMat))
    eigValInd = argsort(eigVals)              #sort, sort goes smallest to largest计算特征值和特征向量
    eigValInd = eigValInd[:-(topNfeat+1):-1]  #cut off unwanted dimensions保留最大的前K个特征值
    redEigVects = eigVects[:,eigValInd]       #reorganize eig vects largest to smallest对应的特征向量
    lowDDataMat = meanRemoved * redEigVects   #transform data into new dimensions重构数据用于调试
    reconMat = (lowDDataMat * redEigVects.T) + meanVals
    return lowDDataMat, reconMat

def plotBestFit(dataSet1,dataSet2):      
    dataArr1 = array(dataSet1)
    dataArr2 = array(dataSet2)
    n = shape(dataArr1)[0] 
    n1=shape(dataArr2)[0]
    xcord1 = []; ycord1 = []
    xcord2 = []; ycord2 = []
    xcord3=[];ycord3=[]
    j=0
    for i in range(n):
        
            xcord1.append(dataArr1[i,0]); ycord1.append(dataArr1[i,1])
            xcord2.append(dataArr2[i,0]); ycord2.append(dataArr2[i,1])
                   
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(xcord1, ycord1, s=30, c='red', marker='s')
    ax.scatter(xcord2, ycord2, s=30, c='green')
    
    plt.xlabel('X1'); plt.ylabel('X2');plt.title('PCA')
    plt.show()    

if __name__=='__main__':
     mata=loadDataSet('testSet.txt')  
     a,b= pca(mata, 2)
     plotBestFit(a,b)
     
'''
loadDataSet函数是导入数据集。
PCA输入参数：参数一是输入的数据集，参数二是提取的维度。比如参数二设为1，那么就是返回了降到一维的矩阵。

PCA返回参数：参数一指的是返回的低维矩阵，对应于输入参数二。参数二对应的是移动坐标轴后的矩阵。

上一张图，绿色为原始数据，红色是提取的2维特征。
'''